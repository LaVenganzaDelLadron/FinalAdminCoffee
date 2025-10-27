import 'dart:typed_data';

class Coffee {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final Uint8List? image;

  Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.image,
  });

  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      id: json['id']?.toString() ?? json['coffee_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: (json['price'] is String)
          ? double.tryParse(json['price']) ?? 0.0
          : (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price']?.toDouble() ?? 0.0),
      image: json['image'] != null
          ? Uint8List.fromList(List<int>.from(json['image']))
          : null,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "category": category,
      "price": price,
      "image": image,
    };
  }
}
