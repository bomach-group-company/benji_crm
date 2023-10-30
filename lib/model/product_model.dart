import 'package:benji_aggregator/model/sub_category.dart';
import 'package:benji_aggregator/model/vendor_model.dart';

class Product {
  String id;
  String name;
  String description;
  dynamic price;
  dynamic quantityAvailable;
  String productImage;
  bool isAvailable;
  bool isTrending;
  bool isRecommended;
  VendorModel vendor;
  SubCategory subCategory;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantityAvailable,
    required this.productImage,
    required this.isAvailable,
    required this.isTrending,
    required this.isRecommended,
    required this.vendor,
    required this.subCategory,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        quantityAvailable: json["quantity_available"],
        productImage: json["product_image"],
        isAvailable: json["is_available"],
        isTrending: json["is_trending"],
        isRecommended: json["is_recommended"],
        vendor: VendorModel.fromJson(json["vendor"]),
        subCategory: SubCategory.fromJson(json["sub_category"]),
      );

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
        "vendor_id": vendor.toJson(),
        "sub_category_id": subCategory.toJson(),
      };
}
