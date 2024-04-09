import 'package:benji_aggregator/app/profile/about_app.dart';
import 'package:benji_aggregator/app/profile/change_password.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

class SettingsBody extends StatefulWidget {
  const SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  //===================================== INITIAL STATE AND DISPOSE =========================================\\
  @override
  void initState() {
    super.initState();
  }

//=============================================== ALL VARIABLES ======================================================\\

//=============================================== FUNCTIONS ======================================================\\
  final scrollController = ScrollController();

  //==================================================== Navigation ===========================================================\\

  // toChangePhoneNumber() => Get.to(
  //       () => const ChangePhoneNumber(),
  //       routeName: 'ChangePhoneNumber',
  //       duration: const Duration(milliseconds: 300),
  //       fullscreenDialog: true,
  //       curve: Curves.easeIn,
  //       preventDuplicates: true,
  //       popGesture: true,
  //       transition: Transition.rightToLeft,
  //     );

  void toChangePassword() async {
    await Get.to(
      () => const ChangePassword(),
      routeName: 'ChangePassword',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    setState(() {});
  }

  void _toAboutApp() => Get.to(
        () => const AboutApp(),
        routeName: 'AboutApp',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SafeArea(
      child: Scrollbar(
        controller: scrollController,
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(10),
          physics: const BouncingScrollPhysics(),
          children: [
            // InkWell(
            //   onTap: toChangePhoneNumber,
            //   child: Container(
            //     width: media.width,
            //     decoration: ShapeDecoration(
            //       color: kPrimaryColor,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       shadows: const [
            //         BoxShadow(
            //           color: Color(0x0F000000),
            //           blurRadius: 24,
            //           offset: Offset(0, 4),
            //           spreadRadius: 0,
            //         ),
            //       ],
            //     ),
            //     child: ListTile(
            //       enableFeedback: true,
            //       leading: FaIcon(
            //         FontAwesomeIcons.phone,
            //         color: kAccentColor,
            //       ),
            //       title: const Text(
            //         "Change phone number",
            //         style: TextStyle(
            //           color: kTextBlackColor,
            //           fontSize: 12,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //       trailing: const Icon(
            //         FontAwesomeIcons.chevronRight,
            //         size: 16,
            //         color: kTextBlackColor,
            //       ),
            //     ),
            //   ),
            // ),
            // kHalfSizedBox,
            InkWell(
              onTap: toChangePassword,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: media.width,
                decoration: ShapeDecoration(
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 24,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ListTile(
                  enableFeedback: true,
                  leading: FaIcon(
                    FontAwesomeIcons.solidPenToSquare,
                    color: kAccentColor,
                  ),
                  title: const Text(
                    'Change Password',
                    style: TextStyle(
                      color: kTextBlackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 16,
                    color: kTextBlackColor,
                  ),
                ),
              ),
            ),
            kHalfSizedBox,
            InkWell(
              onTap: _toAboutApp,
              child: Container(
                width: media.width,
                decoration: ShapeDecoration(
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 24,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ListTile(
                  enableFeedback: true,
                  leading: FaIcon(
                    FontAwesomeIcons.circleInfo,
                    color: kAccentColor,
                  ),
                  title: const Text(
                    "About the app",
                    style: TextStyle(
                      color: kTextBlackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: const Icon(
                    FontAwesomeIcons.chevronRight,
                    size: 16,
                    color: kTextBlackColor,
                  ),
                ),
              ),
            ),
            kHalfSizedBox,
          ],
        ),
      ),
    );
  }
}
