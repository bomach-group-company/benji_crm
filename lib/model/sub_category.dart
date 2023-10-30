import 'package:benji_aggregator/model/category.dart';
import 'package:benji_aggregator/src/providers/constants.dart';

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
      id: json["id"] ?? notAvailable,
      name: json["name"] ?? notAvailable,
      description: json["description"] ?? notAvailable,
      isActive: json["is_active"] ?? false,
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
