// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/order_list_model.dart';

class OrderController extends GetxController {
  static OrderController get instance {
    return Get.find<OrderController>();
  }

  bool? isFirst;
  OrderController({this.isFirst});
  var isLoad = false.obs;
  var orderList = <OrderItem>[].obs;

  @override
  void onInit() {
    runTask();

    super.onInit();
  }

  Future runTask([String? end]) async {
    isLoad.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    update();
    var url = "${Api.baseUrl}${Api.orderList}$id/?start=1&end=${end ?? 100}";
    token = UserController.instance.user.value.token;
    consoleLog(token);
    try {
      http.Response? response = await HandleData.getApi(url, token);
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);
      if (responseData == null) {
        return;
      }

      try {
        var save = OrderListModel.fromJson(jsonDecode(responseData));
        orderList.value = save.items!;
        consoleLog(responseData);
      } catch (e) {
        consoleLog(e.toString());
      }

      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }
}
