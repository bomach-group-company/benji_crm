import 'package:benji_aggregator/model/client_model.dart';
import 'package:benji_aggregator/model/product_model.dart';
import 'package:benji_aggregator/src/utils/constants.dart';

import 'address_model.dart';

// class BusinessOrderModel {
//   String id;
//   String code;
//   double totalPrice;
//   double deliveryFee;
//   String assignedStatus;
//   String deliveryStatus;
//   Client client;
//   List<Orderitem> orderitems;
//   String latitude;
//   String longitude;
//   DeliveryAddress deliveryAddress;
//   String message;
//   String created;

//   BusinessOrderModel({
//     required this.id,
//     required this.code,
//     required this.totalPrice,
//     required this.deliveryFee,
//     required this.assignedStatus,
//     required this.deliveryStatus,
//     required this.client,
//   });

//   factory BusinessOrderModel.fromJson(Map<String, dynamic>? json) {
//     json ??= {};
//     return BusinessOrderModel(
//       id: json["id"] ?? notAvailable,
//       code: json["code"] ?? notAvailable,
//       totalPrice: json["total_price"] ?? 0.0,
//       deliveryFee: json["delivery_fee"] ?? 0.0,
//       assignedStatus: json["assigned_status"] ?? "PEND",
//       deliveryStatus: json["delivery_status"] ?? "PEND",
//       client: Client.fromJson(json["client"]),
//     );
//   }
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "code": code,
//         "total_price": totalPrice,
//         "delivery_fee": deliveryFee,
//         "assigned_status": assignedStatus,
//         "delivery_status": deliveryStatus,
//         "client": client.toJson(),
//       };
// }

// class Orderitem {
//   String id;
//   ProductModel product;
//   int quantity;

//   Orderitem({
//     required this.id,
//     required this.product,
//     required this.quantity,
//   });

//   factory Orderitem.fromJson(Map<String, dynamic>? json) {
//     json ??= {};
//     return Orderitem(
//       id: json["id"] ?? notAvailable,
//       product: json["product"],
//       quantity: json["quantity"] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "product": product,
//         "quantity": quantity,
//       };
// }

class BusinessOrderModel {
  String id;
  String code;
  double totalPrice;
  double deliveryFee;
  String assignedStatus;
  String deliveryStatus;
  Client client;
  List<Orderitem> orderitems;
  String latitude;
  String longitude;
  DeliveryAddress deliveryAddress;
  String message;
  String created;

  BusinessOrderModel({
    required this.id,
    required this.code,
    required this.totalPrice,
    required this.deliveryFee,
    required this.assignedStatus,
    required this.deliveryStatus,
    required this.client,
    required this.orderitems,
    required this.latitude,
    required this.longitude,
    required this.deliveryAddress,
    required this.message,
    required this.created,
  });

  factory BusinessOrderModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    print('$json BusinessOrderModel');
    return BusinessOrderModel(
      id: json["id"] ?? notAvailable,
      code: json["code"] ?? notAvailable,
      totalPrice: json["total_price"] ?? 0.0,
      deliveryFee: json["delivery_fee"] ?? 0.0,
      assignedStatus: json["assigned_status"] ?? "PEND",
      deliveryStatus: json["delivery_status"] ?? "PEND",
      client: Client.fromJson(json["client"]),
      orderitems: json["orderitems"] == null
          ? []
          : (json["orderitems"] as List)
              .map((item) => Orderitem.fromJson(Map.from(item)))
              .toList(),
      latitude: json["latitude"] ?? notAvailable,
      longitude: json["longitude"] ?? notAvailable,
      deliveryAddress: DeliveryAddress.fromJson(json["delivery_address"]),
      message: json["message"] ?? notAvailable,
      created: json["created"] ?? notAvailable,
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
        "orderitems": orderitems.map((item) => (item).toJson()).toList(),
        "latitude": latitude,
        "longitude": longitude,
        "delivery_address": deliveryAddress,
        "message": message,
        "created": created,
      };
}

class Orderitem {
  String id;
  ProductModel product;
  int quantity;
  DeliveryAddress deliveryAddress;

  Orderitem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.deliveryAddress,
  });

  factory Orderitem.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Orderitem(
      id: json["id"] ?? notAvailable,
      product: ProductModel.fromJson(json["product"]),
      deliveryAddress: DeliveryAddress.fromJson(json["delivery_address"]),
      quantity: json["quantity"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product.toJson(),
        "delivery_address": deliveryAddress.toJson(),
        "quantity": quantity,
      };
}
