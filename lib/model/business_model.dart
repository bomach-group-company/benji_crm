import 'dart:developer';

import '../src/utils/constants.dart';
import 'business_type_model.dart';
import 'country_model.dart';
import 'my_vendor_model.dart';
import 'user_model.dart';

class BusinessModel {
  String id;
  MyVendorModel vendorOwner;
  CountryModel country;
  String state;
  String city;
  String lga;
  String weekOpeningHours;
  String weekClosingHours;
  String satOpeningHours;
  String satClosingHours;
  String sunWeekOpeningHours;
  String sunWeekClosingHours;
  String address;
  String shopName;
  BusinessType shopType;
  dynamic shopImage;
  dynamic coverImage;
  String longitude;
  String latitude;
  String businessId;
  String businessBio;
  String accountName;
  String accountNumber;
  String accountType;
  String accountBank;
  double averageRating;
  int numberOfClientsReactions;
  UserModel agent;
  dynamic popularity;

  BusinessModel({
    required this.id,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    required this.lga,
    required this.shopImage,
    required this.coverImage,
    required this.shopType,
    required this.shopName,
    required this.vendorOwner,
    required this.latitude,
    required this.longitude,
    required this.weekOpeningHours,
    required this.weekClosingHours,
    required this.satOpeningHours,
    required this.satClosingHours,
    required this.sunWeekOpeningHours,
    required this.sunWeekClosingHours,
    required this.businessId,
    required this.businessBio,
    required this.accountName,
    required this.accountNumber,
    required this.accountType,
    required this.accountBank,
    required this.averageRating,
    required this.numberOfClientsReactions,
    required this.agent,
    required this.popularity,
  });

  factory BusinessModel.fromJson(Map<String, dynamic>? json) {
    log("Business JSON: $json");
    json ??= {};
    return BusinessModel(
      id: json["id"] ?? '',
      country: CountryModel.fromJson(json['country'] ?? {}),
      state: json["state"] ?? notAvailable,
      city: json["city"] ?? notAvailable,
      lga: json["lga"] ?? notAvailable,
      address: json["address"] ?? notAvailable,
      shopName: json["shop_name"] ?? notAvailable,
      shopImage: json['shop_image'] == null || json['shop_image'] == ""
          ? 'https://ibb.co/j4d0VtC'
          : json['shop_image'],
      coverImage: json['coverImage'] == null || json['coverImage'] == ""
          ? 'https://ibb.co/9NqtrPt'
          : json['coverImage'],
      shopType: BusinessType.fromJson(json["shop_type"] ?? {}),
      vendorOwner: MyVendorModel.fromJson(json['vendor_owner'] ?? {}),
      weekOpeningHours: json["weekOpeningHours"] ?? notAvailable,
      weekClosingHours: json["weekClosingHours"] ?? notAvailable,
      satOpeningHours: json["satOpeningHours"] ?? notAvailable,
      satClosingHours: json["satClosingHours"] ?? notAvailable,
      sunWeekOpeningHours: json["sunWeekOpeningHours"] ?? notAvailable,
      sunWeekClosingHours: json["sunWeekClosingHours"] ?? notAvailable,
      latitude: json["latitude"] ?? notAvailable,
      longitude: json["longitude"] ?? notAvailable,
      businessId: json["businessId"] ?? notAvailable,
      businessBio: json["businessBio"] ?? notAvailable,
      accountName: json["accountName"] ?? notAvailable,
      accountNumber: json["accountNumber"] ?? notAvailable,
      accountType: json["accountType"] ?? notAvailable,
      accountBank: json["accountBank"] ?? notAvailable,
      averageRating: json["average_rating"] ?? 0.0,
      numberOfClientsReactions: json["number_of_clients_reactions"] ?? 0,
      agent: UserModel.fromJson(json['agent'] ?? {}),
      popularity: json['popularity'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "state": state,
        "city": city,
        "address": address,
        "lga": lga,
        "shop_name": shopName,
        "shop_image": shopImage,
        "coverImage": coverImage,
        "shop_type": shopType.toJson(),
        "vendor_owner": vendorOwner.toJson(),
        "weekOpeningHours": weekOpeningHours,
        "weekClosingHours": weekClosingHours,
        "satOpeningHours": satOpeningHours,
        "satClosingHours": satClosingHours,
        "sunWeekOpeningHours": sunWeekOpeningHours,
        "sunWeekClosingHours": sunWeekClosingHours,
        "latitude": latitude,
        "longitude": longitude,
        "businessId": businessId,
        "businessBio": businessBio,
        "accountName": accountName,
        "accountNumber": accountNumber,
        "accountType": accountType,
        "accountBank": accountBank,
        "average_rating": averageRating,
        "number_of_clients_reactions": numberOfClientsReactions,
        "agent": agent.toJson(),
        "popularity": popularity,
      };
}
