import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/notification_controller.dart';
import '../../controller/order_controller.dart';
import '../../controller/rider_controller.dart';
import '../../controller/user_controller.dart';
import '../../controller/vendor_controller.dart';
import '../../theme/colors.dart';
import '../dashboard/dashboard.dart';
import '../profile/profile.dart';
import '../riders/riders.dart';
import '../vendors/vendors.dart';

class OverView extends StatefulWidget {

 var user=    Get.put(UserController());
 var vendor = Get.put(VendorController());
 var notiication =  Get.put(NotificationController());
 var ride =  Get.put(RiderController());
  var order  = Get.put(OrderController());

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
                BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view),
                  label: "Dashboard",
                  tooltip: "Dashboard",
                  activeIcon: Icon(Icons.grid_view_rounded),
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
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined),
                  label: "Profile",
                  tooltip: "Profile",
                  activeIcon: Icon(Icons.person_2_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
