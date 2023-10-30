import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  String? id;
  DateTime? created;
  String? message;
  Agent? agent;
  dynamic vendor;

  NotificationModel({
    this.id,
    this.created,
    this.message,
    this.agent,
    this.vendor,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        message: json["message"],
        agent: json["agent"] == null ? null : Agent.fromJson(json["agent"]),
        vendor: json["vendor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created?.toIso8601String(),
        "message": message,
        "agent": agent?.toJson(),
        "vendor": vendor,
      };
}

class Agent {
  String? username;
  String? email;

  Agent({
    this.username,
    this.email,
  });

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        username: json["username"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
      };
}
