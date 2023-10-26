// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import '../src/providers/constants.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int id;
  String username;
  String email;
  String code;
  String token;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.code,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return UserModel(
      id: json["id"] ?? 0,
      username: json["username"] ?? notAvailable,
      email: json["email"] ?? notAvailable,
      code: json["code"] ?? notAvailable,
      token: json["token"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "code": code,
        "token": token,
      };
}
