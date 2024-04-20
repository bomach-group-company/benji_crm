import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/model/bank_model.dart';
import 'package:benji_aggregator/model/validate_bank_account.dart';
import 'package:benji_aggregator/model/withdrawal_history_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'user_controller.dart';

class WithdrawController extends GetxController {
  static WithdrawController get instance {
    return Get.find<WithdrawController>();
  }

  var isLoadWithdraw = false.obs;
  var isLoad = false.obs;

  var loadNum = 10.obs;
  var loadedAll = false.obs;
  var isLoadMore = false.obs;
  var isLoadValidateAccount = false.obs;

  var userId = UserController.instance.user.value.id;
  var listOfBanks = <BankModel>[].obs;
  var validateAccount = ValidateBankAccountModel.fromJson(null).obs;
  var noWithdrawalHistory = "".obs;
  var listOfWithdrawals = <WithdrawalHistoryModel>[].obs;

  Future<void> scrollListener(scrollController) async {
    if (loadedAll.value || isLoadMore.value) {
      return;
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      isLoadMore.value = true;
      update();
      await withdrawalHistory();
    }
  }

  refreshWithdraaw() {
    loadedAll.value = false;
    loadNum.value = 10;
    isLoadMore.value = false;
    withdrawalHistory();
  }

  // makeWithdrawal(double amount) {
  //   final userId = UserController.instance.user.value.id;
  // }

  getBanks() async {
    var url = Api.baseUrl + Api.getBanks;
    isLoad.value = true;
    try {
      final response = await http.get(Uri.parse(url), headers: authHeader());
      if (response.statusCode == 200) {
        dynamic jsonResponse = jsonDecode(response.body);
        log((jsonResponse['responseBody'] as List).toString());

        listOfBanks.value = (jsonResponse['responseBody'] as List)
            .map((json) => BankModel.fromJson(json))
            .toList();
      } else {
        listOfBanks.value = [];
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
      getBanks();
    } catch (e) {
      log(e.toString());
    }
    isLoad.value = false;
    update();
  }

  Future withdrawalHistory() async {
    var userId = UserController.instance.user.value.id;

    var url =
        "${Api.baseUrl}${Api.withdrawalHistory}?user_id=$userId&start=${loadNum.value - 10}&end=${loadNum.value}";
    loadNum.value += 10;
    isLoad.value = true;
    update();

    log(url);
    try {
      final response = await http.get(Uri.parse(url), headers: authHeader());
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        log("Withdrawal History: ${jsonDecode(response.body) as List}");
        try {
          List<WithdrawalHistoryModel> withdrawalHistoryList =
              (jsonDecode(response.body) as List)
                  .map((item) => WithdrawalHistoryModel.fromJson(item))
                  .toList();
          listOfWithdrawals.value += withdrawalHistoryList;
          loadedAll.value = withdrawalHistoryList.isEmpty;
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
      withdrawalHistory();
    } catch (e) {
      ApiProcessorController.errorSnack(
          "An unexpected error occurred. \nERROR: $e");
    }

    isLoad.value = false;
    isLoadMore.value = false;
    update();

    return;
  }

  Future<void> validateBankNumbers(
      String accountNumber, String bankCode) async {
    var url =
        "${Api.baseUrl}${Api.validateBankNumber}$accountNumber/$bankCode/monnify";
    isLoadValidateAccount.value = true;
    // update();
    log('$accountNumber, $bankCode');
    log('validateBankNumbers, $url');
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

  Future<http.Response> withdraw(Map data) async {
    isLoadWithdraw.value = true;
    update();
    final response = await http.post(
      Uri.parse('${Api.baseUrl}/wallet/requestAgentWithdrawal'),
      headers: authHeader(),
      body: jsonEncode(data),
    );

    print(data);

    if (response.statusCode != 200) {
      ApiProcessorController.errorSnack(jsonDecode(response.body)['message']);
      isLoadWithdraw.value = false;
      update();
      return response;
    }

    ApiProcessorController.successSnack('Withdrawal successful');
    isLoadWithdraw.value = false;
    update();
    return response;
  }
}
