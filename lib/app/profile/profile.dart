import 'dart:async';

import 'package:benji_aggregator/app/withdrawal/withdrawal_history.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/order_controller.dart';
import '../../controller/user_controller.dart';
import '../../src/components/section/my_liquid_refresh.dart';
import '../../src/components/section/profile_first_half.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../auth/login.dart';
import '../packages/packages.dart';
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
  }

  @override
  void dispose() {
    handleRefresh().ignore();
    super.dispose();
  }

//=============================================== ALL VARIABLES ======================================================\\
  final totalNumOfOrders = OrderController.instance.orderList.toList();

//=============================================== ALL BOOL VALUES ======================================================\\
  bool loadingScreen = false;
//=============================================== FUNCTIONS ======================================================\\

//===================== Handle refresh ==========================\\

  Future<void> handleRefresh() async {
    setState(() {
      loadingScreen = true;
    });

    UserController.instance.getUser();

    setState(() {
      loadingScreen = false;
    });
  }

//=============================================== Navigation ======================================================\\
  void toPersonalInfo() => Get.to(
        () => const PersonalInfo(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "PersonalInfo",
        preventDuplicates: true,
        popGesture: false,
        transition: Transition.rightToLeft,
      );
  void toSettings() => Get.to(
        () => const Settings(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Settings",
        preventDuplicates: true,
        popGesture: false,
        transition: Transition.rightToLeft,
      );
  toPackages() {
    Get.to(
      () => const Packages(),
      routeName: 'Packages',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  void toWithdrawalHistory() => Get.to(
        () => const WithdrawalHistoryPage(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "WithdrawalHistoryPage",
        preventDuplicates: true,
        popGesture: false,
        transition: Transition.rightToLeft,
      );
  void logOut() async {
    await UserController.instance.deleteUser();
    await Get.offAll(
      () => const Login(),
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      routeName: "Login",
      predicate: (routes) => false,
      popGesture: false,
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MyLiquidRefresh(
      onRefresh: handleRefresh,
      child: Scaffold(
        appBar: AppBar(backgroundColor: kAccentColor, elevation: 0.0),
        body: SafeArea(
          child: GetBuilder<UserController>(
            builder: (controller) {
              return ListView(
                scrollDirection: Axis.vertical,
                children: [
                  const ProfileFirstHalf(),
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
                            onTap: toPersonalInfo,
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
                            onTap: toPackages,
                            leading: FaIcon(
                              FontAwesomeIcons.bicycle,
                              color: kAccentColor,
                            ),
                            title: const Text(
                              'Package delivery',
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing:
                                const FaIcon(FontAwesomeIcons.chevronRight),
                          ),
                          ListTile(
                            onTap: toSettings,
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
                          ListTile(
                            onTap: toWithdrawalHistory,
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
                        onTap: logOut,
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
