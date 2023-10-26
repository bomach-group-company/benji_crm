// ignore_for_file: empty_catches

import 'package:benji_aggregator/app/auth_screens/login.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/overview/overview.dart';

class AuthController extends GetxController {
  static AuthController get instance {
    return Get.find<AuthController>();
  }

  @override
  void onInit() {
    checkAuth();
    super.onInit();
  }

  Future checkAuth() async {
    if (await isAuthorized()) {
      Get.offAll(
        () => OverView(),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "OverView",
        predicate: (route) => true,
        popGesture: true,
        transition: Transition.cupertinoDialog,
      );
    } else {
      Get.offAll(() => const Login());
    }
  }
}
