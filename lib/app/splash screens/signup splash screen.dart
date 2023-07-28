// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../overview/overview.dart';

class SignUpSplashScreen extends StatelessWidget {
  const SignUpSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(
        () => const OverView(),
        duration: const Duration(seconds: 3),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Dashboard",
        predicate: (route) => false,
        popGesture: true,
        transition: Transition.circularReveal,
      );
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Center(
              child: Container(
                width: 400,
                height: 500,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/animations/splash screen/registration successful.gif",
                    ),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
