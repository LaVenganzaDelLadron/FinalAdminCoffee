import 'package:flutter/material.dart';
import '../../model/top_selling.dart';

class TopSellingCard extends StatelessWidget {
  final TopSelling item;
  final int rank;

  const TopSellingCard({super.key, required this.item, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFF5F5F5),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Rank Badge 🥇
            CircleAvatar(
              radius: 20,
              backgroundColor: rank == 1
                  ? Colors.amber[700]
                  : rank == 2
                  ? Colors.grey[400]
                  : rank == 3
                  ? Colors.brown[300]
                  : Colors.grey[200],
              child: Text(
                '#$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Coffee Info ☕
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.coffeeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sold: ${item.totalQuantity.toStringAsFixed(0)} cups',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
            ),

            // 💰 Sales Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.local_cafe, color: Color(0xFF795548)),
                const SizedBox(height: 4),
                Text(
                  '₱${item.totalSales.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
