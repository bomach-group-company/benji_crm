// To parse this JSON data, do
//
//     final businessType = businessTypeFromJson(jsonString);

import 'dart:convert';

import 'package:benji_aggregator/src/providers/constants.dart';

List<BusinessType> businessTypeFromJson(String str) => List<BusinessType>.from(
    json.decode(str).map((x) => BusinessType.fromJson(x)));

String businessTypeToJson(List<BusinessType> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusinessType {
  String id;
  String name;
  String description;
  bool isActive;

  BusinessType({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });

  factory BusinessType.fromJson(Map<String, dynamic>? json) {
    print('what got $json');
    json ??= {};
    return BusinessType(
      id: json["id"] ?? notAvailable,
      name: json["name"] ?? notAvailable,
      description: json["description"] ?? notAvailable,
      isActive: json["is_active"] ?? false,
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "is_active": isActive,
      };
}
