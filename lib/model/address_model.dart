class DeliveryAddress {
  String id;
  String title;
  String details;
  String phone;
  String latitude;
  String longitude;
  bool isCurrent;

  DeliveryAddress({
    required this.id,
    required this.title,
    required this.details,
    required this.phone,
    required this.isCurrent,
    required this.latitude,
    required this.longitude,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return DeliveryAddress(
      id: json["id"],
      title: json["title"],
      details: json["details"],
      phone: json["phone"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      isCurrent: json["is_current"],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "details": details,
        "phone": phone,
        "latitude": latitude,
        "longitude": longitude,
        "is_current": isCurrent,
      };
}
