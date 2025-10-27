import 'package:flutter/material.dart';
import '../../model/order.dart';
import '../services/api_order_services.dart';

class CompactOrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CompactOrderCard({
    super.key,
    required this.order,
    this.onDelete,
    this.onEdit,
  });

  Future<void> _deleteOrder(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Archive Order",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E2723),
          ),
        ),
        content: Text(
          "Are you sure you want to archive order '${order.id}'? "
              "This item will be removed from the active list.",
          style: const TextStyle(fontSize: 15, color: Colors.black87),
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
        // ✅ assuming this function exists to delete/archive an order
        final result = await ApiOrderServices.deleteOrder(order.id as String);

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Order archived successfully!'),
            backgroundColor: Colors.green,
          ),
        );
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
    const double cardRadius = 15.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(cardRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Top section (placeholder image)
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(cardRadius)),
              child: Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.receipt_long,
                      color: Colors.grey, size: 40), // Placeholder
                ),
              ),
            ),

            // 🔹 Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF5E503F)),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deleteOrder(context),
                ),
              ],
            ),

            // 🔹 Order details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: ${order.id}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Customer: ${order.id ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Status: ${order.status ?? 'Pending'}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
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
