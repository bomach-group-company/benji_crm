import 'package:benji_aggregator/src/utils/constants.dart';

class Category {
  String id;
  String name;
  String description;
  bool isActive;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });

  factory Category.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Category(
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
