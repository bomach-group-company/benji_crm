import '../../src/utils/constants.dart';

class ItemCategory {
  final String id;
  final String name;

  ItemCategory({
    required this.id,
    required this.name,
  });

  factory ItemCategory.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ItemCategory(
      id: json['id'] ?? notAvailable,
      name: json['name'] ?? notAvailable,
    );
  }
}
