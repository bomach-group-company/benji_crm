// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:benji_aggregator/app/auth_screens/login.dart';
import 'package:benji_aggregator/main.dart';
import 'package:benji_aggregator/model/user_model.dart';
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
    getUserSync();
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

  Future<void> saveUser(String user, String token) async {
    Map data = jsonDecode(user);
    data['token'] = token;
    await prefs.setString('user', jsonEncode(data));
  }

  void getUserSync() {
    String? userData = prefs.getString('user');
    if (userData == null) {
      user.value = UserModel.fromJson(null);
    } else {
      user.value = userModelFromJson(userData);
    }
  }

  Future<bool> deleteUser() async {
    return await prefs.remove('user');
  }
}
