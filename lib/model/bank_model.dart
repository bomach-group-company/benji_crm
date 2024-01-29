import 'package:benji_aggregator/src/providers/constants.dart';

class BankModel {
  String name;
  String code;
  String ussdTemplate;
  String baseUssdCode;
  String transferUssdTemplate;
  // String logo;

  BankModel({
    required this.name,
    required this.code,
    required this.ussdTemplate,
    required this.baseUssdCode,
    required this.transferUssdTemplate,
    // required this.logo,
  });

  factory BankModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return BankModel(
      name: json['name'] ?? notAvailable,
      code: json['code'] ?? notAvailable,
      ussdTemplate: json['ussdTemplate'] ?? notAvailable,
      baseUssdCode: json['baseUssdCode'] ?? notAvailable,
      // logo: json['logo'] ?? notAvailable,
      transferUssdTemplate: json['transferUssdTemplate'] ?? notAvailable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'ussdTemplate': ussdTemplate,
      'baseUssdCode': baseUssdCode,
      'transferUssdTemplate': transferUssdTemplate,
    };
  }

  static List<BankModel> listFromJson(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => BankModel.fromJson(json)).toList();
  }
}
