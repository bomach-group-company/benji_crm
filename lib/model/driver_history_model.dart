import 'package:benji_aggregator/model/rider_model.dart';
import 'package:benji_aggregator/src/providers/constants.dart';

class HistoryItem {
  String id;
  // Order orders;
  RiderItem driver;
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
        driver: RiderItem.fromJson(json["driver"]),
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
