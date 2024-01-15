import 'package:benji_aggregator/controller/auth_controller.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../src/providers/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(
      init: AuthController(),
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
      },
    );
  }
}
