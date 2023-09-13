// To parse this JSON data, do
//
//     final subCategoryModel = subCategoryModelFromJson(jsonString);

import 'dart:convert';

List<SubCategoryModel> subCategoryModelFromJson(String str) =>
    List<SubCategoryModel>.from(
        json.decode(str).map((x) => SubCategoryModel.fromJson(x)));

String subCategoryModelToJson(List<SubCategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubCategoryModel {
  String? id;
  String? name;
  String? description;
  bool? isActive;
  SubCategoryModel? category;

  SubCategoryModel({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.category,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isActive: json["is_active"],
        category: json["category"] == null
            ? null
            : SubCategoryModel.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "is_active": isActive,
        "category": category?.toJson(),
      };
}
