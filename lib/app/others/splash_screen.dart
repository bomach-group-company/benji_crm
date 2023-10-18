import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/login_controller.dart';
import '../../src/providers/constants.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final val = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GetBuilder<LoginController>(
        init: LoginController(isFirst: true),
        builder: (controller) {
          return Container(
            color: kPrimaryColor,
            height: size.height,
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo/benji_full_logo.png",
                  height: 50,
                  width: 50,
                ),
                kSizedBox,
                CircularProgressIndicator(color: kAccentColor),
              ],
            ),
          );
        });
  }
}
