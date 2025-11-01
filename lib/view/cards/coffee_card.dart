import 'package:flutter/material.dart';
import 'package:admincoffee/model/coffee.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/coffee_controller.dart';
import '../screen/update_coffee_page.dart';
import '../services/api_coffee_services.dart';

class CompactCoffeeCard extends StatelessWidget {
  final Coffee coffee;
  final VoidCallback? onDelete;

  const CompactCoffeeCard({
    super.key,
    required this.coffee,
    this.onDelete,
  });

  Future<void> _deleteCoffee(BuildContext context) async {
    final adminId = AuthController.instance.currentAdmin.value?.id;
    final CoffeeController controller = Get.put(CoffeeController());

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Archive Coffee",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
        ),
        content: Text(
          "Are you sure you want to archive '${coffee.name}'? This item will be removed from the active list.",
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final result = await ApiCoffeeServices.deleteCoffee(coffee.id);

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Coffee deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        if (adminId != null) {
          await controller.fetchAllCoffees(adminId);
        }

        if (onDelete != null) onDelete!();
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedPrice = "\$${coffee.price.toStringAsFixed(2)}";
    const double cardRadius = 15.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: InkWell(
        // ✅ Tap the whole card to open update page
        onTap: () => Get.to(() => UpdateCoffeePage(coffee: coffee)),
        borderRadius: BorderRadius.circular(cardRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // ✅ Coffee image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(cardRadius)),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: (coffee.image != null && coffee.image!.isNotEmpty)
                        ? Image.memory(
                      coffee.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                    )
                        : const Center(
                      child: Icon(Icons.coffee, color: Colors.grey, size: 40),
                    ),
                  ),
                ),

                // ✅ Only delete button remains
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _deleteCoffee(context),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),

            // ✅ Coffee Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffee.name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    formattedPrice,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
