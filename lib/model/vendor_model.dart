// To parse this JSON data, do
//
//     final vendorModel = vendorModelFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/src/providers/constants.dart';

import '../controller/api_processor_controller.dart';

VendorModel userModelFromJson(String str) =>
    VendorModel.fromJson(json.decode(str));

String userModelToJson(VendorModel data) => json.encode(data.toJson());

class VendorModel {
  int id;
  String token;
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
  bool isOnline;
  String profileLogo;
  // double averageRating;
  // int numberOfClientsReactions;
  // String shopName;
  // String shopImage;
  // BusinessType shopType;
  // String weekOpeningHours;
  // String weekClosingHours;
  // String satOpeningHours;
  // String satClosingHours;
  // String sunWeekOpeningHours;
  // String sunWeekClosingHours;
  // String businessBio;

  VendorModel({
    required this.id,
    required this.token,
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
    required this.isOnline,
    // required this.averageRating,
    // required this.numberOfClientsReactions,
    // required this.shopName,
    // required this.shopImage,
    // required this.shopType,
    // required this.weekOpeningHours,
    // required this.weekClosingHours,
    // required this.satOpeningHours,
    // required this.satClosingHours,
    // required this.sunWeekOpeningHours,
    // required this.sunWeekClosingHours,
    // required this.businessBio,
  });

  factory VendorModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    log("JSON data: $json");
    try {
      return VendorModel(
        id: json["id"] ?? 0,
        token: json["token"] ?? '',
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
        profileLogo: json['profileLogo'] == null || json['profileLogo'] == ""
            ? 'https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg'
            : json['profileLogo'],
        isOnline: json["is_online"] ?? false,
        // averageRating:
        //     ((json["average_rating"] ?? 0.0) as double).toPrecision(1),
        // averageRating: json["average_rating"] != null
        //     ? (json["average_rating"] is double
        //         ? json["average_rating"]
        //         : double.tryParse(json["average_rating"].toString()) ?? 0.0)
        //     : 0.0,
        // numberOfClientsReactions: json["number_of_clients_reactions"] ?? 0,
        // shopName: json["shop_name"] ?? notAvailable,
        // shopImage: json["shop_image"] ?? '',
        // shopType: BusinessType.fromJson(json["shop_type"]),
        // weekOpeningHours: json["weekOpeningHours"] ?? notAvailable,
        // weekClosingHours: json["weekClosingHours"] ?? notAvailable,
        // satOpeningHours: json["satOpeningHours"] ?? notAvailable,
        // satClosingHours: json["satClosingHours"] ?? notAvailable,
        // sunWeekOpeningHours: json["sunWeekOpeningHours"] ?? notAvailable,
        // sunWeekClosingHours: json["sunWeekClosingHours"] ?? notAvailable,
        // businessBio: json["description"] ?? notAvailable,
      );
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
      return VendorModel.fromJson(null);
    } catch (e) {
      log("Error parsing average_rating: $e");
      return VendorModel.fromJson(null);
      //  return VendorModel.defaults();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
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
        "is_online": isOnline,
        // "average_rating": averageRating,
        // "number_of_clients_reactions": numberOfClientsReactions,
        // "shop_name": shopName,
        // "shop_image": shopImage,
        // "shop_type": shopType.toJson(),
        // "weekOpeningHours": weekOpeningHours,
        // "weekClosingHours": weekClosingHours,
        // "satOpeningHours": satOpeningHours,
        // "satClosingHours": satClosingHours,
        // "sunWeekOpeningHours": sunWeekOpeningHours,
        // "sunWeekClosingHours": sunWeekClosingHours,
        // "description": businessBio,
      };
}
