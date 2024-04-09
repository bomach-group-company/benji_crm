import 'dart:convert';

import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class ProductTypeModel {
  String id;
  String name;

  ProductTypeModel({
    required this.id,
    required this.name,
  });

  factory ProductTypeModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ProductTypeModel(
      id: json["id"] ?? notAvailable,
      name: json["name"] ?? notAvailable,
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

Future<List<ProductTypeModel>> getProductType(
    [int start = 0, int end = 100]) async {
  final response = await http.get(
      Uri.parse('$baseURL/products/listAllProductTypes/?start=$start&end=$end'),
      headers: authHeader());

  if (response.statusCode == 200) {
    return (jsonDecode(response.body)['items'] as List)
        .map((item) => ProductTypeModel.fromJson(item))
        .toList();
  } else {
    return [];
  }
}
