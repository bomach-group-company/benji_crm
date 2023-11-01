import 'dart:convert';

import 'package:benji_aggregator/model/category.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:http/http.dart' as http;

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

Future<List<SubCategory>> getSubCategories(
    [int start = 0, int end = 100]) async {
  final response = await http.get(
      Uri.parse('$baseURL/sub_categories/list?start=$start&end=$end'),
      headers: authHeader());

  if (response.statusCode == 200) {
    return (jsonDecode(response.body)['items'] as List)
        .map((item) => SubCategory.fromJson(item))
        .toList();
  } else {
    return [];
  }
}
