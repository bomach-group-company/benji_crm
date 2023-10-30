// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:benji_aggregator/app/auth_screens/login.dart';
import 'package:benji_aggregator/main.dart';
import 'package:benji_aggregator/model/user_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/overview/overview.dart';

class UserController extends GetxController {
  static UserController get instance {
    return Get.find<UserController>();
  }

  var isLoading = false.obs;
  var user = UserModel.fromJson(null).obs;

  @override
  void onInit() {
    setUserSync();
    super.onInit();
  }

  Future checkAuth() async {
    if (await isAuthorized()) {
      Get.offAll(
        () => OverView(),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "OverView",
        predicate: (route) => false,
        popGesture: false,
        transition: Transition.cupertinoDialog,
      );
    } else {
      Get.offAll(() => const Login());
    }
  }

  Future<void> saveUser(String user, String token, String otherUserData) async {
    Map data = jsonDecode(user);
    Map otherData = jsonDecode(otherUserData);
    data['token'] = token;
    data['username'] = otherData['username'];
    data['email'] = otherData['email'];
    data['code'] = otherData['code'];

    consoleLog(data.toString());

    await prefs.setString('user', jsonEncode(data));
    setUserSync();
  }

  void setUserSync() {
    String? userData = prefs.getString('user');
    print('the data userData $userData');
    if (userData == null) {
      user.value = UserModel.fromJson(null);
    } else {
      user.value = userModelFromJson(userData);
    }
    update();
  }

  Future<bool> deleteUser() async {
    return await prefs.remove('user');
  }
}
