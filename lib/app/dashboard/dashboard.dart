// ignore_for_file:  unused_local_variable

import 'dart:async';

import 'package:benji_aggregator/controller/notification_controller.dart';
import 'package:benji_aggregator/controller/rider_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/main.dart';
import 'package:benji_aggregator/src/components/appbar/dashboard_app_bar.dart';
import 'package:benji_aggregator/src/components/button/my_elevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/components/container/dashboard_container.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../src/utils/constants.dart';
import '../../theme/colors.dart';
import '../overview/overview.dart';
import '../packages/send_package.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

typedef ModalContentBuilder = Widget Function(BuildContext);

class _DashboardState extends State<Dashboard> {
  //===================== Initial State ==========================\\
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await UserController.instance.getUser();
    //   await await VendorController.instance.getMyVendors();
    //   await NotificationController.instance.runTask();
    // });

    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
    handleRefresh().ignore();
  }

//==========================================================================================\\

//=================================== ALL VARIABLES =====================================\\
  final notifications = NotificationController.instance.notification.length;

  bool _isScrollToTopBtnVisible = false;

  bool loadingScreen = false;

//============================================== CONTROLLERS =================================================\\
  final scrollController = ScrollController();

//=================================== FUNCTIONS =====================================\\
//===================== Handle refresh ==========================\\

  Future<void> handleRefresh() async {
    setState(() {
      loadingScreen = true;
    });
    await UserController.instance.getUser();
    await NotificationController.instance.runTask();
    setState(() {
      loadingScreen = false;
    });
  }

//============================= Scroll to Top ======================================//
  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void _scrollListener() {
    //========= Show action button ========//
    if (scrollController.position.pixels >= 100) {
      setState(() => _isScrollToTopBtnVisible = true);
    }
    //========= Hide action button ========//
    else if (scrollController.position.pixels < 100) {
      setState(() => _isScrollToTopBtnVisible = false);
    }
  }

//=================================== Navigation =====================================\\
  void _toSeeMyVendors() => Get.to(
        () => const OverView(currentIndex: 1),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "MyVendors",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _toSeeThirdPartyVendors() => Get.to(
        () => const OverView(currentIndex: 1, vendorSelectedtabbar: 1),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "MyVendors",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );
  void _toSeeAllRiders() => Get.to(
        () => const OverView(currentIndex: 2),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Riders",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  toSendPackage() => Get.to(
        () => const SendPackage(),
        routeName: 'SendPackage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void showMessageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Alert!".toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kAccentColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            "Please update your business(es) info",
            textAlign: TextAlign.center,
            maxLines: 4,
            style: TextStyle(
              color: kTextBlackColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            MyElevatedButton(
              title: "Okay",
              onPressed: () {
                prefs.setBool("updateBusiness", true);
                Get.close(0);
                _toSeeThirdPartyVendors();
              },
            ),
          ],
        );
      },
    );
  }

  void showAppUpdateDialog() {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "UPDATE!".toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kAccentColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            "Please update your app",
            textAlign: TextAlign.center,
            maxLines: 4,
            style: TextStyle(
              color: kTextBlackColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            MyElevatedButton(
              title: "Okay",
              onPressed: () {
                prefs.setBool("updatedApp", true);
                Get.close(0);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

//====================================================================================\\

    return RefreshIndicator(
      onRefresh: handleRefresh,
      color: kAccentColor,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      child: Scaffold(
        appBar: DashboardAppBar(
          numberOfNotifications: notifications,
          image: UserController.instance.user.value.image,
        ),
        floatingActionButton: _isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: scrollToTop,
                mini: deviceType(media.width) > 2 ? false : true,
                backgroundColor: kAccentColor,
                foregroundColor: kPrimaryColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: const FaIcon(
                  FontAwesomeIcons.chevronUp,
                  size: 18,
                ),
              )
            : const SizedBox(),
        body: SafeArea(
          child: Scrollbar(
            child: ListView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(kDefaultPadding),
              children: [
                // const AvailableBalanceCard(),
                loadingScreen
                    ? LinearProgressIndicator(color: kAccentColor)
                    : const SizedBox(),
                kSizedBox,
                GetBuilder<VendorController>(
                  initState: (state) async {
                    await VendorController.instance.getMyVendors();

                    var updatedBusiness =
                        prefs.getBool("updatedBusiness") ?? false;
                    if (updatedBusiness) {
                      showMessageDialog();
                    }
                  },
                  builder: (controller) {
                    return DashboardContainer(
                      onTap: _toSeeMyVendors,
                      number: controller.isLoad.value
                          ? "..."
                          : intFormattedText(controller.allMyVendorList),
                      typeOf: "Vendors",
                      onlineStatus: "",
                    );
                  },
                ),
                kSizedBox,
                GetBuilder<VendorController>(
                  initState: (state) async {
                    await VendorController.instance.getThirdPartyVendors();
                  },
                  builder: (controller) {
                    return DashboardContainer(
                      onTap: _toSeeThirdPartyVendors,
                      number: controller.isLoad.value
                          ? "..."
                          : intFormattedText(
                              controller.allMyThirdPartyVendorList),
                      typeOf: "Third party vendors",
                      onlineStatus: "",
                    );
                  },
                ),
                kSizedBox,
                GetBuilder<RiderController>(initState: (state) async {
                  await RiderController.instance.getRiders();
                }, builder: (controller) {
                  return DashboardContainer(
                    onTap: _toSeeAllRiders,
                    number: controller.isLoad.value
                        ? "..."
                        : intFormattedText(controller.totalRiders.value),
                    typeOf: "Riders",
                    onlineStatus: "",
                  );
                }),
                kSizedBox,
                Container(
                  padding: const EdgeInsets.all(10),
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
                  child: ListTile(
                    onTap: toSendPackage,
                    leading: FaIcon(
                      FontAwesomeIcons.personBiking,
                      color: kAccentColor,
                    ),
                    title: const Text(
                      'Send a Package',
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: FaIcon(
                      FontAwesomeIcons.chevronRight,
                      color: kAccentColor,
                    ),
                  ),
                ),
                // kSizedBox,
                // kIsWeb
                //     ? Center(
                //         child: ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //               padding: const EdgeInsets.symmetric(
                //                   vertical: 25, horizontal: 40),
                //               backgroundColor: kAccentColor),
                //           onPressed: launchDownloadLinkAndroid,
                //           child: const Text(
                //             'Download APK',
                //             style: TextStyle(
                //               color: kTextWhiteColor,
                //               fontSize: 15,
                //               fontWeight: FontWeight.w400,
                //             ),
                //           ),
                //         ),
                //       )
                //     : const SizedBox(),

                kSizedBox,
                media.width < 500 ? kSizedBox : const SizedBox(),
                deviceType(media.width) >= 2
                    ? const SizedBox(height: kDefaultPadding * 2)
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
