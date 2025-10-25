import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String id;
  final String categoryName;
  final VoidCallback? onDelete;

  const CategoryCard({
    super.key,
    required this.id,
    required this.categoryName,
    this.onDelete,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Delete Category",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        content: Text(
          "Are you sure you want to delete the category '$id' '$categoryName'?",
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm == true && onDelete != null) {
      onDelete!();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Category '$categoryName' deleted successfully!"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Material(
        color: Colors.brown.shade50,
        borderRadius: BorderRadius.circular(18),
        elevation: 4,
        shadowColor: Colors.brown.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.label_rounded, color: Colors.brown, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  categoryName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.brown,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline_sharp, color: Colors.redAccent),
                onPressed: () => _confirmDelete(context),
                tooltip: "Delete Category",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
