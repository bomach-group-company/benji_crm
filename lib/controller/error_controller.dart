// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

import '../theme/colors.dart';

class ApiProcessorController extends GetxController {
  static Future<dynamic> errorState(data, [bool dontShowError = true]) async {
    try {
      if (data == null) {
        return;
      } else if (data.statusCode == 200) {
        return data.body;
      } else {
        if (dontShowError != true) {
          errorSnack("Something went wrong");
        }

        return;
      }
    } on SocketException {
      errorSnack("Check your internet and try again");
      return;
    } catch (e) {
      errorSnack(e);
      return;
    }
  }

  static void errorSnack(msg) {
    Get.showSnackbar(GetSnackBar(
      title: "ERROR",
      message: "$msg",
      backgroundColor: kAccentColor,
      duration: const Duration(seconds: 2),
    ));
  }

  static void successSnack(msg) {
    Get.showSnackbar(GetSnackBar(
      title: "Successful",
      message: "$msg",
      backgroundColor: kSuccessColor,
      duration: const Duration(seconds: 2),
    ));
  }
}
