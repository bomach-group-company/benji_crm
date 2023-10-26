import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../controller/login_controller.dart';
import '../../controller/user_controller.dart';
import '../../src/providers/constants.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final val = Get.put(LoginController());
  final usr = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            body: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(kDefaultPadding),
              children: [
                SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.height / 4,
                        width: size.width / 2,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/splash_screen/frame_1.png",
                            ),
                          ),
                        ),
                      ),
                      SpinKitThreeInOut(
                        color: kSecondaryColor,
                        size: 20,
                      ),
                      kSizedBox,
                      Text(
                        "CRM",
                        style: TextStyle(
                          color: kAccentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
