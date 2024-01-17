import 'dart:convert';
import 'dart:io';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/model/bank_model.dart';
import 'package:benji_aggregator/model/validate_bank_account.dart';
import 'package:benji_aggregator/model/withdrawal_history_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WithdrawController extends GetxController {
  static WithdrawController get instance {
    return Get.find<WithdrawController>();
  }

  var isLoadWithdraw = false.obs;
  var isLoad = false.obs;
  var isLoadValidateAccount = false.obs;
  // var userId = UserController.instance.user.value.id;
  var listOfBankDetail = <BankModel>[].obs;
  var listOfBanksSearch = <BankModel>[].obs;
  var listOfWithdrawals = <WithdrawalHistoryModel>[].obs;
  var validateAccount = ValidateBankAccountModel.fromJson(null).obs;
  var noWithdrawalHistory = "".obs;

  // makeWithdrawal(double amount) {
  //   final userId = UserController.instance.user.value.id;
  // }

  listBanks() async {
    var url = "${Api.baseUrl}${Api.listBanks}";
    isLoad.value = true;
    // update();
    try {
      final response = await http.get(Uri.parse(url), headers: authHeader());
      if (response.statusCode == 200) {
        dynamic jsonResponse = jsonDecode(response.body);
        listOfBankDetail.value =
            BankModel.listFromJson(jsonResponse.cast<Map<String, dynamic>>());
        listOfBanksSearch = listOfBankDetail;
      } else {
        listOfBankDetail.value = [];
        listOfBanksSearch.value = [];
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    }
    isLoad.value = false;
    update();
  }

  Future<void> validateBankNumbers(
      String accountNumber, String bankCode) async {
    var url =
        "${Api.baseUrl}${Api.validateBankNumber}?account_number=$accountNumber&bank_code=$bankCode";
    isLoadValidateAccount.value = true;
    update();

    try {
      final response = await http.get(Uri.parse(url), headers: authHeader());

      if (response.statusCode != 200) {
        validateAccount.value = ValidateBankAccountModel.fromJson(null);
        return;
      }
      var responseData = jsonDecode(response.body);
      validateAccount.value = ValidateBankAccountModel.fromJson(
          responseData as Map<String, dynamic>);
      // responseData.map((item) => ValidateBankAccountModel.fromJson(item));
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      ApiProcessorController.errorSnack(
          "An unexpected error occurred. \nERROR: $e");
    }

    isLoadValidateAccount.value = false;
    update();
    return;
  }

  Future withdrawalHistory() async {
    var userId = UserController.instance.user.value.id;

    var url =
        "${Api.baseUrl}${Api.withdrawalHistory}?user_id=$userId&start=0&end=100";
    isLoad.value = true;
    update();

    try {
      final response = await http.get(Uri.parse(url), headers: authHeader());

      if (response.statusCode == 200) {
        try {
          List<WithdrawalHistoryModel> withdrawalHistoryList =
              (jsonDecode(response.body)['items'] as List)
                  .map((item) => WithdrawalHistoryModel.fromJson(item))
                  .toList();
          listOfWithdrawals.value = withdrawalHistoryList;
        } on SocketException {
          ApiProcessorController.errorSnack("Please connect to the internet");
        } catch (e) {
          ApiProcessorController.errorSnack(
              "An unexpected error occurred. \nERROR: $e");
          listOfWithdrawals.value = [];
        }
      } else {
        listOfWithdrawals.value = [];
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      ApiProcessorController.errorSnack(
          "An unexpected error occurred. \nERROR: $e");
    }

    isLoad.value = false;
    update();

    return;
  }

  Future<http.Response> withdraw(Map data) async {
    isLoadWithdraw.value = true;
    update();
    final response = await http.post(
      Uri.parse('${Api.baseUrl}/wallet/requestRiderWithdrawal'),
      headers: authHeader(),
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      ApiProcessorController.errorSnack(
          'Balance too small or an error occured');
      isLoadWithdraw.value = false;
      update();
      return response;
    }

    ApiProcessorController.successSnack('Withdrawal successfully');
    isLoadWithdraw.value = false;
    update();
    return response;
  }
}
