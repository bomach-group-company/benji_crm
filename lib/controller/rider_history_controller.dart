// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/model/rider_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/driver_history_model.dart';

class RiderHistoryController extends GetxController {
  static RiderHistoryController get instance {
    return Get.find<RiderHistoryController>();
  }

  var moreNum = 4.obs;
  var loadedAll = false.obs;
  var isLoad = false.obs;
  var isLoadMore = false.obs;
  var historyList = <HistoryItem>[].obs;
  var clickedRider = RiderItem.fromJson(null).obs;

  setClickedRider(RiderItem value) {
    clickedRider.value = value;
    update();
  }

  Future riderHistory() async {
    isLoad.value = true;
    late String token;
    update();
    if (clickedRider.value.id == 0) {
      historyList.value = [];
      isLoad.value = false;
      update();
      return;
    }
    var url =
        "${Api.baseUrl}${Api.riderHistory}?rider_id=${clickedRider.value.id}&start=0&end=${moreNum.value}";

    token = UserController.instance.user.value.token;
    // try {
    http.Response? response = await HandleData.getApi(url, token);

    var responseData = await ApiProcessorController.errorState(response);
    // try {
    List<HistoryItem> val = (jsonDecode(responseData)['items'] as List)
        .map((e) => HistoryItem.fromJson(e))
        .toList();
    historyList.value = val;
    loadedAll.value = false;
    // } catch (e) {
    //   consoleLog("$e");
    // }
    // notification.value = save;
    isLoad.value = false;
    update();
    // } catch (e) {
    //   print('$e  errorrrr ');
    // }
    isLoad.value = false;
    update();
  }

  Future loadMore([String? end]) async {
    isLoadMore.value = true;
    late String token;
    update();
    if (clickedRider.value.id == 0) {
      historyList.value = [];
      isLoadMore.value = false;
      update();
      return;
    }
    var url =
        "${Api.baseUrl}${Api.riderHistory}?rider_id=${clickedRider.value.id}&start=${moreNum.value}&end=${moreNum.value + 4}";
    moreNum.value = moreNum.value + 10;
    token = UserController.instance.user.value.token;
    // try {
    http.Response? response = await HandleData.getApi(url, token);

    var responseData = await ApiProcessorController.errorState(response);
    // try {
    List<HistoryItem> val = (jsonDecode(responseData)['items'] as List)
        .map((e) => HistoryItem.fromJson(e))
        .toList();
    historyList.value += val;
    loadedAll.value = val.isEmpty;
    // } catch (e) {
    //   consoleLog("$e");
    // }
    // notification.value = save;
    // } catch (e) {
    //   print('$e  errorrrr ');
    // }
    isLoadMore.value = false;
    update();
  }

  emptyRiderHistoryList() {
    historyList.value = [];
    loadedAll.value = false;
    moreNum.value = 4;
    update();
  }
}
