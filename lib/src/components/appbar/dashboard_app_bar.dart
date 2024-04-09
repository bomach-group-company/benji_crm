// ignore_for_file: file_names

import 'package:benji_aggregator/app/others/notifications.dart';
import 'package:benji_aggregator/app/profile/personal_info.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../services/api_url.dart';
import '../../../theme/colors.dart';
import '../../providers/constants.dart';
import 'dashboard_app_bar_aggregator.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int numberOfNotifications;
  final String? image;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const DashboardAppBar({
    super.key,
    required this.numberOfNotifications,
    this.image,
  });
//======================================== ALL VARIABLES ==============================================\\

//======================================== FUNCTIONS ==============================================\\
  void toProfilePage() => Get.to(
        () => const PersonalInfo(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "PersonalInfo",
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
    var media = MediaQuery.of(context).size;
    // void showSearchField() {
    //   showSearch(context: context, delegate: CustomSearchDelegate());
    // }

    return AppBar(
      backgroundColor: kPrimaryColor,
      automaticallyImplyLeading: false,
      titleSpacing:
          deviceType(media.width) > 2 ? kDefaultPadding : kDefaultPadding / 2,
      elevation: 0,
      title: GetBuilder<UserController>(
          init: UserController(),
          builder: (controller) {
            return Row(
              children: [
                InkWell(
                  onTap: toProfilePage,
                  borderRadius: BorderRadius.circular(100),
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: ShapeDecoration(
                        color: kLightGreyColor,
                        shape: const CircleBorder(),
                        image: image!.isEmpty
                            ? const DecorationImage(
                                image: NetworkImage(
                                  "https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg",
                                ),
                              )
                            : DecorationImage(
                                image: NetworkImage(baseImage + image!),
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                              ),
                      ),
                      // padding: const EdgeInsets.all(5),
                      // child: Center(
                      //   child: MyImage(
                      //     url: image,
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                    ),
                  ),
                ),
                AppBarAggregator(
                  title: "Welcome,",
                  aggregatorName:
                      "${controller.user.value.firstName} ${controller.user.value.lastName}",
                ),
              ],
            );
          }),
      actions: [
        // IconButton(
        //     onPressed: showSearchField,
        //     icon: FaIcon(
        //       FontAwesomeIcons.magnifyingGlass,
        //       color: kGreyColor,
        //     ),
        // ),
        Stack(
          children: [
            IconButton(
              iconSize: 20,
              onPressed: toNotificationsPage,
              icon: FaIcon(
                FontAwesomeIcons.bell,
                color: kAccentColor,
                size: 30,
              ),
            ),
            // Positioned(
            //   top: 10,
            //   right: 5,
            //   child: Container(
            //     height: 20,
            //     width: 20,
            //     decoration: ShapeDecoration(
            //       color: kAccentColor,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(100),
            //       ),
            //     ),
            //     child: Center(
            //       child: Text(
            //         formatNumber(numberOfNotifications),
            //         textAlign: TextAlign.center,
            //         style: const TextStyle(
            //           fontSize: 9,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
        kWidthSizedBox
      ],
    );
  }
}
