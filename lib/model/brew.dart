class Brew {
  final String name;
  final String image;
  final int cupsSold;
  final double percentage;

  Brew({
    required this.name,
    required this.image,
    required this.cupsSold,
    required this.percentage,
  });

  factory Brew.fromJson(Map<String, dynamic> json) {
    return Brew(
      name: json['name'] ?? '',
      image: json['image'] ?? '', // Expecting a URL or Base64 string
      cupsSold: json['cups_sold'] ?? 0,
      percentage: (json['percentage'] is String)
          ? double.tryParse(json['percentage']) ?? 0.0
          : (json['percentage']?.toDouble() ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "image": image,
      "cups_sold": cupsSold,
      "percentage": percentage,
    };
  }
}
