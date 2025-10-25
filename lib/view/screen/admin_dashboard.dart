import 'dart:ui';
import 'package:admincoffee/view/screen/category_page.dart';
import 'package:admincoffee/view/screen/coffee_page.dart';
import 'package:flutter/material.dart';
final String adminId = "admin_001";













// --- Dummy controllers ---
class GetCoffeeCountController {
  static final instance = GetCoffeeCountController();
  Future<int> fetchCoffeeCount(String adminId) async => 12;
}

class GetOrderCountController {
  static final instance = GetOrderCountController();
  Future<int> fetchOrderCount() async => 24;
}

class GetProductController {
  static final instance = GetProductController();
  Future<List<String>> fetchAllProducts(String adminId) async => [];
}

class GetOrderController {
  static final instance = GetOrderController();
  Future<List<String>> fetchAllOrder() async => [];
}

class GetStatusOrderController {
  static final instance = GetStatusOrderController();
  Future<List<Order>> fetchOrdersByStatus(String status) async => [
    Order(id: 1),
    Order(id: 2),
  ];
}

class GetTotalrevenueController {
  static final instance = GetTotalrevenueController();
  Future<double> fetchTotalRevenue() async => 12500.50;
}

class GetPendingPaymentController {
  static final instance = GetPendingPaymentController();
  Future<double> fetchPendingPayments() async => 3400.75;
}

// --- Dummy Order model ---
class Order {
  final int id;
  Order({required this.id});
}

// --- Dummy Pages ---


class AllOrderPage extends StatelessWidget {
  final List<String> order;
  const AllOrderPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Orders")),
      body: const Center(child: Text("Orders Page")),
    );
  }
}

class AllCoffeePage extends StatelessWidget {
  const AllCoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Coffee")),
      body: const Center(child: Text("All Coffees Page")),
    );
  }
}

class AllStorePage extends StatelessWidget {
  const AllStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Store")),
      body: const Center(child: Text("All Store Page")),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Profile")),
      body: const Center(
        child: Text(
          "Profile Page Content",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// --- Admin Dashboard with Glass Drawer ---
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.brown,
        title: const Text(
          "☕ CoffeeShop Admin",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildGlassDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome, Admin 👋",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Stats Grid (fixed closing brackets)
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                FutureBuilder<int>(
                  future: GetCoffeeCountController.instance.fetchCoffeeCount(adminId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD7CCC8), Color(0xFFBCAAA4)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return _buildEnhancedStatCard(
                        context,
                        title: "Coffee",
                        value: "0",
                        icon: Icons.coffee,
                        color1: const Color(0xFFBCAAA4),
                        color2: const Color(0xFFD7CCC8),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () async {
                          final orders = await GetOrderController.instance.fetchAllOrder();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllOrderPage(order: orders),
                            ),
                          );
                        },
                        child: _buildEnhancedStatCard(
                          context,
                          title: "Coffee",
                          value: snapshot.data.toString(),
                          icon: Icons.coffee,
                          color1: const Color(0xFF8D6E63),
                          color2: const Color(0xFFBCAAA4),
                        ),
                      );
                    }
                  },
                ),
                FutureBuilder<int>(
                  future: GetOrderCountController.instance.fetchOrderCount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD7CCC8), Color(0xFFBCAAA4)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return _buildEnhancedStatCard(
                        context,
                        title: "Orders",
                        value: "0",
                        icon: Icons.receipt_long,
                        color1: const Color(0xFFBCAAA4),
                        color2: const Color(0xFFD7CCC8),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () async {
                          final orders = await GetOrderController.instance.fetchAllOrder();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllOrderPage(order: orders),
                            ),
                          );
                        },
                        child: _buildEnhancedStatCard(
                          context,
                          title: "Orders",
                          value: snapshot.data.toString(),
                          icon: Icons.receipt_long,
                          color1: const Color(0xFF8D6E63),
                          color2: const Color(0xFFBCAAA4),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),


            const Text(
              "Top Selling Orders",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 8),

            FutureBuilder<List<Order>>(
              future:
              GetStatusOrderController.instance.fetchOrdersByStatus("pending"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(color: Colors.brown),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "⚠️ Failed to load pending orders.",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No pending orders found ☕",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                } else {
                  final orders = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                        child: ListTile(
                          leading:
                          const Icon(Icons.receipt, color: Colors.brown),
                          title: Text(
                            "Order #${order.id}",
                            style:
                            const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Order ID: ${order.id}"),
                          trailing: const Text(
                            "Pending",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            const Text(
              "Revenue Overview",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 12),

            FutureBuilder<double>(
              future: GetTotalrevenueController.instance.fetchTotalRevenue(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildRevenueCard(
                      "Total Revenue", "Loading...", Colors.green);
                } else if (snapshot.hasError) {
                  return _buildRevenueCard(
                      "Total Revenue", "Error", Colors.red);
                } else {
                  final revenue = snapshot.data ?? 0.0;
                  return _buildRevenueCard(
                    "Total Revenue",
                    "₱${revenue.toStringAsFixed(2)}",
                    Colors.green,
                  );
                }
              },
            ),
            FutureBuilder<double>(
              future:
              GetPendingPaymentController.instance.fetchPendingPayments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildRevenueCard(
                      "Pending Payments", "Loading...", Colors.orange);
                } else if (snapshot.hasError) {
                  return _buildRevenueCard(
                      "Pending Payments", "Error", Colors.red);
                } else {
                  final revenue = snapshot.data ?? 0.0;
                  return _buildRevenueCard(
                    "Pending Payments",
                    "₱${revenue.toStringAsFixed(2)}",
                    Colors.orange,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

   Widget _buildRevenueCard(String title, String amount, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.monetization_on, color: color, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  // --- Blurry Glass Drawer ---
  Widget _buildGlassDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: Colors.white.withOpacity(0.25),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.6),
                  ),
                  child: const Center(
                    child: Text(
                      "☕ Coffee Admin",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.dashboard, color: Colors.white),
                  title: const Text("Dashboard",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_box, color: Colors.white),
                  title:
                  const Text("Coffee", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddCoffeePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.store, color: Colors.white),
                  title:
                  const Text("Store", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllStorePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.receipt, color: Colors.white),
                  title:
                  const Text("Orders", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const AllOrderPage(order: [])),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.category, color: Colors.white),
                  title:
                  const Text("Categories", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoryPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.supervised_user_circle_sharp, color: Colors.white),
                  title:
                  const Text("Users", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const AllOrderPage(order: [])),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title:
                  const Text("Settings", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const AllOrderPage(order: [])),
                    );
                  },
                ),
                const Divider(color: Colors.white54),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title:
                  const Text("Logout", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }





Widget _buildEnhancedStatCard(
    BuildContext context, {
      required String title,
      required String value,
      required IconData icon,
      required Color color1,
      required Color color2,
    }) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOutCubic,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [color1, color2],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.brown.withOpacity(0.3),
          offset: const Offset(2, 4),
          blurRadius: 8,
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 34, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    ),
  );
}

