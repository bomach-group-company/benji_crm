import 'package:benji_aggregator/src/providers/constants.dart';

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
