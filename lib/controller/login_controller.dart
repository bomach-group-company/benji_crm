import 'dart:convert';
import 'package:benji_aggregator/app/screens/login.dart';
import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/model/login_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  static LoginController get instance {
    return Get.find<LoginController>();
  }

  bool? isFirst;
  LoginController({this.isFirst});

  var tokenExist = false.obs;
  @override
  void onInit() {
    checkToken();

    super.onInit();
  }

  var isLoad = false.obs;

  Future checkToken() async {
    tokenExist.value = await KeyStore.checkToken();
   // update();

    if (tokenExist.value) {
      SharedPreferences pref = await KeyStore.initPref();
      SendLogin data = SendLogin(
          password: pref.getString(KeyStore.passwordKey)!,
          username: pref.getString(KeyStore.usernameKey)!);
      await runLoginTask(data);
    } else {
      Get.offAll(() => Login());
   }
    update();
  }

  Future runLoginTask(SendLogin data) async {
    isLoad.value = true;
   // update();
    var url = Api.baseUrl + Api.login;
    Map finalData = {
      "username": "${data.username}",
      "password": "${data.password}",
    };

    try {
      http.Response? response = await RequestData.postApi(url, null, finalData);

      var responseData =
          await ApiProcessorController.errorState(response, isFirst);
      if (responseData == null) {
         Get.offAll(
          () => const Login(),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "Dashboard",
          predicate: (route) => false,
          popGesture: true,
          transition: Transition.fadeIn,
        );
        return;
      }
      var jsonData = jsonDecode(response!.body);

      if (jsonData["token"] == false) {
        ApiProcessorController.errorSnack('Failed to log user in');
        isLoad.value = false;
        if (await KeyStore.checkToken == true) {
          KeyStore.storeBool(KeyStore.isLoggedInKey, false);
          KeyStore.remove(
            KeyStore.tokenKey,
          );
          checkToken();
        }
        tokenExist.value = false;

      //  update();
        return;
      } else {
        var save = LoginModel.fromJson(jsonDecode(responseData));
        await KeyStore.storeString(KeyStore.tokenKey, save.token);
        await KeyStore.storeString(KeyStore.usernameKey, data.username);
        await KeyStore.storeString(KeyStore.passwordKey, data.password);
        await KeyStore.storeBool(KeyStore.isLoggedInKey, true);
         Get.put(UserController());
        await UserController.instance.runUserTask(save.token);
        consoleLog("Here is your token ${save.token}");
        tokenExist.value = true;
      }
    } catch (e) {
      consoleLog(e.toString());
    }

    isLoad.value = false;
    update();
  }

  Future resetTokenValue(bool isVal) async {
    tokenExist.value = isVal;
    update();
  }
}
