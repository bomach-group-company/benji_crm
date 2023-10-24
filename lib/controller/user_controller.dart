// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/login_controller.dart';
import 'package:benji_aggregator/model/user_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../app/auth_screens/login.dart';
import '../app/overview/overview.dart';
import '../services/pref.dart';

class UserController extends GetxController {
  static UserController get instance {
    return Get.find<UserController>();
  }

  bool? isFirst;
  UserController({this.isFirst});

  var isLoading = false.obs;
  var user = UserModel.fromJson(null).obs;
  int uuid = UserController.instance.user.value.id;

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

//===================== Update Personal Profile ==================\\

  Future<bool> updateProfile(
      {String? userName,
      phoneNumber,
      firstName,
      lastName,
      address,
      bool isCurrent = true}) async {
    late String token;
    await KeyStore.getToken().then((element) {
      token = element!;
    });
    var url = "${Api.baseUrl}/api/v1/agents/changeAgent/{$uuid}";
    consoleLog(url);

    Map body = {
      "username": userName ?? "",
      "phone": phoneNumber ?? "",
      "first_name": firstName ?? "",
      "last_name": lastName ?? "",
      "address": address ?? "",
    };
    consoleLog("body: ${body.toString()}");
    try {
      var response = await http.put(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: header,
          HttpHeaders.authorizationHeader: "Bearer $token",
          "Content-Type": header,
        },
        body: body,
      );

      //Print the response in the console:
      var jsonData = jsonDecode(response.body);
      consoleLog("jsonData: $jsonData");

      if (response.statusCode == 200) {
        ApiProcessorController.successSnack(
            "Your changes have been saved successfully.");
        Get.back();
      } else {
        consoleLog(response.body);
        ApiProcessorController.errorSnack(
            "Something went wrong, please try again.");
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet.");
    } catch (e) {
      consoleLog(e.toString());
      ApiProcessorController.errorSnack(
          "An unexpected error occurred. \nERROR: $e \nPlease contact admin.");
    }

    return false;
  }

//===================== Change Password ==================\\

  Future<void> changePassword(
      {String? userName,
      oldPassword,
      newPassword,
      confirmPassword,
      bool isCurrent = true}) async {
    late String token;

    var url = "${Api.baseUrl}${Api.changePassword}";
    consoleLog(url);
    await KeyStore.getToken().then((element) {
      token = element!;
    });
    consoleLog(token);

    Map body = {
      'old_password': oldPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };
    consoleLog("body: ${body.toString()}");

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: header,
          "Content-Type": content,
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
        body: body,
      );

      //Print the response in the console:
      var jsonData = jsonDecode(response.body);
      consoleLog("jsonData: $jsonData");

      if (response.statusCode == 200) {
        ApiProcessorController.successSnack("Password Changed Successfully");
        Get.offAll(
          () => const Login(),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "Login",
          predicate: (route) => false,
          popGesture: true,
          transition: Transition.rightToLeft,
        );
        return;
      } else {
        consoleLog(response.body);
        ApiProcessorController.errorSnack("Invalid, please try again.");
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet.");
      return;
    } catch (e) {
      consoleLog(e.toString());
      ApiProcessorController.errorSnack(
          "An unexpected error occurred. \nERROR: $e \nPlease try again.");
    }
  }
}
