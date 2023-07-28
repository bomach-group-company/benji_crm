// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../app/profile/profile.dart';
import '../../theme/colors.dart';
import '../providers/constants.dart';
import '../providers/custom show search.dart';
import 'dashboard appBar aggregator.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(80);
  const DashboardAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ),
                );
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: const ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/profile/avatar-image.jpg"),
                    fit: BoxFit.cover,
                  ),
                  shape: OvalBorder(),
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
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            );
          },
          icon: const Icon(
            Icons.search_rounded,
            color: kGreyColor1,
            size: 30,
          ),
        ),
        Stack(
          children: [
            IconButton(
              iconSize: 20,
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const Notifications(),
                //   ),
                // );
              },
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
                    "10+",
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
