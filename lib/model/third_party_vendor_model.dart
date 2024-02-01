import 'package:benji_aggregator/src/providers/constants.dart';

import 'country_model.dart';

// final myvendorModel = myvendorModelFromJson(jsonString);

// List<ThirdPartyVendorModel> myVendorModelFromJson(String str) =>
//     List<ThirdPartyVendorModel>.from(
//         json.decode(str).map((x) => ThirdPartyVendorModel.fromJson(x)));

class ThirdPartyVendorModel {
  int id;
  String email;
  String phone;
  String username;
  String code;
  String firstName;
  String lastName;
  String gender;
  String address;
  String longitude;
  String latitude;
  CountryModel country;
  String state;
  String city;
  String lga;
  String profileLogo;

  bool isOnline;

  ThirdPartyVendorModel({
    required this.id,
    required this.email,
    required this.country,
    required this.state,
    required this.city,
    required this.lga,
    required this.phone,
    required this.username,
    required this.code,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.isOnline,
    required this.address,
    required this.profileLogo,
    required this.longitude,
    required this.latitude,
  });

  factory ThirdPartyVendorModel.fromJson(Map<String, dynamic>? json) {
    json ??= {'vendor': {}};

    return ThirdPartyVendorModel(
      id: json["id"] ?? 0,
      username: json["username"] ?? notAvailable,
      code: json["code"] ?? notAvailable,
      firstName: json["first_name"] ?? notAvailable,
      lastName: json["last_name"] ?? notAvailable,
      gender: json["gender"] ?? notAvailable,
      email: json["email"] ?? notAvailable,
      phone: json["phone"] ?? notAvailable,
      country: CountryModel.fromJson(json["country"]),
      state: json["state"] ?? notAvailable,
      city: json["city"] ?? notAvailable,
      lga: json["lga"] ?? notAvailable,
      address: json["address"] ?? notAvailable,
      isOnline: json["is_online"] ?? false,
      profileLogo: json["profileLogo"] == null || json["profileLogo"] == ""
          ? 'https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg'
          : json['profileLogo'],
      longitude: json["longitude"] ?? '',
      latitude: json["latitude"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "phone": phone,
        "username": username,
        "code": code,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "address": address,
        "country": country.toJson(),
        "state": state,
        "city": city,
        "lga": lga,
        "profileLogo": profileLogo,
        "is_online": isOnline,
      };
}
