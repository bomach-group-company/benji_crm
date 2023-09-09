// To parse this JSON data, do
//
//     final riderListModel = riderListModelFromJson(jsonString);

import 'dart:convert';

RiderListModel riderListModelFromJson(String str) =>
    RiderListModel.fromJson(json.decode(str));

String riderListModelToJson(RiderListModel data) => json.encode(data.toJson());

class RiderListModel {
  List<RiderItem>? items;
  int? total;
  int? perPage;
  int? start;
  int? end;

  RiderListModel({
    this.items,
    this.total,
    this.perPage,
    this.start,
    this.end,
  });

  factory RiderListModel.fromJson(Map<String, dynamic> json) => RiderListModel(
        items: json["items"] == null
            ? []
            : List<RiderItem>.from(
                json["items"]!.map((x) => RiderItem.fromJson(x))),
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

class RiderItem {
  int? id;
  String? email;
  String? password;
  String? phone;
  bool? isActiveCustomUserverified;
  String? username;
  String? code;
  dynamic image;
  bool? isOnline;
  DateTime? created;
  String? firstName;
  String? lastName;
  String? gender;
  String? address;
  dynamic plateNumber;
  dynamic chassisNumber;
  dynamic balance;

  RiderItem({
    this.id,
    this.email,
    this.password,
    this.phone,
    this.isActiveCustomUserverified,
    this.username,
    this.code,
    this.isOnline,
    this.created,
    this.firstName,
    this.lastName,
    this.gender,
    this.address,
    this.plateNumber,
    this.chassisNumber,
    this.balance,
    this.image,
  });

  factory RiderItem.fromJson(Map<String, dynamic> json) => RiderItem(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        isActiveCustomUserverified: json["is_activeCustomUserverified"],
        username: json["username"],
        code: json["code"],
        isOnline: json["is_online"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        address: json["address"],
        plateNumber: json["plate_number"],
        chassisNumber: json["chassis_number"],
        balance: json["balance"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "phone": phone,
        "is_activeCustomUserverified": isActiveCustomUserverified,
        "username": username,
        "code": code,
        "is_online": isOnline,
        "created":
            "${created!.year.toString().padLeft(4, '0')}-${created!.month.toString().padLeft(2, '0')}-${created!.day.toString().padLeft(2, '0')}",
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "address": address,
        "plate_number": plateNumber,
        "chassis_number": chassisNumber,
        "balance": balance,
         "image": image,
      };
}
