// ignore_for_file: empty_catches

import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/app/auth/login.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/overview/overview.dart';
import 'api_processor_controller.dart';
import 'user_controller.dart';

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
    try {
      if (await isAuthorized()) {
        Get.offAll(
          () => const OverView(),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "OverView",
          predicate: (route) => false,
          popGesture: false,
          transition: Transition.cupertinoDialog,
        );
      } else {
        Get.offAll(
          () => const Login(),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "Login",
          predicate: (route) => false,
          popGesture: false,
          transition: Transition.cupertinoDialog,
        );
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
      checkAuth;
    } catch (e) {
      log(e.toString());
      ApiProcessorController.errorSnack("Error: $e");
    }
  }

  Future checkIfAuthorized() async {
    try {
      if (await isAuthorized() == true) {
        log("User is authorized");
        return;
      } else {
        UserController.instance.deleteUser();
        ApiProcessorController.errorSnack(
          "User is not authorized, Please log in",
        );
        log("User is not authorized");
        Get.offAll(
          () => const Login(),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "Login",
          predicate: (route) => false,
          popGesture: false,
          transition: Transition.cupertinoDialog,
        );
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      log(e.toString());
    }
  }
}
