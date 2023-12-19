// To parse this JSON data, do
//
//     final myvendorModel = myvendorModelFromJson(jsonString);

import 'dart:convert';

import 'package:benji_aggregator/model/business_type_model.dart';
import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:get/get.dart';

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
  bool isOnline;
  double averageRating;
  int numberOfClientsReactions;
  String shopName;
  String shopImage;
  String profileLogo;
  BusinessType shopType;
  String weekOpeningHours;
  String weekClosingHours;
  String satOpeningHours;
  String satClosingHours;
  String sunWeekOpeningHours;
  String sunWeekClosingHours;

  MyVendorModel({
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
    required this.weekOpeningHours,
    required this.weekClosingHours,
    required this.satOpeningHours,
    required this.satClosingHours,
    required this.sunWeekOpeningHours,
    required this.sunWeekClosingHours,
  });

  factory MyVendorModel.fromJson(Map<String, dynamic>? json) {
    json ??= {'vendor': {}};
    return MyVendorModel(
      id: json["vendor"]["id"] ?? 0,
      email: json["vendor"]["email"] ?? notAvailable,
      phone: json["vendor"]["phone"] ?? notAvailable,
      username: json["agent"]["username"] ?? notAvailable,
      code: json["agent"]["code"] ?? notAvailable,
      firstName: json["agent"]["first_name"] ?? notAvailable,
      lastName: json["agent"]["last_name"] ?? notAvailable,
      gender: json["agent"]["gender"] ?? notAvailable,
      address: json["agent"]["address"] ?? notAvailable,
      isOnline: json["vendor"]["is_online"] ?? false,
      averageRating:
          ((json["vendor"]["average_rating"] ?? 0.0) as double).toPrecision(1),
      numberOfClientsReactions:
          json["vendor"]["number_of_clients_reactions"] ?? 0,
      shopName: json["vendor"]["shop_name"] ?? notAvailable,
      shopImage: json["vendor"]["shop_image"] ?? '',
      profileLogo: json["vendor"]["profileLogo"] ?? '',
      shopType: BusinessType.fromJson(json["vendor"]["shop_type"]),
      weekOpeningHours: json["weekOpeningHours"] ?? '',
      weekClosingHours: json["weekClosingHours"] ?? '',
      satOpeningHours: json["satOpeningHours"] ?? '',
      satClosingHours: json["satClosingHours"] ?? '',
      sunWeekOpeningHours: json["sunWeekOpeningHours"] ?? '',
      sunWeekClosingHours: json["sunWeekClosingHours"] ?? '',
    );
  }
}
