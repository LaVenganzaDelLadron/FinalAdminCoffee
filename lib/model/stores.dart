
class Store{
  final int id;
  final String name;
  final String address;
  final String prep_time_minutes;
  final String status;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.prep_time_minutes,
    required this.status,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
        id: json["id"] != null ? json["id"] as int : 0,
        name: json["name"] ?? "",
        address: json["address"] ?? "",
        prep_time_minutes: json["prep_time_minutes"] ?? "",
        status: json["status"] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "address": address,
      "prep_time_minutes": prep_time_minutes,
      "status": status,
    };
  }

}















