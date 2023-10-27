// To parse this JSON data, do
//
//     final businessType = businessTypeFromJson(jsonString);

import 'dart:convert';

List<BusinessType> businessTypeFromJson(String str) => List<BusinessType>.from(json.decode(str).map((x) => BusinessType.fromJson(x)));

String businessTypeToJson(List<BusinessType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusinessType {
    String? id;
    String? name;
    String? description;
    bool? isActive;

    BusinessType({
        this.id,
        this.name,
        this.description,
        this.isActive,
    });

    factory BusinessType.fromJson(Map<String, dynamic> json) => BusinessType(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "is_active": isActive,
    };
}
