// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/model/rider_list_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/driver_history_model.dart';

class RiderHistoryController extends GetxController {
  static RiderHistoryController get instance {
    return Get.find<RiderHistoryController>();
  }

  // RiderHistoryController();

  var isLoad = false.obs;
  var historyList = <HistoryItem>[].obs;
  var clickedRider = RiderItem.fromJson(null).obs;

  @override
  void onInit() async {
    // await riderHistory();
    print('called onInit in rider history ${clickedRider.value.id}');
    super.onInit();
  }

  setClickedRider(RiderItem value) {
    clickedRider.value = value;
    update();
    print('is a go ${clickedRider.value.id}');
  }

  Future riderHistory([String? end]) async {
    print('holaa d sbjddfdf dfdfdfndfn ndnmnmd  emm ${clickedRider.value.id}');
    isLoad.value = true;
    late String token;
    update();
    print(clickedRider.value.toJson());
    if (clickedRider.value.id == 0) {
      print('at lest in the if 0');
      historyList.value = [];
      isLoad.value = false;
      update();
      update();
      return;
    }
    var url =
        "${Api.baseUrl}${Api.riderHistory}?rider_id=${clickedRider.value.id}&start=0&end=${end ?? 100}";

    token = UserController.instance.user.value.token;
    print('i am amama kkk ');
    // try {
    http.Response? response = await HandleData.getApi(url, token);

    var responseData = await ApiProcessorController.errorState(response);
    print('sbrjr oo $responseData responseData kk');
    // try {
    // var save = DriverHistoryModel.fromJson(jsonDecode(responseData));
    historyList.value = (jsonDecode(responseData)['items'] as List)
        .map((e) => HistoryItem.fromJson(e))
        .toList();
    // historyList.value = save.items!;
    print('as least in here ooo ${historyList.value}');
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
}
