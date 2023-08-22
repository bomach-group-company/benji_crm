import 'dart:convert';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/model/user_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;

import '../app/overview/overview.dart';

class UserController extends GetxController {
  static UserController get instance {
    return Get.find<UserController>();
  }

  var isLoad = false.obs;
  var user = UserModel().obs;
  Future runUserTask(token) async {
    isLoad.value = true;
    update();
    var url = Api.baseUrl + Api.user;
    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData = await ApiProcessorController.errorState(response);
      var save = UserModel.fromJson(jsonDecode(responseData));
      user.value = save;
      // update();
      Get.offAll(
        () => const OverView(),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Dashboard",
        predicate: (route) => false,
        popGesture: true,
        transition: Transition.fadeIn,
      );
    } catch (e) {}
    isLoad.value = false;
    update();
  }
}
