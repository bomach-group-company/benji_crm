import 'package:benji_aggregator/src/utils/constants.dart';

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
      id: json["id"] ?? notAvailable,
      title: json["title"] ?? notAvailable,
      details: json["details"] ?? notAvailable,
      phone: json["phone"] ?? notAvailable,
      latitude: json["latitude"] ?? notAvailable,
      longitude: json["longitude"] ?? notAvailable,
      isCurrent: json["is_current"] ?? false,
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
