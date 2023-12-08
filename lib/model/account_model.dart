import 'package:benji_aggregator/src/providers/constants.dart';

class AccountModel {
  String id;
  int userId;
  String bankName;
  String bankCode;
  String accountHolder;
  String accountNumber;
  // String logo;

  AccountModel({
    required this.id,
    required this.userId,
    required this.bankName,
    required this.bankCode,
    required this.accountHolder,
    required this.accountNumber,
    // required this.logo,
  });

  factory AccountModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return AccountModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? 0,
      bankName: json['bank_name'] ?? notAvailable,
      bankCode: json['bank_code'] ?? notAvailable,
      accountHolder: json['account_holder'] ?? notAvailable,
      accountNumber: json['account_number'] ?? notAvailable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bank_name': bankName,
      'bank_code': bankCode,
      'account_holder': accountHolder,
      'account_number': accountNumber,
    };
  }

  static List<AccountModel> listFromJson(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => AccountModel.fromJson(json)).toList();
  }
}
