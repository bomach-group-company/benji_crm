import 'package:benji_aggregator/controller/order_controller.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/notification_controller.dart';
import '../../controller/profile_controller.dart';
import '../../controller/rider_controller.dart';
import '../../controller/user_controller.dart';
import '../../theme/colors.dart';
import '../dashboard/dashboard.dart';
import '../profile/profile.dart';
import '../riders/riders.dart';
import '../vendors/vendors.dart';

class OverView extends StatefulWidget {
  final user = Get.put(UserController());
  final userProfile = Get.put(ProfileController());
  final vendor = Get.put(VendorController());
  final notiication = Get.put(NotificationController());
  final ride = Get.put(RiderController());
  final order = Get.put(OrderController());

  OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
//===================================== ALL VARAIBLES =================================================\\

  bool _bottomNavBarIsVisible = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

//===================================== FUNCTIONS =================================================\\

  void showNav() {
    setState(() {
      _bottomNavBarIsVisible = true;
    });
  }

  void hideNav() {
    setState(() {
      _bottomNavBarIsVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //===================================== PAGINATION =================================================\\
    final List<Widget> pages = [
      Dashboard(
        showNavigation: showNav,
        hideNavigation: hideNav,
      ),
      Vendors(
        showNavigation: showNav,
        hideNavigation: hideNav,
        appBarBackgroundColor: kPrimaryColor,
        appTitleColor: kTextBlackColor,
        appBarSearchIconColor: kAccentColor,
      ),
      Riders(
        showNavigation: showNav,
        hideNavigation: hideNav,
        appBarBackgroundColor: kPrimaryColor,
        appTitleColor: kTextBlackColor,
        appBarSearchIconColor: kAccentColor,
      ),
      const Profile(),
    ];

//===================================== FUNCTIONS =================================================\\
    void onTappedBar(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        height: _bottomNavBarIsVisible ? kBottomNavigationBarHeight : 0,
        child: Wrap(
          children: [
            BottomNavigationBar(
              showUnselectedLabels: true,
              enableFeedback: true,
              type: BottomNavigationBarType.fixed,
              mouseCursor: SystemMouseCursors.click,
              currentIndex: _currentIndex,
              onTap: onTappedBar,
              elevation: 20.0,
              selectedItemColor: kAccentColor,
              selectedIconTheme: IconThemeData(
                color: kAccentColor,
              ),
              showSelectedLabels: true,
              unselectedItemColor: const Color(0xFFBDBDBD),
              unselectedIconTheme: const IconThemeData(
                color: Color(0xFFBDBDBD),
              ),
              items: [
                const BottomNavigationBarItem(
                  icon: FaIcon(Icons.grid_view),
                  label: "Dashboard",
                  tooltip: "Dashboard",
                  activeIcon: FaIcon(Icons.grid_view_rounded),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset("assets/icons/vendor-icon.png"),
                  label: "Vendors",
                  tooltip: "Vendors",
                  activeIcon: Image.asset(
                    "assets/icons/vendor-icon.png",
                    color: kAccentColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset("assets/icons/rider-icon.png"),
                  label: "Riders",
                  tooltip: "Riders",
                  activeIcon: Image.asset(
                    "assets/icons/rider-icon.png",
                    color: kAccentColor,
                  ),
                ),
                const BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.user, size: 18),
                  label: "Profile",
                  tooltip: "Profile",
                  activeIcon: FaIcon(FontAwesomeIcons.solidUser, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
