// To parse this JSON data, do
//
//     final riderModel = riderModelFromJson(jsonString);

import 'dart:convert';

import 'package:benji_aggregator/src/providers/constants.dart';

RiderModel riderModelFromJson(String str) =>
    RiderModel.fromJson(json.decode(str));

String riderModelToJson(RiderModel data) => json.encode(data.toJson());

class RiderModel {
  int? id;
  String? username;
  String? email;

  RiderModel({
    this.id,
    this.username,
    this.email,
  });

  factory RiderModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return RiderModel(
      id: json["id"] ?? 0,
      username: json["username"] ?? notAvailable,
      email: json["email"] ?? notAvailable,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
      };
}
