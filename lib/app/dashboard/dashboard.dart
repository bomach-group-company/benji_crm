// ignore_for_file:  unused_local_variable

import 'dart:async';

import 'package:benji_aggregator/controller/notification_controller.dart';
import 'package:benji_aggregator/controller/rider_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/src/components/appbar/dashboard_app_bar.dart';
import 'package:benji_aggregator/src/components/container/available_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/components/container/dashboard_container.dart';
import '../../src/providers/constants.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../theme/colors.dart';
import '../overview/overview.dart';
import '../packages/send_package.dart';

class Dashboard extends StatefulWidget {
  final VoidCallback showNavigation;
  final VoidCallback hideNavigation;
  const Dashboard(
      {super.key, required this.showNavigation, required this.hideNavigation});

  @override
  State<Dashboard> createState() => _DashboardState();
}

typedef ModalContentBuilder = Widget Function(BuildContext);

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  //===================== Initial State ==========================\\
  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    scrollController.addListener(_scrollListener);
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward ||
          scrollController.position.pixels < 100) {
        widget.showNavigation();
      } else {
        widget.hideNavigation();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    scrollController.dispose();
    handleRefresh().ignore();
    scrollController.removeListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavigation();
      } else {
        widget.hideNavigation();
      }
    });
  }

//==========================================================================================\\

//=================================== ALL VARIABLES =====================================\\
  final notifications = NotificationController.instance.notification.length;
  late Timer timer;
  bool _isScrollToTopBtnVisible = false;
  int incrementOrderID = 2 + 2;
  late int orderID;
  String orderOrder = "Jollof Rice and Chicken";
  String customerAddress = "21 Odogwu Street, New Haven";
  int itemQuantity = 2;
  double price = 2500;
  double itemPrice = 2500;
  String orderImage = "chizzy's-food";
  String customerName = "Mercy Luke";

  late bool loadingScreen;

//============================================== CONTROLLERS =================================================\\
  final scrollController = ScrollController();
  late AnimationController _animationController;

//=================================== FUNCTIONS =====================================\\

  double calculateSubtotal() {
    return itemPrice * itemQuantity;
  }

//===================== Handle refresh ==========================\\

  Future<void> handleRefresh() async {
    setState(() {
      loadingScreen = true;
    });
    await VendorController.instance.getMyVendors();
    await VendorController.instance.getTotalNumberOfMyVendors();
    await NotificationController.instance.runTask();
    setState(() {
      loadingScreen = false;
    });
  }

//============================= Scroll to Top ======================================//
  void scrollToTop() {
    _animationController.reverse();
    scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void _scrollListener() {
    //========= Show action button ========//
    if (scrollController.position.pixels >= 100) {
      _animationController.forward();
      setState(() => _isScrollToTopBtnVisible = true);
    }
    //========= Hide action button ========//
    else if (scrollController.position.pixels < 100) {
      _animationController.reverse();
      setState(() => _isScrollToTopBtnVisible = false);
    }
  }

//=================================== Navigation =====================================\\
  void _toSeeMyVendors() => Get.to(
        () => const OverView(currentIndex: 1),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "OverView",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _toSeeAllRiders() => Get.to(
        () => const OverView(currentIndex: 2),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "OverView",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  toSendPackage() {
    Get.to(
      () => const SendPackage(),
      routeName: 'SendPackage',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateAndTime = formatDateAndTime(now);
    var media = MediaQuery.of(context).size;

    double subtotalPrice = calculateSubtotal();

//====================================================================================\\

    return Scaffold(
      appBar: DashboardAppBar(
        numberOfNotifications: notifications,
        image: UserController.instance.user.value.image,
      ),
      floatingActionButton: _isScrollToTopBtnVisible
          ? FloatingActionButton(
              onPressed: scrollToTop,
              mini: deviceType(media.width) > 2 ? false : true,
              backgroundColor: kAccentColor,
              enableFeedback: true,
              mouseCursor: SystemMouseCursors.click,
              tooltip: "Scroll to top",
              hoverColor: kAccentColor,
              hoverElevation: 50.0,
              child: FaIcon(
                FontAwesomeIcons.chevronUp,
                size: 18,
                color: kPrimaryColor,
              ),
            )
          : const SizedBox(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: handleRefresh,
          color: kAccentColor,
          child: Scrollbar(
            child: ListView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(kDefaultPadding),
              children: [
                const AvailableBalanceCard(),
                kSizedBox,
                GetBuilder<VendorController>(
                  init: VendorController(),
                  initState: (state) async {
                    await VendorController.instance.getTotalNumberOfMyVendors();
                  },
                  builder: (controller) {
                    final allVendor = controller.allMyVendorList.toList();
                    return DashboardContainer(
                      onTap: _toSeeMyVendors,
                      number: controller.isLoad.value
                          ? "Loading..."
                          : intFormattedText(allVendor.length),
                      typeOf: "My Vendors",
                      onlineStatus: "Online",
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
                        ? "Loading..."
                        : controller.totalRiders.value.toString(),
                    typeOf: "Riders",
                    onlineStatus: "Online",
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
                      FontAwesomeIcons.bicycle,
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
                    trailing: const FaIcon(FontAwesomeIcons.chevronRight),
                  ),
                ),
                kSizedBox,
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
