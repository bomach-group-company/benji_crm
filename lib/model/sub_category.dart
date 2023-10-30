import 'package:benji_aggregator/model/category.dart';

class SubCategory {
  String id;
  String name;
  String description;
  bool isActive;
  Category category;

  SubCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.category,
  });

  factory SubCategory.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return SubCategory(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      isActive: json["is_active"],
      category: Category.fromJson(json["category"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "is_active": isActive,
        "category": category.toJson(),
      };
}
