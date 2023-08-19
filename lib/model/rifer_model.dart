// To parse this JSON data, do
//
//     final riderModel = riderModelFromJson(jsonString);

import 'dart:convert';
RiderModel riderModelFromJson(String str) => RiderModel.fromJson(json.decode(str));

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

    factory RiderModel.fromJson(Map<String, dynamic> json) => RiderModel(
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
