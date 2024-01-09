// ignore_for_file:  unused_local_variable

import 'dart:async';

import 'package:benji_aggregator/app/my_orders/all_orders.dart';
import 'package:benji_aggregator/controller/category_controller.dart';
import 'package:benji_aggregator/controller/notification_controller.dart';
import 'package:benji_aggregator/controller/order_controller.dart';
import 'package:benji_aggregator/controller/rider_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/model/order.dart';
import 'package:benji_aggregator/src/components/appbar/dashboard_app_bar.dart';
import 'package:benji_aggregator/src/components/container/available_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/components/container/dashboard_rider_vendor_container.dart';
import '../../src/providers/constants.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../theme/colors.dart';
import '../my_orders/active_orders.dart';
import '../my_orders/pending_orders.dart';
import '../overview/overview.dart';

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
    VendorController.instance.getVendors();
    VendorController.instance.getMyVendors();
    OrderController.instance.getOrders();
    CategoryController.instance.getCategory();
    RiderController.instance.getRiders();
    NotificationController.instance.runTask();
    setState(() {
      loadingScreen = false;
    });
  }

//============================= Scroll to Top ======================================//
  void _scrollToTop() {
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
  void _toSeeAllVendors() => Get.to(
        () => OverView(currentIndex: 1),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Vendors",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _toSeeAllRiders() => Get.to(
        () => OverView(currentIndex: 2),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Riders",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void toSeeAllCompletedOrders(List<Order> completed) => Get.to(
        () => AllCompletedOrders(completed: completed),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "AllCompletedOrders",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void toSeeAllPendingOrders(List<Order> orderList) => Get.to(
        () => PendingOrders(orderList: orderList),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "PendingOrders",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void toSeeAllActiveOrders(List<Order> orderList) => Get.to(
        () => ActiveOrders(
          orderList: orderList,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "ActiveOrders",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

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
              onPressed: _scrollToTop,
              mini: deviceType(media.width) > 2 ? false : true,
              backgroundColor: kAccentColor,
              enableFeedback: true,
              mouseCursor: SystemMouseCursors.click,
              tooltip: "Scroll to top",
              hoverColor: kAccentColor,
              hoverElevation: 50.0,
              child: const FaIcon(FontAwesomeIcons.chevronUp, size: 18),
            )
          : const SizedBox(),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: RefreshIndicator(
          onRefresh: handleRefresh,
          color: kAccentColor,
          child: Scrollbar(
            controller: scrollController,
            child: ListView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(kDefaultPadding),
              children: [
                AvailableBalanceCard(availableBalance: doubleFormattedText(0)),
                kSizedBox,
                // GetBuilder<OrderController>(initState: (state) async {
                //   await OrderController.instance.getOrders();
                // }, builder: (order) {
                //   final active = order.orderList
                //       .where((p0) =>
                //           !p0.deliveryStatus
                //               .toLowerCase()
                //               .contains("COMP".toLowerCase()) &&
                //           p0.assignedStatus
                //               .toLowerCase()
                //               .contains("ASSG".toLowerCase()))
                //       .toList();
                //   final pending = order.orderList
                //       .where((p0) =>
                //           !p0.deliveryStatus
                //               .toLowerCase()
                //               .contains("COMP".toLowerCase()) &&
                //           p0.assignedStatus
                //               .toLowerCase()
                //               .contains("PEND".toLowerCase()))
                //       .toList();
                //   return Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       OrdersContainer(
                //         containerColor: kPrimaryColor,
                //         typeOfOrderColor: kTextGreyColor,
                //         iconColor: kLightGreyColor,
                //         numberOfOrders: intFormattedText(active.length),
                //         typeOfOrders: "Active",
                //         onTap: () => toSeeAllActiveOrders(active),
                //       ),
                //       OrdersContainer(
                //         containerColor:
                //             // Colors.red.shade200,
                //             kAccentColor.withOpacity(0.4),
                //         typeOfOrderColor: kAccentColor,
                //         iconColor: kAccentColor,
                //         numberOfOrders: intFormattedText(pending.length),
                //         typeOfOrders: "Pending",
                //         onTap: () => toSeeAllPendingOrders(pending),
                //       ),
                //     ],
                //   );
                // }),
                // kSizedBox,
                // GetBuilder<OrderController>(builder: (order) {
                //   final orders = order.orderList.toList();

                //   return DasboardAllCompletedOrdersContainer(
                //     onTap: () => toSeeAllCompletedOrders(orders),
                //     number: intFormattedText(orders.length),
                //     typeOf: "Orders",
                //   );
                // }),
                // kSizedBox,
                GetBuilder<VendorController>(initState: (state) async {
                  await VendorController.instance.getVendors();
                }, builder: (vendor) {
                  final allVendor = vendor.vendorList.toList();
                  final allOnlineVendor = vendor.vendorList;
                  return RiderVendorContainer(
                    onTap: _toSeeAllVendors,
                    number: intFormattedText(allVendor.length),
                    typeOf: "Vendors",
                    onlineStatus: "Available",
                  );
                }),
                kSizedBox,
                GetBuilder<RiderController>(initState: (state) async {
                  await RiderController.instance.getRiders();
                }, builder: (rider) {
                  final allRider = rider.riderList.toList();
                  // final allOnlineRiders = rider.riderList
                  //     .where((p0) => p0.isOnline == true)
                  //     .toList();
                  return RiderVendorContainer(
                    onTap: _toSeeAllRiders,
                    number: rider.total.value.toString(),
                    typeOf: "Riders",
                    onlineStatus: "Available",
                    // : "$allOnlineRiders Online",
                  );
                }),
                const SizedBox(height: kDefaultPadding * 2),
                kSizedBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
