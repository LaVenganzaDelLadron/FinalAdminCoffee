class TopSelling {
  final int coffeeId;
  final String coffeeName;
  final double totalQuantity;
  final double totalSales;

  TopSelling({
    required this.coffeeId,
    required this.coffeeName,
    required this.totalQuantity,
    required this.totalSales,
  });

  factory TopSelling.fromJson(Map<String, dynamic> json) {
    return TopSelling(
      coffeeId: json['coffee_id'],
      coffeeName: json['coffee_name'],
      totalQuantity: (json['total_quantity'] as num).toDouble(),
      totalSales: (json['total_sales'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coffee_id': coffeeId,
      'coffee_name': coffeeName,
      'total_quantity': totalQuantity,
      'total_sales': totalSales,
    };
  }
}
