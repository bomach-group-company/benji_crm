import 'dart:convert';
import 'package:benji_aggregator/app/screens/login.dart';
import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/model/login_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/pref.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  static LoginController get instance {
    return Get.find<LoginController>();
  }

  var tokenExist = false.obs;
  @override
  void onInit() {
    checkToken();

    super.onInit();
  }

  var isLoad = false.obs;

  Future checkToken() async {
    tokenExist.value = await KeyStore.checkToken();
    update();

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
    update();
    var url = Api.baseUrl + Api.login;
    Map finalData = {
      "username": "${data.username}",
      "password": "${data.password}",
    };

    try {
      http.Response? response = await RequestData.postApi(url, null, finalData);
      var responseData = await ApiProcessorController.errorState(response);
      var save = LoginModel.fromJson(jsonDecode(responseData));
      await KeyStore.storeString(KeyStore.tokenKey, save.token);
      await KeyStore.storeString(KeyStore.usernameKey, data.username);
      await KeyStore.storeString(KeyStore.passwordKey, data.password);
      await KeyStore.storeBool(KeyStore.isLoggedInKey, true);
      await UserController.instance.runUserTask(save.token);
      consoleLog("Here is your token ${save.token}");
    } catch (e) {
      consoleLog(e.toString());
    }

    isLoad.value = false;
    update();
  }
}
