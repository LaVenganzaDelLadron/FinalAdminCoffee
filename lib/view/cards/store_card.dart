import 'package:flutter/material.dart';
import '../../model/store.dart';
import '../screen/update_store_page.dart';
import '../services/api_store_services.dart';

class CompactStoreCard extends StatelessWidget {
  final Store store;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CompactStoreCard({
    super.key,
    required this.store,
    this.onDelete,
    this.onEdit,
  });

  Future<void> _deleteOrder(BuildContext context) async {
    // (same delete logic as before)
  }

  void _goToUpdatePage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateStorePage(store: store),
      ),
    );

    if (result == true && onEdit != null) {
      onEdit!(); // refresh parent list
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
        onTap: () => _goToUpdatePage(context),
        borderRadius: BorderRadius.circular(cardRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(cardRadius)),
              child: Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.storefront, color: Colors.grey, size: 40),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF5E503F)),
                  onPressed: () => _goToUpdatePage(context),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deleteOrder(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Store ID: ${store.id}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text('Name: ${store.name ?? 'N/A'}',
                      style: const TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text('Status: ${store.status ?? 'Pending'}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
