// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:benji_aggregator/app/overview/overview.dart';
import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/model/login_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../app/auth_screens/login.dart';

class LoginController extends GetxController {
  static LoginController get instance {
    return Get.find<LoginController>();
  }

  var isLoad = false.obs;

  @override
  void onInit() {
    checkAuth();
    super.onInit();
  }

  Future checkAuth() async {
    Get.put(UserController());

    if (await isAuthorized()) {
      Get.offAll(
        () => OverView(),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "OverView",
        predicate: (route) => false,
        popGesture: true,
        transition: Transition.cupertinoDialog,
      );
    } else {
      Get.offAll(() => const Login());
    }
  }

  Future login(SendLogin data) async {
    isLoad.value = true;
    Map finalData = {
      "username": data.username,
      "password": data.password,
    };

    // try {
    http.Response? response =
        await HandleData.postApi(Api.baseUrl + Api.login, null, finalData);

    if (response == null || response.statusCode != 200) {
      ApiProcessorController.errorSnack("Invalid email or password. Try again");
      isLoad.value = false;
      return;
    }

    var jsonData = jsonDecode(response.body);

    if (jsonData["token"] == false) {
      ApiProcessorController.errorSnack("Invalid email or password. Try again");
      isLoad.value = false;
    } else {
      http.Response? responseUser =
          await HandleData.getApi(Api.baseUrl + Api.user, jsonData["token"]);
      if (responseUser == null || response.statusCode != 200) {
        ApiProcessorController.errorSnack(
            "Invalid email or password. Try again");
        isLoad.value = false;
        return;
      }
      UserController.instance.saveUser(responseUser.body, jsonData["token"]);
      ApiProcessorController.successSnack("Login Successful");
      // var save = LoginModel.fromJson(jsonDecode(responseData));
      // await KeyStore.storeString(KeyStore.tokenKey, save.token);
      // username and password to be removed
      // await KeyStore.storeString(KeyStore.usernameKey, data.username);
      // await KeyStore.storeString(KeyStore.passwordKey, data.password);
      // await KeyStore.storeBool(KeyStore.isLoggedInKey, true);
      consoleLog("Here is your token oo ${jsonData["token"]}");
      await UserController.instance.checkAuth();
    }
    // } catch (e) {
    //   consoleLog(e.toString());
    // }

    isLoad.value = false;
    update();
  }
}
