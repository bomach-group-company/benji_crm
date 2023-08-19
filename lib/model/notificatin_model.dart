// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) => List<NotificationModel>.from(json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
    String? id;
    DateTime? created;
    String? message;
    Agent? agent;
    Vendor? vendor;

    NotificationModel({
        this.id,
        this.created,
        this.message,
        this.agent,
        this.vendor,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json["id"],
        created: json["created"] == null ? null : DateTime.parse(json["created"]),
        message: json["message"],
        agent: json["agent"] == null ? null : Agent.fromJson(json["agent"]),
        vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created": created?.toIso8601String(),
        "message": message,
        "agent": agent?.toJson(),
        "vendor": vendor?.toJson(),
    };
}

class Agent {
    int? id;
    String? username;
    String? email;

    Agent({
        this.id,
        this.username,
        this.email,
    });

    factory Agent.fromJson(Map<String, dynamic> json) => Agent(
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

class Vendor {
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

    Vendor({
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

    factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
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
