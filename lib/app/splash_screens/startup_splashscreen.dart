// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../auth_screens/login.dart';

class StartupSplashscreen extends StatefulWidget {
  const StartupSplashscreen({super.key});

  @override
  State<StartupSplashscreen> createState() => _StartupSplashscreenState();
}

class _StartupSplashscreenState extends State<StartupSplashscreen> {
//=============================================== INITIAL STATE AND DISPOSE ===========================================================\\

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
//==============================================================================================================\\

//=============================================== ALL VARIABLES ===============================================================\\

//=============================================== FUNCTIONS ===============================================================\\

  @override
  Widget build(BuildContext context) {
    double mediaHeight = MediaQuery.of(context).size.height;
    double mediaWidth = MediaQuery.of(context).size.width;

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(
        () => const Login(),
        duration: const Duration(seconds: 3),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Login",
        predicate: (route) => false,
        popGesture: true,
        transition: Transition.fadeIn,
      );
    });

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: ListView(
        children: [
          SizedBox(
            height: mediaHeight,
            width: mediaWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(seconds: 6),
                  curve: Curves.bounceIn,
                  transform: Matrix4.rotationY(270),
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/splash_screen/frame_1.png",
                      ),
                    ),
                  ),
                ),
                kSizedBox,
                const Center(
                  child: Text(
                    "Aggregator App",
                    style: TextStyle(
                      color: kTextBlackColor,
                    ),
                  ),
                ),
                kSizedBox,
                SpinKitThreeInOut(
                  color: kSecondaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
