// To parse this JSON data, do
//
//     final vendorModel = vendorModelFromJson(jsonString);
import 'dart:convert';

VendorModel vendorModelFromJson(String str) => VendorModel.fromJson(json.decode(str));
String vendorModelToJson(VendorModel data) => json.encode(data.toJson());

class VendorModel {
    int? id;
    String? email;
    String? password;
    String? phone;
    bool? isActiveCustomUserverified;
    String? username;
    bool? isOnline;
    DateTime? created;
    String? firstName;
    String? lastName;
    String? gender;
    String? address;
    String? shopName;
    dynamic balance;

    VendorModel({
        this.id,
        this.email,
        this.password,
        this.phone,
        this.isActiveCustomUserverified,
        this.username,
        this.isOnline,
        this.created,
        this.firstName,
        this.lastName,
        this.gender,
        this.address,
        this.shopName,
        this.balance,
    });

    factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        isActiveCustomUserverified: json["is_activeCustomUserverified"],
        username: json["username"],
        isOnline: json["is_online"],
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
        "is_online": isOnline,
        "created": "${created!.year.toString().padLeft(4, '0')}-${created!.month.toString().padLeft(2, '0')}-${created!.day.toString().padLeft(2, '0')}",
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "address": address,
        "shop_name": shopName,
        "balance": balance,
    };
}
