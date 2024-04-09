import 'package:benji_aggregator/model/sub_category.dart';
import 'package:benji_aggregator/src/utils/constants.dart';

import 'business_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantityAvailable;
  final String productImage;
  final bool isAvailable;
  final bool isTrending;
  final bool isRecommended;
  final BusinessModel business;
  final SubCategory subCategory;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantityAvailable,
    required this.productImage,
    required this.isAvailable,
    required this.isTrending,
    required this.isRecommended,
    required this.business,
    required this.subCategory,
  });

  factory ProductModel.fromJson(Map<String, dynamic>? json) {
    // print('search product $json');

    json ??= {};
    return ProductModel(
      id: json['id'] ?? notAvailable,
      name: json['name'] ?? notAvailable,
      description: json['description'] ?? notAvailable,
      price: (json['price'] ?? 0).toDouble() ?? 0.0,
      quantityAvailable: json['quantity_available'] ?? 0,
      productImage: json['product_image'],
      isAvailable: json['is_available'] ?? false,
      isTrending: json['is_trending'] ?? false,
      isRecommended: json['is_recommended'] ?? false,
      business: BusinessModel.fromJson(json['business']),
      subCategory: SubCategory.fromJson(json['sub_category']),
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "quantity_available": quantityAvailable,
        "product_image": productImage,
        "is_available": isAvailable,
        "is_trending": isTrending,
        "is_recommended": isRecommended,
        "business": business.toJson(),
        "sub_category_id": subCategory.toJson(),
      };
}
