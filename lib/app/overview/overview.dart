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
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Dashboard(),
    Vendors(),
    Riders(),
    Profile(),
  ];

  void _onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTappedBar,
        elevation: 20.0,
        selectedItemColor: kAccentColor,
        selectedIconTheme: IconThemeData(
          color: kAccentColor,
        ),
        showSelectedLabels: true,
        unselectedItemColor: const Color(
          0xFFBDBDBD,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Color(
            0xFFBDBDBD,
          ),
        ),
        showUnselectedLabels: true,
        enableFeedback: true,
        type: BottomNavigationBarType.fixed,
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
    );
  }
}
