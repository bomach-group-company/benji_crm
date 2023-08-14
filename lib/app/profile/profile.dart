import 'package:benji_aggregator/app/others/withdrawal/withdraw_history.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/profile_first_half.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../screens/login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
//=============================================== ALL VARIABLES ======================================================\\

//=============================================== FUNCTIONS ======================================================\\

//=============================================== Navigation ======================================================\\
  void _logOut() => Get.offAll(
        () => Login(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Logout",
        predicate: (routes) => false,
        popGesture: false,
        transition: Transition.rightToLeft,
      );
  void _toWithdrawalHistory() => Get.to(
        () => WithdrawHistoryPage(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Withdrawal history",
        preventDuplicates: true,
        popGesture: false,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAccentColor,
        title: const Padding(
          padding: EdgeInsets.only(
            left: kDefaultPadding,
          ),
          child: Text(
            'My Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            const ProfileFirstHalf(availableBalance: "100,000.00"),
            Padding(
              padding: const EdgeInsets.only(
                top: kDefaultPadding,
                left: kDefaultPadding,
                right: kDefaultPadding,
                bottom: kDefaultPadding / 1.5,
              ),
              child: Container(
                width: mediaWidth,
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
                      onTap: () {},
                      mouseCursor: SystemMouseCursors.click,
                      leading: Icon(
                        Icons.person_outlined,
                        color: kAccentColor,
                      ),
                      title: const Text(
                        'Personal Info',
                        style: TextStyle(
                          color: Color(
                            0xFF333333,
                          ),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                    ListTile(
                      onTap: () {},
                      mouseCursor: SystemMouseCursors.click,
                      leading: Icon(
                        Icons.settings_rounded,
                        color: kAccentColor,
                      ),
                      title: const Text(
                        'Settings',
                        style: TextStyle(
                          color: Color(
                            0xFF333333,
                          ),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
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
                padding: const EdgeInsets.all(
                  kDefaultPadding / 2,
                ),
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
                      mouseCursor: SystemMouseCursors.click,
                      leading: Icon(
                        Icons.payment_rounded,
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
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                    ListTile(
                      onTap: () {},
                      mouseCursor: SystemMouseCursors.click,
                      leading: Icon(
                        Icons.receipt_long_outlined,
                        color: kAccentColor,
                      ),
                      title: const Text(
                        'Number of Orders',
                        style: TextStyle(
                          color: Color(
                            0xFF333333,
                          ),
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
                width: 327,
                height: 78,
                padding: const EdgeInsets.all(
                  kDefaultPadding / 2,
                ),
                decoration: ShapeDecoration(
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
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
                  leading: Icon(
                    Icons.logout_rounded,
                    color: kAccentColor,
                  ),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(
                        0xFF333333,
                      ),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
