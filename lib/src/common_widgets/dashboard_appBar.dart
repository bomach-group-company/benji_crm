// ignore_for_file: file_names

import 'package:benji_aggregator/app/others/notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../app/profile/profile.dart';
import '../../theme/colors.dart';
import '../providers/constants.dart';
import '../providers/custom show search.dart';
import 'dashboard_appBar_aggregator.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(80);
  const DashboardAppBar({
    super.key,
  });
//======================================== ALL VARIABLES ==============================================\\

//======================================== FUNCTIONS ==============================================\\
  void toProfilePage() => Get.to(
        () => const Profile(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Profile",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void toNotificationsPage() => Get.to(
        () => const Notifications(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Notifications",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );
  @override
  Widget build(BuildContext context) {
    void showSearchField() {
      showSearch(context: context, delegate: CustomSearchDelegate());
    }

    return AppBar(
      backgroundColor: kPrimaryColor,
      automaticallyImplyLeading: false,
      titleSpacing: kDefaultPadding / 2,
      elevation: 0.0,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding / 2,
            ),
            child: InkWell(
              onTap: () {
                toProfilePage();
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: ShapeDecoration(
                  color: kPageSkeletonColor,
                  image: const DecorationImage(
                    image: AssetImage("assets/images/profile/avatar-image.jpg"),
                    fit: BoxFit.cover,
                  ),
                  shape: const OvalBorder(),
                ),
              ),
            ),
          ),
          const AppBarAggregator(
            title: "Welcome,",
            aggregatorName: "Mishaal Erickson",
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: showSearchField,
            icon: Icon(
              Icons.search,
              color: kGreyColor,
            )),
        Stack(
          children: [
            IconButton(
              iconSize: 20,
              onPressed: toNotificationsPage,
              icon: Icon(
                Icons.notifications_outlined,
                color: kAccentColor,
                size: 30,
              ),
            ),
            Positioned(
              top: 10,
              right: 12,
              child: Container(
                height: 15,
                width: 15,
                decoration: ShapeDecoration(
                  color: kAccentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "4",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        kWidthSizedBox
      ],
    );
  }
}
