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
      username: json["agent"]["username"] ?? notAvailable,
      code: json["agent"]["code"] ?? notAvailable,
      firstName: json["agent"]["first_name"] ?? notAvailable,
      lastName: json["agent"]["last_name"] ?? notAvailable,
      gender: json["agent"]["gender"] ?? notAvailable,
      address: json["agent"]["address"] ?? notAvailable,
      profileLogo: json["vendor"]["profileLogo"] ?? '',
      longitude: json["longitude"] ?? '',
      latitude: json["latitude"] ?? '',
    );
  }
}
