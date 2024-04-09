import 'package:benji_aggregator/src/utils/constants.dart';

class RiderItem {
  int id;
  String email;
  String phone;
  String username;
  String code;
  String image;
  DateTime? created;
  String firstName;
  String lastName;
  String gender;
  String address;
  String plateNumber;
  String chassisNumber;
  double balance;
  int tripCount;

  RiderItem({
    required this.id,
    required this.email,
    required this.phone,
    required this.username,
    required this.code,
    this.created,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.address,
    required this.plateNumber,
    required this.chassisNumber,
    required this.balance,
    required this.image,
    required this.tripCount,
  });

  factory RiderItem.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return RiderItem(
      id: json["id"] ?? 0,
      email: json["email"] ?? notAvailable,
      phone: json["phone"] ?? notAvailable,
      username: json["username"] ?? notAvailable,
      code: json["code"] ?? notAvailable,
      created: json["created"] == null ? null : DateTime.parse(json["created"]),
      firstName: json["first_name"] ?? notAvailable,
      lastName: json["last_name"] ?? notAvailable,
      gender: json["gender"] ?? notAvailable,
      address: json["address"] ?? notAvailable,
      plateNumber: json["plate_number"] ?? notAvailable,
      chassisNumber: json["chassis_number"] ?? notAvailable,
      balance: json["balance"] == null
          ? 0.0
          : double.parse(json["balance"].toString()),
      image: json["image"] ?? '',
      tripCount: json['tripCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "phone": phone,
        "username": username,
        "code": code,
        "created": created,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "address": address,
        "plate_number": plateNumber,
        "chassis_number": chassisNumber,
        "balance": balance,
        "image": image,
      };
}
