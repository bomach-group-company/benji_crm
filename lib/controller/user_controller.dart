// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/login_controller.dart';
import 'package:benji_aggregator/model/user_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../app/overview/overview.dart';

class UserController extends GetxController {
  static UserController get instance {
    return Get.find<UserController>();
  }

  bool? isFirst;
  UserController({this.isFirst});

  var isLoading = false.obs;
  var user = UserModel.fromJson(null).obs;

//===================== Log in the user ==================\\
  Future runUserTask(token) async {
    isLoading.value = true;
    update();
    var url = Api.baseUrl + Api.user;
    try {
      http.Response? response = await HandleData.getApi(url, token);
      if (response != null) {
        var responseData =
            await ApiProcessorController.errorState(response, isFirst ?? true);
        if (responseData == null) {
          LoginController.instance.resetTokenValue(false);
          consoleLog("We can't get this user's details");
        } else {
          LoginController.instance.resetTokenValue(true);
          var save = UserModel.fromJson(jsonDecode(responseData));
          user.value = save;
          // update();
          Get.offAll(
            () => OverView(),
            fullscreenDialog: true,
            curve: Curves.easeIn,
            routeName: "OverView",
            predicate: (route) => false,
            popGesture: true,
            transition: Transition.cupertinoDialog,
          );
        }
      }
    } catch (e) {
      ApiProcessorController.errorSnack("An error occured: $e");
    }
    isLoading.value = false;
    update();
  }
}
