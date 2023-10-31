// To parse this JSON data, do
//
//     final myvendorModel = myvendorModelFromJson(jsonString);

import 'dart:convert';

import 'package:benji_aggregator/model/business_type_model.dart';
import 'package:benji_aggregator/src/providers/constants.dart';

List<MyVendorModel> myVendorModelFromJson(String str) =>
    List<MyVendorModel>.from(
        json.decode(str).map((x) => MyVendorModel.fromJson(x)));

String myVendorModelToJson(List<MyVendorModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
  String? shopImage;
  String? profileLogo;
  BusinessType shopType;

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
    this.shopImage,
    this.profileLogo,
    required this.shopType,
  });

  factory MyVendorModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return MyVendorModel(
      id: json['vendor']["id"] ?? 0,
      email: json['vendor']["email"] ?? notAvailable,
      phone: json['vendor']["phone"] ?? notAvailable,
      username: json['vendor']["username"] ?? notAvailable,
      code: json['vendor']["code"] ?? notAvailable,
      firstName: json['vendor']["first_name"] ?? notAvailable,
      lastName: json['vendor']["last_name"] ?? notAvailable,
      gender: json['vendor']["gender"] ?? notAvailable,
      address: json['vendor']["address"] ?? notAvailable,
      isOnline: json['vendor']["is_online"] ?? false,
      averageRating: json['vendor']["average_rating"] ?? 0.0,
      numberOfClientsReactions:
          json['vendor']["number_of_clients_reactions"] ?? 0,
      shopName: json['vendor']["shop_name"] ?? notAvailable,
      shopImage: json['vendor']["shop_image"],
      profileLogo: json['vendor']["profileLogo"],
      shopType: BusinessType.fromJson(json['vendor']["shop_type"]),
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
        "is_online": isOnline,
        "average_rating": averageRating,
        "number_of_clients_reactions": numberOfClientsReactions,
        "shop_name": shopName,
        "shop_image": shopImage,
        "profileLogo": profileLogo,
        "shop_type": shopType.toJson(),
      };
}
