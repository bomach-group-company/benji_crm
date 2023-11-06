import '../src/providers/constants.dart';

class BankModel {
  String name;
  String bankCode;
  String cbnCode;
  String bankShortName;
  String ussdCode;
  String logo;

  BankModel({
    required this.name,
    required this.bankCode,
    required this.cbnCode,
    required this.bankShortName,
    required this.ussdCode,
    required this.logo,
  });

  factory BankModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return BankModel(
      name: json['name'] ?? notAvailable,
      bankCode: json['bank_code'] ?? notAvailable,
      cbnCode: json['cbn_code'] ?? notAvailable,
      ussdCode: json['ussd_code'] ?? notAvailable,
      logo: json['logo'] ?? notAvailable,
      bankShortName: json['bank_short_name'] ?? notAvailable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bank_code': bankCode,
      'cbn_code': cbnCode,
      'logo': logo,
      'bank_short_name': bankShortName,
      'ussd_code': ussdCode,
    };
  }

  static List<BankModel> listFromJson(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => BankModel.fromJson(json)).toList();
  }
}
