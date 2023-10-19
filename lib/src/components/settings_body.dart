import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../app/profile/about_app.dart';
import '../../app/profile/change_passord.dart';
import '../providers/constants.dart';

class SettingsBody extends StatefulWidget {
  const SettingsBody({Key? key}) : super(key: key);

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  //===================================== INITIAL STATE AND DISPOSE =========================================\\
  @override
  void initState() {
    super.initState();

    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

//=============================================== ALL VARIABLES ======================================================\\
  late bool _loadingScreen;

//=============================================== FUNCTIONS ======================================================\\
  final _scrollController = ScrollController();

  //==================================================== Navigation ===========================================================\\

  // toNotificationsPage() => Get.to(
  //       () => const NotificationPage(),
  //       routeName: 'NotificationsPage',
  //       duration: const Duration(milliseconds: 300),
  //       fullscreenDialog: true,
  //       curve: Curves.easeIn,
  //       preventDuplicates: true,
  //       popGesture: true,
  //       transition: Transition.rightToLeft,
  //     );

  void _toChangePassword() async {
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
      maintainBottomViewPadding: true,
      child: Scrollbar(
        controller: _scrollController,
        child: _loadingScreen
            ? Center(child: CircularProgressIndicator(color: kAccentColor))
            : ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                physics: const BouncingScrollPhysics(),
                children: [
                  InkWell(
                    onTap: _toChangePassword,
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
