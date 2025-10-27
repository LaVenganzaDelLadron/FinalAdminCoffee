
class Order{
  final int id;
  final String user_id;
  final String store_id;
  final double total_amount;
  final String order_type;
  final String status;
  final String created_at;

  Order({
    required this.id,
    required this.user_id,
    required this.store_id,
    required this.total_amount,
    required this.order_type,
    required this.status,
    required this.created_at,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] != null ? json['id'] as int : 0,
      user_id: json['user_id'] ?? '',
      store_id: json['store_id'] ?? '',
      total_amount: () {
        final v = json['total_amount'];
        if (v == null) return 0.0;
        if (v is double) return v;
        if (v is int) return v.toDouble();
        if (v is String) return double.tryParse(v) ?? 0.0;
        return 0.0;
      }(),
      order_type: json['order_type'] ?? '',
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": user_id,
      "store_id": store_id,
      "total_amount": total_amount,
      "order_type": order_type,
      "status": status,
      "created_at": created_at,
    };
  }


}