// To parse this JSON data, do
//
//     final driverHistoryModel = driverHistoryModelFromJson(jsonString);

import 'dart:convert';

import 'package:benji_aggregator/src/providers/constants.dart';

DriverHistoryModel driverHistoryModelFromJson(String str) =>
    DriverHistoryModel.fromJson(json.decode(str));

String driverHistoryModelToJson(DriverHistoryModel data) =>
    json.encode(data.toJson());

class DriverHistoryModel {
  List<HistoryItem>? items;
  int? total;
  int? perPage;
  int? start;
  int? end;

  DriverHistoryModel({
    this.items,
    this.total,
    this.perPage,
    this.start,
    this.end,
  });

  factory DriverHistoryModel.fromJson(Map<String, dynamic> json) =>
      DriverHistoryModel(
        items: json["items"] == null
            ? []
            : List<HistoryItem>.from(
                json["items"]!.map((x) => HistoryItem.fromJson(x))),
        total: json["total"],
        perPage: json["per_page"],
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "total": total,
        "per_page": perPage,
        "start": start,
        "end": end,
      };
}

class HistoryItem {
  String id;
  // Order orders;
  Driver driver;
  String acceptanceStatus;
  String deliveryStatus;
  String createdDate;
  String deliveredDate;

  HistoryItem({
    required this.id,
    // required this.orders,
    required this.driver,
    required this.acceptanceStatus,
    required this.deliveryStatus,
    required this.createdDate,
    required this.deliveredDate,
  });

  factory HistoryItem.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return HistoryItem(
        id: json["id"] ?? notAvailable,
        // orders: Order.fromJson(json["orders"]),
        driver: Driver.fromJson(json["driver"]),
        acceptanceStatus: json["acceptance_status"] ?? "PEND",
        deliveryStatus: json["delivery_status"] ?? "pending",
        createdDate: json["created_date"] ?? notAvailable,
        deliveredDate: json["delivered_date"] ?? notAvailable);
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        // "orders": orders,
        "driver": driver.toJson(),
        "acceptance_status": acceptanceStatus,
        "delivery_status": deliveryStatus,
        "created_date": createdDate,
        "delivered_date": deliveredDate,
      };
}

class Driver {
  int id;
  String code;
  String email;
  String username;
  String phone;
  String firstName;
  String lastName;
  String gender;
  String? image;
  String address;
  String plateNumber;
  String chassisNumber;

  Driver({
    required this.id,
    required this.code,
    required this.email,
    required this.username,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.gender,
    this.image,
    required this.address,
    required this.plateNumber,
    required this.chassisNumber,
  });

  factory Driver.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Driver(
      id: json["id"] ?? 0,
      code: json["code"] ?? notAvailable,
      email: json["email"] ?? notAvailable,
      username: json["username"] ?? notAvailable,
      phone: json["phone"] ?? notAvailable,
      firstName: json["first_name"] ?? notAvailable,
      lastName: json["last_name"] ?? notAvailable,
      gender: json["gender"] ?? notAvailable,
      image: json["image"],
      address: json["address"] ?? notAvailable,
      plateNumber: json["plate_number"] ?? notAvailable,
      chassisNumber: json["chassis_number"] ?? notAvailable,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "email": email,
        "username": username,
        "phone": phone,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "image": image,
        "address": address,
        "plate_number": plateNumber,
        "chassis_number": chassisNumber,
      };
}

class Order {
  String id;
  String code;
  double totalPrice;
  double deliveryFee;
  String assignedStatus;
  String deliveryStatus;
  Client client;

  Order({
    required this.id,
    required this.code,
    required this.totalPrice,
    required this.deliveryFee,
    required this.assignedStatus,
    required this.deliveryStatus,
    required this.client,
  });

  factory Order.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Order(
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

class Client {
  int id;
  String email;
  String username;
  String phone;
  String firstName;
  String lastName;
  String? image;
  String code;

  Client({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.image,
    required this.code,
  });

  factory Client.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Client(
      id: json["id"] ?? 0,
      email: json["email"] ?? notAvailable,
      username: json["username"] ?? notAvailable,
      phone: json["phone"] ?? notAvailable,
      firstName: json["first_name"] ?? notAvailable,
      lastName: json["last_name"] ?? notAvailable,
      image: json["image"],
      code: json["code"] ?? notAvailable,
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "phone": phone,
        "first_name": firstName,
        "last_name": lastName,
        "image": image,
        "code": code,
      };
}

class DeliveryAddress {
  String id;
  String title;
  String details;
  String phone;
  String latitude;
  String longitude;
  bool isCurrent;

  DeliveryAddress({
    required this.id,
    required this.title,
    required this.details,
    required this.phone,
    required this.isCurrent,
    required this.latitude,
    required this.longitude,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return DeliveryAddress(
      id: json["id"],
      title: json["title"],
      details: json["details"],
      phone: json["phone"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      isCurrent: json["is_current"],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "details": details,
        "phone": phone,
        "latitude": latitude,
        "longitude": longitude,
        "is_current": isCurrent,
      };
}

class Orderitem {
  String id;
  dynamic product;
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
      product: json["product"] ?? notAvailable,
      quantity: json["quantity"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product,
        "quantity": quantity,
      };
}
