import 'package:flutter/material.dart';
import 'package:admincoffee/model/coffee.dart';
import '../services/api_coffee_services.dart';

class CoffeeCard extends StatelessWidget {
  final Coffee coffee;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CoffeeCard({
    super.key,
    required this.coffee,
    this.onDelete,
    this.onEdit,
  });

  Future<void> _deleteCoffee(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Archive Coffee",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        content: Text(
          "Are you sure you want to archive '${coffee.name}'?",
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Archive", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final result = await ApiCoffeeServices.deleteCoffee(coffee.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Coffee archived successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        if (onDelete != null) onDelete!();
      } catch (e) {
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
    Widget imageWidget;

    if (coffee.image != null && coffee.image!.isNotEmpty) {
      imageWidget = Image.memory(
        coffee.image!,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = Image.network(
        "https://images.unsplash.com/photo-1509042239860-f550ce710b93",
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Coffee Image with Status ---
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: imageWidget,
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Active",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // --- Info Section ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        coffee.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      "₱${coffee.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Description
                Text(
                  coffee.description.isNotEmpty
                      ? coffee.description
                      : "Slow-steeped overnight with cocoa nibs and orange bitters.",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),

                // Category
                Text(
                  "Category: ${coffee.category.isNotEmpty ? coffee.category : 'Cold Brew'}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.brown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),

                // Buttons
                Row(
                  children: [
                    // ✏️ Edit Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text("Edit"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // 🟥 Archive Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _deleteCoffee(context),
                        icon: const Icon(Icons.archive, size: 18),
                        label: const Text("Archive"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade600,
                          side:
                          BorderSide(color: Colors.red.shade400, width: 1),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
