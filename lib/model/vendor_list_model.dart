// To parse this JSON data, do
//
//     final vendorListModel = vendorListModelFromJson(jsonString);

import 'dart:convert';

List<VendorListModel> vendorListModelFromJson(String str) =>
    List<VendorListModel>.from(
        json.decode(str).map((x) => VendorListModel.fromJson(x)));

String vendorListModelToJson(List<VendorListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VendorListModel {
  int? id;
  String? email;
  String? phone;
  String? username;
  String? code;
  String? firstName;
  String? lastName;
  String? gender;
  bool? isOnline;
  dynamic averageRating;
  dynamic numberOfClientsReactions;
  String? shopName;
  String? shopImage;
  ShopType? shopType;

  VendorListModel({
    this.id,
    this.email,
    this.phone,
    this.username,
    this.code,
    this.firstName,
    this.lastName,
    this.gender,
    this.isOnline,
    this.averageRating,
    this.numberOfClientsReactions,
    this.shopName,
    this.shopImage,
    this.shopType,
  });

  factory VendorListModel.fromJson(Map<String, dynamic> json) =>
      VendorListModel(
        id: json["id"],
        email: json["email"],
        phone: json["phone"],
        username: json["username"],
        code: json["code"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        isOnline: json["is_online"],
        averageRating: json["average_rating"],
        numberOfClientsReactions: json["number_of_clients_reactions"],
        shopName: json["shop_name"],
        shopImage: json["shop_image"],
        shopType: json["shop_type"] == null
            ? null
            : ShopType.fromJson(json["shop_type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "phone": phone,
        "username": username,
        "code": code,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "is_online": isOnline,
        "average_rating": averageRating,
        "number_of_clients_reactions": numberOfClientsReactions,
        "shop_name": shopName,
        "shop_image": shopImage,
        "shop_type": shopType?.toJson(),
      };
}

class ShopType {
  String? id;
  String? name;
  String? description;
  bool? isActive;

  ShopType({
    this.id,
    this.name,
    this.description,
    this.isActive,
  });

  factory ShopType.fromJson(Map<String, dynamic> json) => ShopType(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "is_active": isActive,
      };
}
