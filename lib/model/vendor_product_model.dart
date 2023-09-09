// To parse this JSON data, do
//
//     final vendorProductListModel = vendorProductListModelFromJson(jsonString);

import 'dart:convert';

VendorProductListModel vendorProductListModelFromJson(String str) =>
    VendorProductListModel.fromJson(json.decode(str));

String vendorProductListModelToJson(VendorProductListModel data) =>
    json.encode(data.toJson());

class VendorProductListModel {
  List<Item>? items;
  int? total;
  int? perPage;
  int? start;
  int? end;

  VendorProductListModel({
    this.items,
    this.total,
    this.perPage,
    this.start,
    this.end,
  });

  factory VendorProductListModel.fromJson(Map<String, dynamic> json) =>
      VendorProductListModel(
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        total: json["total"],
        perPage: json["per_page"],
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "total": total,
        "per_page": perPage,
        "start": start,
        "end": end,
      };
}

class Item {
  String? id;
  String? name;
  String? description;
  dynamic price;
 dynamic quantityAvailable;
  String? productImage;
  bool? isAvailable;
  bool? isTrending;
  bool? isRecommended;
  VendorId? vendorId;
  SubCategoryId? subCategoryId;

  Item({
    this.id,
    this.name,
    this.description,
    this.price,
    this.quantityAvailable,
    this.productImage,
    this.isAvailable,
    this.isTrending,
    this.isRecommended,
    this.vendorId,
    this.subCategoryId,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        quantityAvailable: json["quantity_available"],
        productImage: json["product_image"],
        isAvailable: json["is_available"],
        isTrending: json["is_trending"],
        isRecommended: json["is_recommended"],
        vendorId: json["vendor_id"] == null
            ? null
            : VendorId.fromJson(json["vendor_id"]),
        subCategoryId: json["sub_category_id"] == null
            ? null
            : SubCategoryId.fromJson(json["sub_category_id"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "quantity_available": quantityAvailable,
        "product_image": productImage,
        "is_available": isAvailable,
        "is_trending": isTrending,
        "is_recommended": isRecommended,
        "vendor_id": vendorId?.toJson(),
        "sub_category_id": subCategoryId?.toJson(),
      };
}

class SubCategoryId {
  String? id;
  String? name;
  String? description;
  bool? isActive;
  SubCategoryId? category;

  SubCategoryId({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.category,
  });

  factory SubCategoryId.fromJson(Map<String, dynamic> json) => SubCategoryId(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isActive: json["is_active"],
        category: json["category"] == null
            ? null
            : SubCategoryId.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "is_active": isActive,
        "category": category?.toJson(),
      };
}

class VendorId {
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
  SubCategoryId? shopType;

  VendorId({
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

  factory VendorId.fromJson(Map<String, dynamic> json) => VendorId(
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
            : SubCategoryId.fromJson(json["shop_type"]),
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
