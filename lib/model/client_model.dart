import 'package:benji_aggregator/src/utils/constants.dart';

class Client {
  int id;
  String email;
  String username;
  String phone;
  String firstName;
  String lastName;
  String? image;
  String code;

  Client({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.image,
    required this.code,
  });

  factory Client.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Client(
      id: json["id"] ?? 0,
      email: json["email"] ?? notAvailable,
      username: json["username"] ?? notAvailable,
      phone: json["phone"] ?? notAvailable,
      firstName: json["first_name"] ?? notAvailable,
      lastName: json["last_name"] ?? notAvailable,
      image: json["image"],
      code: json["code"] ?? notAvailable,
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "phone": phone,
        "first_name": firstName,
        "last_name": lastName,
        "image": image,
        "code": code,
      };
}
