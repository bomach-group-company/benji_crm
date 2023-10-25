import 'dart:async';

import 'package:benji_aggregator/app/others/withdrawal/withdrawal_history.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';
import '../../src/components/my_liquid_refresh.dart';
import '../../src/components/profile_first_half.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../auth_screens/login.dart';
import 'personal_info.dart';
import 'settings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //===================================== INITIAL STATE AND DISPOSE =========================================\\
  @override
  void initState() {
    super.initState();
    _loadingScreen = true;
    _timer = Timer(const Duration(milliseconds: 1000), () {
      setState(() => _loadingScreen = false);
    });
  }

  @override
  void dispose() {
    _handleRefresh().ignore();
    _timer.cancel();
    super.dispose();
  }

//=============================================== ALL VARIABLES ======================================================\\
  late Timer _timer;

//=============================================== ALL BOOL VALUES ======================================================\\
  late bool _loadingScreen;

//=============================================== FUNCTIONS ======================================================\\

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() => _loadingScreen = true);
    _timer = Timer(const Duration(milliseconds: 1000), () {
      setState(() => _loadingScreen = false);
    });
  }

//=============================================== Navigation ======================================================\\
  void _toPersonalInfo() => Get.to(
        () => const PersonalInfo(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "PersonalInfo",
        preventDuplicates: true,
        popGesture: false,
        transition: Transition.rightToLeft,
      );
  void _toSettings() => Get.to(
        () => const Settings(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Settings",
        preventDuplicates: true,
        popGesture: false,
        transition: Transition.rightToLeft,
      );
  void _toWithdrawalHistory() => Get.to(
        () => const WithdrawalHistoryPage(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "WithdrawalHistoryPage",
        preventDuplicates: true,
        popGesture: false,
        transition: Transition.rightToLeft,
      );
  void _logOut() => Get.offAll(
        () => const Login(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Login",
        predicate: (routes) => false,
        popGesture: false,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MyLiquidRefresh(
      onRefresh: _handleRefresh,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kAccentColor,
          elevation: 0.0,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: GetBuilder<UserController>(
            builder: (controller) {
              return _loadingScreen
                  ? Center(
                      child: CircularProgressIndicator(color: kAccentColor),
                    )
                  : ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        ProfileFirstHalf(
                            availableBalance: doubleFormattedText(1000000)),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: kDefaultPadding,
                            left: kDefaultPadding,
                            right: kDefaultPadding,
                            bottom: kDefaultPadding / 1.5,
                          ),
                          child: Container(
                            width: media.width,
                            padding: const EdgeInsets.all(kDefaultPadding / 2),
                            decoration: ShapeDecoration(
                              color: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
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
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: _toPersonalInfo,
                                  enableFeedback: true,
                                  mouseCursor: SystemMouseCursors.click,
                                  leading: FaIcon(
                                    FontAwesomeIcons.solidUser,
                                    color: kAccentColor,
                                  ),
                                  title: const Text(
                                    'Personal Info',
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  trailing: const FaIcon(
                                    FontAwesomeIcons.chevronRight,
                                  ),
                                ),
                                ListTile(
                                  onTap: _toSettings,
                                  enableFeedback: true,
                                  mouseCursor: SystemMouseCursors.click,
                                  leading: FaIcon(
                                    FontAwesomeIcons.gear,
                                    color: kAccentColor,
                                  ),
                                  title: const Text(
                                    'Settings',
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  trailing: const FaIcon(
                                    FontAwesomeIcons.chevronRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: kDefaultPadding,
                            right: kDefaultPadding,
                            bottom: kDefaultPadding / 1.5,
                          ),
                          child: Container(
                            width: 327,
                            height: 141,
                            padding: const EdgeInsets.all(kDefaultPadding / 2),
                            decoration: ShapeDecoration(
                              color: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x0F000000),
                                  blurRadius: 24,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: _toWithdrawalHistory,
                                  enableFeedback: true,
                                  mouseCursor: SystemMouseCursors.click,
                                  leading: FaIcon(
                                    FontAwesomeIcons.solidCreditCard,
                                    color: kAccentColor,
                                  ),
                                  title: const Text(
                                    'Withdrawal History',
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  trailing: const FaIcon(
                                    FontAwesomeIcons.chevronRight,
                                  ),
                                ),
                                ListTile(
                                  enableFeedback: true,
                                  mouseCursor: SystemMouseCursors.click,
                                  leading: FaIcon(
                                    FontAwesomeIcons.receipt,
                                    color: kAccentColor,
                                  ),
                                  title: const Text(
                                    'Number of Orders',
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  trailing: const Text(
                                    '29K',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xFF9B9BA5),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: kDefaultPadding,
                            right: kDefaultPadding,
                            bottom: kDefaultPadding / 1.5,
                          ),
                          child: Container(
                            width: media.width,
                            padding: const EdgeInsets.all(kDefaultPadding / 2),
                            decoration: ShapeDecoration(
                              color: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x0F000000),
                                  blurRadius: 24,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: ListTile(
                              mouseCursor: SystemMouseCursors.click,
                              onTap: _logOut,
                              enableFeedback: true,
                              leading: FaIcon(
                                FontAwesomeIcons.rightFromBracket,
                                color: kAccentColor,
                              ),
                              title: const Text(
                                'Log Out',
                                style: TextStyle(
                                  color: kTextBlackColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
