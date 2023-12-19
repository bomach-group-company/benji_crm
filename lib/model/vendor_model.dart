// To parse this JSON data, do
//
//     final vendorModel = vendorModelFromJson(jsonString);

import 'dart:convert';

import 'package:benji_aggregator/model/business_type_model.dart';
import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:get/get.dart';

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
  bool isOnline;
  double averageRating;
  int numberOfClientsReactions;
  String shopName;
  String shopImage;
  String profileLogo;
  BusinessType shopType;
  String description;
  String weekOpeningHours;
  String weekClosingHours;
  String satOpeningHours;
  String satClosingHours;
  String sunWeekOpeningHours;
  String sunWeekClosingHours;
  String longitude;
  String latitude;

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
    required this.isOnline,
    required this.averageRating,
    required this.numberOfClientsReactions,
    required this.shopName,
    required this.shopImage,
    required this.profileLogo,
    required this.shopType,
    required this.description,
    required this.weekOpeningHours,
    required this.weekClosingHours,
    required this.satOpeningHours,
    required this.satClosingHours,
    required this.sunWeekOpeningHours,
    required this.sunWeekClosingHours,
    required this.longitude,
    required this.latitude,
  });

  factory VendorModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
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
      isOnline: json["is_online"] ?? false,
      averageRating: ((json["average_rating"] ?? 0.0) as double).toPrecision(1),
      numberOfClientsReactions: json["number_of_clients_reactions"] ?? 0,
      shopName: json["shop_name"] ?? notAvailable,
      shopImage: json["shop_image"] ?? '',
      profileLogo: json["profileLogo"] ?? '',
      shopType: BusinessType.fromJson(json["shop_type"]),
      description: json["description"] ?? '',
      weekOpeningHours: json["weekOpeningHours"] ?? '',
      weekClosingHours: json["weekClosingHours"] ?? '',
      satOpeningHours: json["satOpeningHours"] ?? '',
      satClosingHours: json["satClosingHours"] ?? '',
      sunWeekOpeningHours: json["sunWeekOpeningHours"] ?? '',
      sunWeekClosingHours: json["sunWeekClosingHours"] ?? '',
      longitude: json["longitude"] ?? '',
      latitude: json["latitude"] ?? '',
    );
  }
}
