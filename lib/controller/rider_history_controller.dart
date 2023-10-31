// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/driver_history_model.dart';

class RiderHistoryController extends GetxController {
  static RiderHistoryController get instance {
    return Get.find<RiderHistoryController>();
  }

  var moreNum = 10.obs;
  var loadedAll = false.obs;
  var isLoad = false.obs;
  var isLoadMore = false.obs;
  var historyList = <RiderHistory>[].obs;

  Future riderHistory(id) async {
    isLoad.value = true;
    late String token;
    update();
    if (id == 0) {
      historyList.value = [];
      isLoad.value = false;
      loadedAll.value = false;
      update();
      return;
    }
    var url =
        "${Api.baseUrl}${Api.riderHistory}?rider_id=$id&start=0&end=${moreNum.value}";

    token = UserController.instance.user.value.token;
    http.Response? response = await HandleData.getApi(url, token);

    var responseData = await ApiProcessorController.errorState(response);
    try {
      List<RiderHistory> val = (jsonDecode(responseData)['items'] as List)
          .map((e) => RiderHistory.fromJson(e))
          .toList();
      historyList.value = val;
    } catch (e) {
      consoleLog("$e");
    }

    loadedAll.value = false;
    isLoad.value = false;
    update();
  }

  Future loadMore(id, [String? end]) async {
    isLoadMore.value = true;
    late String token;
    update();
    if (id == 0) {
      historyList.value = [];
      isLoadMore.value = false;
      loadedAll.value = false;

      update();
      return;
    }
    var url =
        "${Api.baseUrl}${Api.riderHistory}?rider_id=$id&start=${moreNum.value}&end=${moreNum.value + 10}";
    moreNum.value = moreNum.value + 10;
    token = UserController.instance.user.value.token;
    http.Response? response = await HandleData.getApi(url, token);

    var responseData = await ApiProcessorController.errorState(response);
    try {
      List<RiderHistory> val = (jsonDecode(responseData)['items'] as List)
          .map((e) => RiderHistory.fromJson(e))
          .toList();
      historyList.value += val;
      loadedAll.value = val.isEmpty;
    } catch (e) {
      consoleLog("$e");
    }

    isLoadMore.value = false;
    update();
  }

  emptyRiderHistoryList() {
    historyList.value = [];
    loadedAll.value = false;
    moreNum.value = 10;
    update();
  }
}
