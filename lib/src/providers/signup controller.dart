// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../services/repos/authentication_repo.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  //TextFormField Controllers
  final userFirstNameEC = TextEditingController();
  final userLastNameEC = TextEditingController();
  final userEmailEC = TextEditingController();
  final userPhoneNumberEC = TextEditingController();
  final userPasswordEC = TextEditingController();

  void registerUser(String userEmailEC, String userPasswordEC) {
    AuthenticationRepo.instance
        .createUserWithEmailAndPassword(userEmailEC, userPasswordEC);
  }
}
