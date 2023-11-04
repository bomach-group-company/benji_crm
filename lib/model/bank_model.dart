import 'package:benji_aggregator/src/providers/constants.dart';

class BankModel {
  String name;
  String slug;
  String code;
  String longCode;
  String gateway;
  bool active;
  String country;
  String currency;
  String type;

  BankModel({
    required this.name,
    required this.slug,
    required this.code,
    required this.longCode,
    required this.gateway,
    required this.active,
    required this.country,
    required this.currency,
    required this.type,
  });

  factory BankModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return BankModel(
      name: json['name'] ?? notAvailable,
      slug: json['slug'] ?? notAvailable,
      code: json['code'] ?? notAvailable,
      longCode: json['longCode'] ?? notAvailable,
      gateway: json['gateway'] ?? notAvailable,
      active: json['active'] ?? false,
      country: json['country'] ?? notAvailable,
      currency: json['currency'] ?? notAvailable,
      type: json['type'] ?? notAvailable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'code': code,
      'longCode': longCode,
      'gateway': gateway,
      'active': active,
      'country': country,
      'currency': currency,
      'type': type,
    };
  }
}
