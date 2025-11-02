import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cards/coffee_card.dart';
import '../controller/coffee_controller.dart';
import '../controller/auth_controller.dart';
import 'add_coffee_page.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final CoffeeController controller = Get.put(CoffeeController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Initial load
  Future<void> _loadData() async {
    final adminId = AuthController.instance.currentAdmin.value?.id?.toString() ?? '';
    if (adminId.isNotEmpty) {
      await controller.fetchCoffees(adminId);
      _applySearchFilter(searchController.text);
    } else {
      debugPrint("⚠️ No admin ID found in AuthController.");
    }
  }

  // Pull-to-refresh & manual refresh
  Future<void> _refreshData() async {
    final adminId = AuthController.instance.currentAdmin.value?.id?.toString() ?? '';
    if (adminId.isNotEmpty) {
      await controller.fetchCoffees(adminId);
      _applySearchFilter(searchController.text);
      debugPrint("🔄 Data refreshed successfully!");
    }
  }

  // Apply search filter
  void _applySearchFilter(String query) {
    controller.filteredCoffeeList.value = controller.coffeeList
        .where((coffee) =>
        coffee.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E1B13),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFFFFE0B2),
        backgroundColor: const Color(0xFF4E342E),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            Obx(() {
              if (controller.isLoading.value && controller.coffeeList.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFE0B2)),
                  ),
                );
              }

              final list = controller.filteredCoffeeList;

              if (list.isEmpty && !controller.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No products found ☕',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final coffee = list[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: CompactCoffeeCard(coffee: coffee),
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
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCoffeePage()),
          );
          await _refreshData(); // Refresh after adding new coffee
        },
        backgroundColor: const Color(0xFFFFE0B2),
        foregroundColor: const Color(0xFF3E2723),
        icon: const Icon(Icons.add, size: 26),
        label: const Text(
          "Add Product",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Gradient header + search bar
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
            colors: [Color(0xFF5D4037), Color(0xFF3E2723)],
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
                'Manage Products',
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
        onChanged: _applySearchFilter,
        decoration: const InputDecoration(
          hintText: 'Search product...',
          hintStyle: TextStyle(color: Color.fromARGB(180, 255, 255, 255)),
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14, left: 5),
        ),
      ),
    );
  }
}
