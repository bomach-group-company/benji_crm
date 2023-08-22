// To parse this JSON data, do
//
//     final vendorListModel = vendorListModelFromJson(jsonString);

import 'dart:convert';

List<VendorListModel> vendorListModelFromJson(String str) => List<VendorListModel>.from(json.decode(str).map((x) => VendorListModel.fromJson(x)));

String vendorListModelToJson(List<VendorListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VendorListModel {
    int? id;
    String? email;
    String? password;
    String? phone;
    bool? isActiveCustomUserverified;
    String? username;
    DateTime? created;
    String? firstName;
    String? lastName;
    String? gender;
    String? address;
    String? shopName;
    dynamic balance;

    VendorListModel({
        this.id,
        this.email,
        this.password,
        this.phone,
        this.isActiveCustomUserverified,
        this.username,
        this.created,
        this.firstName,
        this.lastName,
        this.gender,
        this.address,
        this.shopName,
        this.balance,
    });

    factory VendorListModel.fromJson(Map<String, dynamic> json) => VendorListModel(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        isActiveCustomUserverified: json["is_activeCustomUserverified"],
        username: json["username"],
        created: json["created"] == null ? null : DateTime.parse(json["created"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        address: json["address"],
        shopName: json["shop_name"],
        balance: json["balance"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "phone": phone,
        "is_activeCustomUserverified": isActiveCustomUserverified,
        "username": username,
        "created": "${created!.year.toString().padLeft(4, '0')}-${created!.month.toString().padLeft(2, '0')}-${created!.day.toString().padLeft(2, '0')}",
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "address": address,
        "shop_name": shopName,
        "balance": balance,
    };
}
