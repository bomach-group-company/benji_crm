// To parse this JSON data, do
//
//     final vendorModel = vendorModelFromJson(jsonString);

import 'dart:convert';

import 'package:benji_aggregator/src/providers/constants.dart';

List<VendorModel> vendorModelFromJson(String str) => List<VendorModel>.from(
    json.decode(str).map((x) => VendorModel.fromJson(x)));

class VendorModel {
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

  VendorModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.username,
    required this.code,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.country,
    required this.state,
    required this.city,
    required this.lga,
    required this.profileLogo,
  });

  factory VendorModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    try {
      return VendorModel(
        id: json["id"] ?? 0,
        email: json["email"] ?? notAvailable,
        phone: json["phone"] ?? notAvailable,
        username: json["username"] ?? notAvailable,
        code: json["code"] ?? notAvailable,
        firstName: json["first_name"] ?? notAvailable,
        lastName: json["last_name"] ?? notAvailable,
        gender: json["gender"] ?? notAvailable,
        address: json["address"] ?? notAvailable,
        longitude: json["longitude"] ?? notAvailable,
        latitude: json["latitude"] ?? notAvailable,
        country: json["country"] ?? notAvailable,
        state: json["state"] ?? notAvailable,
        city: json["city"] ?? notAvailable,
        lga: json["lga"] ?? notAvailable,
        profileLogo: json["profileLogo"] ?? '',
      );
    } catch (e) {
      return VendorModel.fromJson(null);
      //  return VendorModel.defaults();
    }
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
        "country": country,
        "state": state,
        "city": city,
        "lga": lga,
        "profileLogo": profileLogo,
      };
}
