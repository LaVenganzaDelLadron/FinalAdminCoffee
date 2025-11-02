import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cards/store_card.dart';
import '../controller/store_controller.dart';
import '../controller/auth_controller.dart';
import 'add_store_page.dart';

class ManageStoreScreen extends StatefulWidget {
  const ManageStoreScreen({super.key});

  @override
  State<ManageStoreScreen> createState() => _ManageStoreScreenState();
}

class _ManageStoreScreenState extends State<ManageStoreScreen> {
  final StoreController controller = Get.put(StoreController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();

    // Listen for search input changes
    searchController.addListener(() {
      _applySearchFilter(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final adminId = AuthController.instance.currentAdmin.value?.id?.toString() ?? '';
    if (adminId.isNotEmpty) {
      await controller.fetchAllStores();
      _applySearchFilter(searchController.text);
    }
  }

  Future<void> _refreshData() async {
    await controller.fetchAllStores();
    _applySearchFilter(searchController.text);
  }

  void _applySearchFilter(String query) {
    if (query.isEmpty) {
      controller.filteredStoreList.value = controller.storeList;
    } else {
      controller.filteredStoreList.value = controller.storeList
          .where((store) =>
      store.name.toLowerCase().contains(query.toLowerCase()) ||
          store.address.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFFD7CCC8),
        backgroundColor: const Color(0xFF4E342E),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            Obx(() {
              if (controller.isLoading.value && controller.storeList.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFD7CCC8)),
                  ),
                );
              }

              final list = controller.filteredStoreList;

              if (list.isEmpty && !controller.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No stores found.',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final store = list[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: CompactStoreCard(
                        store: store,
                        onDelete: _refreshData,
                        onEdit: () {},
                      ),
                    );
                  },
                  childCount: list.length,
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StorePage()),
          );

          if (result == true) {
            _refreshData();
          }
        },
        backgroundColor: const Color(0xFFD7CCC8),
        foregroundColor: const Color(0xFF3E2723),
        icon: const Icon(Icons.add, size: 26),
        label: const Text(
          "Add Store",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      expandedHeight: 160,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D4C41), Color(0xFF3E2723)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        child: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.only(bottom: 20),
          centerTitle: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Manage Stores',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              _buildSearchBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white70,
        decoration: const InputDecoration(
          hintText: 'Search stores...',
          hintStyle: TextStyle(color: Color.fromARGB(180, 255, 255, 255)),
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14, left: 5),
        ),
      ),
    );
  }
}
