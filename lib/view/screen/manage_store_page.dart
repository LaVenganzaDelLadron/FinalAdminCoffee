import 'package:admincoffee/view/screen/store_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cards/store_card.dart';
import '../controller/store_controller.dart';
import '../controller/auth_controller.dart';

class ManageStoreScreen extends StatefulWidget {
  const ManageStoreScreen({super.key});

  @override
  State<ManageStoreScreen> createState() => _ManageStoreScreenState();
}

class _ManageStoreScreenState extends State<ManageStoreScreen> {
  final StoreController controller = Get.put(StoreController());

  @override
  void initState() {
    super.initState();
    debugPrint("🏪 ManageStoreScreen: initState called");

    final adminId = AuthController.instance.currentAdmin.value?.id;
    debugPrint("👤 Current Admin ID on init: $adminId");

    if (adminId != null) {
      debugPrint("🚀 Fetching stores for admin $adminId (initState)");
      controller.fetchAllStores();
    } else {
      debugPrint("⚠️ No admin found during initState, waiting for admin listener...");
    }

    // Listen for admin changes
    ever(AuthController.instance.currentAdmin, (admin) {
      if (admin != null) {
        debugPrint("✅ Admin detected (${admin.id}), refetching stores...");
        controller.fetchAllStores();
      } else {
        debugPrint("🧹 Admin is null, clearing storeList");
        controller.storeList.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      body: CustomScrollView(
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

            if (controller.storeList.isEmpty && !controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No stores found. Add a new store!',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final store = controller.storeList[index];
                  return CompactStoreCard(
                    store: store,
                    onDelete: () => controller.fetchAllStores(),
                    onEdit: () {
                      debugPrint("✏️ Edit tapped for store ${store.id}");
                      // TODO: Navigate to EditStorePage if implemented
                    },
                  );
                },
                childCount: controller.storeList.length,
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate and wait until Add Store page is closed
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StorePage()),
          );

          if (result == true) {
            controller.fetchAllStores();
          }
        },
        backgroundColor: const Color(0xFFD7CCC8),
        foregroundColor: const Color(0xFF3E2723),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
      ),

    );
  }

  // --- AppBar Section ---
  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF6D4C41),
      toolbarHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
          child: _buildAppBarContent(),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Container(color: const Color(0xFF6D4C41)),
      ),
    );
  }

  Widget _buildAppBarContent() {
    return Column(
      children: [
        const Text(
          'Manage Stores',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(25, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search stores...',
                    hintStyle: TextStyle(color: Color.fromARGB(150, 255, 255, 255)),
                    prefixIcon: Icon(Icons.search, color: Color.fromARGB(150, 255, 255, 255)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14, left: 5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF5D4037),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
