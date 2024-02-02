import 'package:benji_aggregator/src/providers/constants.dart';

class ValidateBankAccountModel {
  bool requestSuccessful;
  String responseMessage;
  String responseCode;
  BankDetailModel responseBody;

  ValidateBankAccountModel({
    required this.requestSuccessful,
    required this.responseMessage,
    required this.responseCode,
    required this.responseBody,
  });

  factory ValidateBankAccountModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ValidateBankAccountModel(
      requestSuccessful: json['requestSuccessful'] ?? false,
      responseMessage: json['responseMessage'] ?? notAvailable,
      responseCode: json['responseCode'] ?? notAvailable,
      responseBody: BankDetailModel.fromJson(
          json['responseBody'] as Map<String, dynamic>?),
    );
  }
}

class BankDetailModel {
  String accountNumber;
  String accountName;
  String bankCode;

  BankDetailModel({
    required this.accountNumber,
    required this.accountName,
    required this.bankCode,
  });

  factory BankDetailModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return BankDetailModel(
      accountNumber: json['accountNumber'] ?? notAvailable,
      accountName: json['accountName'] ?? notAvailable,
      bankCode: json['bankCode'] ?? notAvailable,
    );
  }
}
