// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../screens/signup.dart';

class StartupSplashscreen extends StatefulWidget {
  static String routeName = "Startup Splash Screen";
  const StartupSplashscreen({super.key});

  @override
  State<StartupSplashscreen> createState() => _StartupSplashscreenState();
}

class _StartupSplashscreenState extends State<StartupSplashscreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignUp()),
          (route) => false);
    });
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/splash screen/frame-1.png",
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
