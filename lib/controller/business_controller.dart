import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/services/helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/business_model.dart';
import '../services/api_url.dart';
import 'api_processor_controller.dart';
import 'user_controller.dart';

class BusinessController extends GetxController {
  static BusinessController get instance {
    return Get.find<BusinessController>();
  }

  bool? isFirst;
  BusinessController({this.isFirst});
  var isLoadBalance = false.obs;
  var balance = 0.0.obs;

  var isLoad = false.obs;
  var isLoadBusinessStatus = false.obs;
  var isBusinessOpen = false.obs;
  var isLoadBusinessInfo = false.obs;
  var listOfBusinesses = <BusinessModel>[].obs;
  var totalNumberOfBusiness = <BusinessModel>[].obs;
  // vendor pagination
  var loadNumBusinesses = 10.obs;
  var loadedAllBusinesses = false.obs;
  var isLoadMoreBusinesses = false.obs;

  setBusiness(businessId) async {
    var url = "${Api.baseUrl}/vendors/$businessId/getMybusinessInfo";
    try {
      var response = await http.get(Uri.parse(url), headers: authHeader());

      if (response.statusCode == 200) {
        log("This is the response body of the business status: ${response.body}");
        var responseJson = jsonDecode(response.body);
        print(responseJson["is_online"]);

        isBusinessOpen.value = responseJson["is_online"] ?? false;
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet.");
    }

    update();
  }

  refreshData(String vendorId, agentId) {
    loadNumBusinesses.value = 10;
    loadedAllBusinesses.value = false;
    isLoadMoreBusinesses.value = false;

    getBusinesses(vendorId, agentId);
  }

  Future<void> scrollListenerBusiness(
      scrollController, String vendorId, agentId) async {
    if (BusinessController.instance.loadedAllBusinesses.value) {
      return;
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      BusinessController.instance.isLoadMoreBusinesses.value = true;
      update();
      await BusinessController.instance.getBusinesses(vendorId, agentId);
    }
  }

  Future setBusinessOnlineStatus(
    String businessId,
    bool status,
  ) async {
    var url = Api.baseUrl + Api.setBusinessOnlineStatus(businessId, status);

    log(businessId);
    log(url);

    isLoadBusinessStatus.value = true;
    update();

    try {
      var response = await http.get(Uri.parse(url), headers: authHeader());

      if (response.statusCode == 200) {
        log("This is the response body of the business status: ${response.body}");
        var responseJson = jsonDecode(response.body);
        print(responseJson["is_online"]);

        isBusinessOpen.value = responseJson["is_online"] ?? false;
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet.");
    }
    isLoadBusinessStatus.value = false;
    update();
  }

  Future getBusinessInfo(String businessId) async {
    var url = Api.baseUrl + Api.getMyBusinessInfo(businessId);
    isLoadBusinessInfo.value = true;
    update();

    try {
      var response = await http.get(Uri.parse(url), headers: authHeader());

      if (response.statusCode == 200) {
        log("This is the response body of business info: ${response.body}");
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet.");
    }
    isLoadBusinessInfo.value = false;
    update();
  }

  Future getBusinesses(String vendorId, agentId) async {
    isLoad.value = true;

    late String token;
    token = UserController.instance.user.value.token;

    // var url = "${Api.baseUrl}${Api.getVendorBusinesses}$vendorId/$agentId"; // endpoint returns empty list always
    var url = "${Api.baseUrl}/vendors/getVendorBusinesses/$vendorId";

    log(url);

    loadNumBusinesses.value += 10;

    List<BusinessModel> data = [];
    try {
      http.Response? response = await HandleData.getApi(url, token);

      log(response!.body);
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);

      if (response.statusCode == 200) {
        data = (jsonDecode(responseData) as List)
            .map((e) => BusinessModel.fromJson(e))
            .toList();
      } else {
        ApiProcessorController.errorSnack(
          "An error occurred in fetching businesses.",
        );
      }

      listOfBusinesses.value = data;
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet.");
    } catch (e) {
      log("ERROR log: ${e.toString()}");
      ApiProcessorController.errorSnack(
        "An error occurred in fetching the businesses. Please try again later.",
      );
    }
    loadedAllBusinesses.value = data.isEmpty;
    isLoadMoreBusinesses.value = false;

    isLoad.value = false;
    update();
  }

  Future getVendorBusinessBalance(String id) async {
    isLoadBalance.value = true;

    try {
      String url = '${Api.baseUrl}/wallet/getvendorbusinessbalance/$id';
      var parsedURL = Uri.parse(url);

      final result = await http.get(
        parsedURL,
        headers: authHeader(),
      );
      if (result.statusCode != 200) {
        ApiProcessorController.errorSnack("Something went wrong");
        return;
      }
      balance.value =
          double.parse(jsonDecode(result.body)['balance'].toString());
      isLoadBalance.value = false;
      update();
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<http.Response?> getVendorBusinessWithdraw(BusinessModel business,
      {double shopReward = 0.0}) async {
    String url = '${Api.baseUrl}/wallet/requestVendorRewardWithdrawal';

    try {
      final body = {
        "business_id": business.id,
        "amount_to_withdraw": shopReward,
        // "bank_details_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
      };
      // print(body);
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: authHeader(),
      );
      log('value of type what');
      return response;
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future getTotalNumberOfBusinesses(String vendorId, agentId) async {
    isLoad.value = true;

    late String token;
    token = UserController.instance.user.value.token;

    var url = "${Api.baseUrl}${Api.getVendorBusinesses}$vendorId/$agentId";

    loadNumBusinesses.value += 10;

    List<BusinessModel> data = [];
    try {
      http.Response? response = await HandleData.getApi(url, token);

      log(response!.body);
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);

      data = (jsonDecode(responseData) as List)
          .map((e) => BusinessModel.fromJson(e))
          .toList();
      log("Got all businesses here!");

      totalNumberOfBusiness.value = data;
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet.");
    } catch (e) {
      consoleLog("ERROR log: ${e.toString()}");
      ApiProcessorController.errorSnack(
        "An error occurred in fetching the businesses. Please try again later.\n ERROR: $e",
      );
    }
    loadedAllBusinesses.value = data.isEmpty;
    isLoadMoreBusinesses.value = false;

    isLoad.value = false;
    update();
  }
}
