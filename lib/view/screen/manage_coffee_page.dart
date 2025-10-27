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

  @override
  void initState() {
    super.initState();
    debugPrint("📲 ManageProductsScreen: initState called");

    final adminId = AuthController.instance.currentAdmin.value?.id;
    debugPrint("👤 Current Admin ID on init: $adminId");

    if (adminId != null) {
      debugPrint("🚀 Fetching coffees for admin $adminId (initState)");
      controller.fetchAllCoffees(adminId);
    } else {
      debugPrint("⚠️ No admin found during initState, waiting for admin listener...");
    }

    // Listen for admin changes
    ever(AuthController.instance.currentAdmin, (admin) {
      debugPrint("🔁 Admin listener triggered: $admin");
      if (admin != null) {
        debugPrint("✅ Admin detected (${admin.id}), refetching coffees...");
        controller.fetchAllCoffees(admin.id);
      } else {
        debugPrint("🧹 Admin is null, clearing coffeeList");
        controller.coffeeList.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🧩 ManageProductsScreen: build() called");

    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          Obx(() {
            debugPrint("👀 Obx rebuild triggered");
            debugPrint("🧮 Coffee list length: ${controller.coffeeList.length}");
            debugPrint("🔄 isLoading: ${controller.isLoading.value}");

            if (controller.isLoading.value && controller.coffeeList.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFD7CCC8)),
                ),
              );
            }

            if (controller.coffeeList.isEmpty && !controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No products found. Add some coffee!',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final coffee = controller.coffeeList[index];
                  return CompactCoffeeCard(coffee: coffee);
                },
                childCount: controller.coffeeList.length,
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCoffeePage()),
          );
          final adminId = AuthController.instance.currentAdmin.value?.id;
          if (adminId != null) {
            controller.fetchAllCoffees(adminId);
          }
        },
        backgroundColor: const Color(0xFFD7CCC8),
        foregroundColor: const Color(0xFF3E2723),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

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
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: const Color(0xFF6D4C41),
          child: _buildCategoryChips(),
        ),
      ),
    );
  }

  Widget _buildAppBarContent() {
    return Column(
      children: [
        // Removed top row (menu + title + notifications)
        const Text(
          'Manage Products',
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
                    hintText: 'Search by name...',
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

  Widget _buildCategoryChips() {
    final categories = ['All', 'Hot Coffee', 'Iced Coffee', 'Pastries', 'Tea', 'Sandwiches'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Row(
        children: categories.map((c) => _buildChip(c, isSelected: c == 'All')).toList(),
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF3E2723) : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        backgroundColor: isSelected ? const Color(0xFFD7CCC8) : const Color(0xFF5D4037),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
