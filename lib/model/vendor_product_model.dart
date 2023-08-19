// To parse this JSON data, do
//
//     final vendorProductModel = vendorProductModelFromJson(jsonString);

import 'dart:convert';

List<VendorProductModel> vendorProductModelFromJson(String str) => List<VendorProductModel>.from(json.decode(str).map((x) => VendorProductModel.fromJson(x)));

String vendorProductModelToJson(List<VendorProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VendorProductModel {
    String? id;
    String? name;
    String? description;
    dynamic price;
    int? quantityAvailable;
    String? productImage;
    bool? isAvailable;
    bool? isTrending;
    bool? isRecommended;
    VendorId? vendorId;
    SubCategoryId? subCategoryId;

    VendorProductModel({
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

    factory VendorProductModel.fromJson(Map<String, dynamic> json) => VendorProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        quantityAvailable: json["quantity_available"],
        productImage: json["product_image"],
        isAvailable: json["is_available"],
        isTrending: json["is_trending"],
        isRecommended: json["is_recommended"],
        vendorId: json["vendor_id"] == null ? null : VendorId.fromJson(json["vendor_id"]),
        subCategoryId: json["sub_category_id"] == null ? null : SubCategoryId.fromJson(json["sub_category_id"]),
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
        category: json["category"] == null ? null : SubCategoryId.fromJson(json["category"]),
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
    String? username;
    String? email;

    VendorId({
        this.id,
        this.username,
        this.email,
    });

    factory VendorId.fromJson(Map<String, dynamic> json) => VendorId(
        id: json["id"],
        username: json["username"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
    };
}
