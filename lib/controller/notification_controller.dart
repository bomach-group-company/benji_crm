import 'dart:convert';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/model/notificatin_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController {
  static NotificationController get instance {
    return Get.find<NotificationController>();
  }

  var isLoad = false.obs;
  var notification = NotificationModel().obs;
  Future runTask(token) async {
    isLoad.value = true;
    update();
    var url = Api.baseUrl +
        Api.notification +
        UserController.instance.user.value.id!.toString();
    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData = await ApiProcessorController.errorState(response);
      var save = NotificationModel.fromJson(jsonDecode(responseData));
      notification.value = save;
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }
}
