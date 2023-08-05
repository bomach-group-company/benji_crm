import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../dashboard/dashboard.dart';
import '../profile/profile.dart';
import '../riders/riders.dart';
import '../vendors/vendors.dart';

class OverView extends StatefulWidget {
  const OverView({super.key});

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
      // IndexedStack(
      //   index: _currentIndex,
      //   children: _pages,
      // ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
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
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.grid_view,
                  ),
                  label: "Dashboard",
                  activeIcon: Icon(
                    Icons.grid_view_rounded,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.business_rounded,
                  ),
                  label: "Vendors",
                  activeIcon: Icon(
                    Icons.business_rounded,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.delivery_dining_rounded,
                  ),
                  label: "Riders",
                  activeIcon: Icon(
                    Icons.delivery_dining_rounded,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_2_outlined,
                  ),
                  label: "Profile",
                  activeIcon: Icon(
                    Icons.person_2_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
