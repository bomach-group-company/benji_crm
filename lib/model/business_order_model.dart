import 'package:benji_aggregator/model/client_model.dart';
import 'package:benji_aggregator/model/product_model.dart';
import 'package:benji_aggregator/src/providers/constants.dart';

class BusinessOrderModel {
  String id;
  String code;
  double totalPrice;
  double deliveryFee;
  String assignedStatus;
  String deliveryStatus;
  Client client;

  BusinessOrderModel({
    required this.id,
    required this.code,
    required this.totalPrice,
    required this.deliveryFee,
    required this.assignedStatus,
    required this.deliveryStatus,
    required this.client,
  });

  factory BusinessOrderModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return BusinessOrderModel(
      id: json["id"] ?? notAvailable,
      code: json["code"] ?? notAvailable,
      totalPrice: json["total_price"] ?? 0.0,
      deliveryFee: json["delivery_fee"] ?? 0.0,
      assignedStatus: json["assigned_status"] ?? "PEND",
      deliveryStatus: json["delivery_status"] ?? "PEND",
      client: Client.fromJson(json["client"]),
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "total_price": totalPrice,
        "delivery_fee": deliveryFee,
        "assigned_status": assignedStatus,
        "delivery_status": deliveryStatus,
        "client": client.toJson(),
      };
}

class Orderitem {
  String id;
  ProductModel product;
  int quantity;

  Orderitem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory Orderitem.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Orderitem(
      id: json["id"] ?? notAvailable,
      product: json["product"],
      quantity: json["quantity"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product,
        "quantity": quantity,
      };
}
