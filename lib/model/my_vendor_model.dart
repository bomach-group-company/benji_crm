// To parse this JSON data, do
//
//     final myvendorModel = myvendorModelFromJson(jsonString);

import 'dart:convert';

import 'package:benji_aggregator/src/providers/constants.dart';

List<MyVendorModel> myVendorModelFromJson(String str) =>
    List<MyVendorModel>.from(
        json.decode(str).map((x) => MyVendorModel.fromJson(x)));

class MyVendorModel {
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
  String country;
  String state;
  String city;
  String lga;
  String profileLogo;

  MyVendorModel({
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
    required this.address,
    required this.profileLogo,
    required this.longitude,
    required this.latitude,
  });

  factory MyVendorModel.fromJson(Map<String, dynamic>? json) {
    json ??= {'vendor': {}};
    return MyVendorModel(
      id: json["vendor"]["id"] ?? 0,
      email: json["vendor"]["email"] ?? notAvailable,
      phone: json["vendor"]["phone"] ?? notAvailable,
      country: json["vendor"]["country"] ?? notAvailable,
      state: json["vendor"]["state"] ?? notAvailable,
      city: json["vendor"]["city"] ?? notAvailable,
      lga: json["vendor"]["lga"] ?? notAvailable,
      username: json["vendor"]["username"] ?? notAvailable,
      code: json["vendor"]["code"] ?? notAvailable,
      firstName: json["vendor"]["first_name"] ?? notAvailable,
      lastName: json["vendor"]["last_name"] ?? notAvailable,
      gender: json["vendor"]["gender"] ?? notAvailable,
      address: json["vendor"]["address"] ?? notAvailable,
      profileLogo: json["vendor"]["profileLogo"] == null ||
              json["vendor"]["profileLogo"] == ""
          ? 'https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg'
          : json['image'],
      longitude: json["longitude"] ?? notAvailable,
      latitude: json["latitude"] ?? notAvailable,
    );
  }
}
