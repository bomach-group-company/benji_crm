// ignore_for_file:  unused_local_variable

import 'package:benji_aggregator/app/others/my_orders/all_orders.dart';
import 'package:benji_aggregator/controller/order_controller.dart';
import 'package:benji_aggregator/controller/rider_controller.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/src/components/dashboard_all_orders_container.dart';
import 'package:benji_aggregator/src/skeletons/dashboard_page_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../controller/user_controller.dart';
import '../../model/order_list_model.dart';
import '../../src/components/dashboard_appBar.dart';
import '../../src/components/dashboard_orders_container.dart';
import '../../src/components/dashboard_rider_vendor_container.dart';
import '../../src/providers/constants.dart';
import '../../src/skeletons/all_riders_page_skeleton.dart';
import '../../theme/colors.dart';
import '../others/my_orders/active_orders.dart';
import '../others/my_orders/pending_orders.dart';
import '../riders/riders.dart';
import '../vendors/vendors.dart';

class Dashboard extends StatefulWidget {
  final VoidCallback showNavigation;
  final VoidCallback hideNavigation;
  Dashboard(
      {Key? key, required this.showNavigation, required this.hideNavigation})
      : super(key: key);
  final user = Get.put(UserController());
  final vendor = Get.put(VendorController());
  final ride = Get.put(RiderController());

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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      OrderController.instance.runTask();
      VendorController.instance.runTask();
      RiderController.instance.runTask();
    });

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _scrollController.addListener(_scrollListener);
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavigation();
      } else {
        widget.hideNavigation();
      }
    });
    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    _scrollController.removeListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavigation();
      } else {
        widget.hideNavigation();
      }
    });
  }

//==========================================================================================\\

//=================================== ALL VARIABLES =====================================\\
  late bool _loadingScreen;
  bool _isScrollToTopBtnVisible = false;
  int incrementOrderID = 2 + 2;
  late int orderID;
  String orderItem = "Jollof Rice and Chicken";
  String customerAddress = "21 Odogwu Street, New Haven";
  int itemQuantity = 2;
  double price = 2500;
  double itemPrice = 2500;
  String orderImage = "chizzy's-food";
  String customerName = "Mercy Luke";

//============================================== CONTROLLERS =================================================\\
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;

//=================================== FUNCTIONS =====================================\\

  double calculateSubtotal() {
    return itemPrice * itemQuantity;
  }

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _loadingScreen = false;
    });
  }

//============================= Scroll to Top ======================================//
  void _scrollToTop() {
    _animationController.reverse();
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void _scrollListener() {
    //========= Show action button ========//
    if (_scrollController.position.pixels >= 200) {
      _animationController.forward();
      setState(() => _isScrollToTopBtnVisible = true);
    }
    //========= Hide action button ========//
    else if (_scrollController.position.pixels < 200) {
      _animationController.reverse();
      setState(() => _isScrollToTopBtnVisible = false);
    }
  }

//=================================== Navigation =====================================\\

  void _toSeeAllRiders() => Get.to(
        () => Riders(
          showNavigation: () {},
          hideNavigation: () {},
          appBarBackgroundColor: kAccentColor,
          appTitleColor: kPrimaryColor,
          appBarSearchIconColor: kPrimaryColor,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "All riders",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _toSeeAllVendors() => Get.to(
        () => Vendors(
          showNavigation: () {},
          hideNavigation: () {},
          appBarBackgroundColor: kAccentColor,
          appTitleColor: kPrimaryColor,
          appBarSearchIconColor: kPrimaryColor,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "All vendors",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _toSeeAllOrders(List<OrderItem> completed, List<OrderItem> rejected) =>
      Get.to(
        () => AllOrders(
          completed: completed,
          rejected: rejected,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "All orders",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _toSeeAllNewOrders(List<OrderItem> orderList) => Get.to(
        () => PendingOrders(
          orderList: orderList,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Pending orders",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _toSeeAllActiveOrders(List<OrderItem> orderList) => Get.to(
        () => ActiveOrders(
          orderList: orderList,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Active orders",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateAndTime = formatDateAndTime(now);
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    double subtotalPrice = calculateSubtotal();

//====================================================================================\\

    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: kAccentColor,
      borderWidth: 5.0,
      backgroundColor: kPrimaryColor,
      height: 150,
      animSpeedFactor: 2,
      showChildOpacityTransition: false,
      child: Scaffold(
        appBar: const DashboardAppBar(),
        floatingActionButton: Stack(
          children: <Widget>[
            if (_isScrollToTopBtnVisible) ...[
              ScaleTransition(
                scale: CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.fastEaseInToSlowEaseOut),
                child: FloatingActionButton(
                  onPressed: _scrollToTop,
                  mini: true,
                  backgroundColor: kAccentColor,
                  enableFeedback: true,
                  mouseCursor: SystemMouseCursors.click,
                  tooltip: "Scroll to top",
                  hoverColor: kAccentColor,
                  hoverElevation: 50.0,
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              ),
            ]
          ],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: FutureBuilder(
            future: null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const AllRidersPageSkeleton();
              }
              if (snapshot.connectionState == ConnectionState.none) {
                const Center(
                  child: Text("Please connect to the internet"),
                );
              }
              // if (snapshot.connectionState == snapshot.requireData) {
              //   SpinKitDoubleBounce(color: kAccentColor);
              // }
              if (snapshot.connectionState == snapshot.error) {
                const Center(
                  child: Text("Error, Please try again later"),
                );
              }
              return _loadingScreen
                  ? const DashboardPageSkeleton()
                  : Scrollbar(
                      controller: _scrollController,
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(kDefaultPadding),
                        children: [
                          GetBuilder<OrderController>(
                              init: OrderController(),
                              builder: (order) {
                                final active = order.orderList
                                    .where((p0) =>
                                        !p0.deliveryStatus!
                                            .toLowerCase()
                                            .contains("COMP".toLowerCase()) &&
                                        p0.assignedStatus!
                                            .toLowerCase()
                                            .contains("ASSG".toLowerCase()))
                                    .toList();
                                final pending = order.orderList
                                    .where((p0) =>
                                        !p0.deliveryStatus!
                                            .toLowerCase()
                                            .contains("COMP".toLowerCase()) &&
                                        p0.assignedStatus!
                                            .toLowerCase()
                                            .contains("PEND".toLowerCase()))
                                    .toList();
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OrdersContainer(
                                      containerColor: kPrimaryColor,
                                      typeOfOrderColor: kTextGreyColor,
                                      iconColor: kLightGreyColor,
                                      numberOfOrders: "${active.length}",
                                      typeOfOrders: "Active",
                                      onTap: () =>
                                          _toSeeAllActiveOrders(active),
                                    ),
                                    OrdersContainer(
                                      containerColor: Colors.red.shade100,
                                      typeOfOrderColor: kAccentColor,
                                      iconColor: kAccentColor,
                                      numberOfOrders: "${pending.length}",
                                      typeOfOrders: "Pending",
                                      onTap: () => _toSeeAllNewOrders(pending),
                                    ),
                                  ],
                                );
                              }),
                          kSizedBox,
                          GetBuilder<OrderController>(
                              init: OrderController(),
                              builder: (order) {
                                final allOrders = order.orderList.toList();
                                final rej = order.orderList
                                    .where((p0) =>
                                        !p0.deliveryStatus!
                                            .toLowerCase()
                                            .contains("CANC".toLowerCase()) ||
                                        p0.assignedStatus!
                                            .toLowerCase()
                                            .contains("CANC".toLowerCase()))
                                    .toList();

                                return DasboardAllOrdersContainer(
                                  onTap: () => _toSeeAllOrders(allOrders, rej),
                                  number: "${allOrders.length}",
                                  typeOf: "All Orders",
                                  onlineStatus: "${rej.length} rejected",
                                );
                              }),
                          kSizedBox,
                          GetBuilder<VendorController>(
                              init: VendorController(),
                              builder: (vendor) {
                                final allVendor = vendor.vendorList.toList();
                                final allOnlineVendor = vendor.vendorList
                                    .where((p0) => p0.isOnline == true)
                                    .toList();
                                return RiderVendorContainer(
                                  onTap: _toSeeAllVendors,
                                  number: "${allVendor.length}",
                                  typeOf: "Vendors",
                                  onlineStatus:
                                      "${allOnlineVendor.length} Online",
                                );
                              }),
                          kSizedBox,
                          GetBuilder<RiderController>(
                              init: RiderController(),
                              builder: (rider) {
                                final allRider = rider.riderList.toList();
                                // final allOnlineVendor = vendor.vendorList
                                //     .where((p0) => p0.isOnline == true)
                                //     .toList();
                                return RiderVendorContainer(
                                  onTap: _toSeeAllRiders,
                                  number: "${allRider.length}",
                                  typeOf: "Riders",
                                  onlineStatus: "32 Online",
                                );
                              }),
                          const SizedBox(height: kDefaultPadding * 2),
                          kSizedBox,
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
