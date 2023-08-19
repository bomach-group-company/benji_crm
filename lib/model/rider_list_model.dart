// To parse this JSON data, do
//
//     final riderListModel = riderListModelFromJson(jsonString);

import 'dart:convert';

List<RiderListModel> riderListModelFromJson(String str) => List<RiderListModel>.from(json.decode(str).map((x) => RiderListModel.fromJson(x)));

String riderListModelToJson(List<RiderListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RiderListModel {
    int? id;
    String? username;
    String? email;

    RiderListModel({
        this.id,
        this.username,
        this.email,
    });

    factory RiderListModel.fromJson(Map<String, dynamic> json) => RiderListModel(
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
