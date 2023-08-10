import 'package:benji_aggregator/src/common_widgets/my_appbar.dart';
import 'package:benji_aggregator/src/skeletons/dashboard_orders_list_skeleton.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../src/common_widgets/all_orders_container.dart';
import '../../../src/common_widgets/completed_orders_tab.dart';
import '../../../src/providers/constants.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders>
    with SingleTickerProviderStateMixin {
  //======================================= INITIAL AND DISPOSE ===============================================\\
  @override
  void initState() {
    super.initState();

    _tabBarController = TabController(length: 2, vsync: this);
    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

//==========================================================================================\\

  //=================================== ALL VARIABLES ====================================\\

  //=================================== Orders =======================================\\
  final int _incrementOrderID = 2 + 2;
  late int _orderID;
  final String _orderItem = "Jollof Rice and Chicken";
  final String _customerAddress = "21 Odogwu Street, New Haven";
  final int _itemQuantity = 2;
  // final double _price = 2500;
  final double _itemPrice = 2500;
  final String _orderImage = "chizzy's-food";
  final String _customerName = "Mercy Luke";

//===================== BOOL VALUES =======================\\
  // bool isLoading = false;
  late bool _loadingScreen;
  bool _loadingTabBarContent = false;

  //=================================== CONTROLLERS ====================================\\
  late TabController _tabBarController;
  final ScrollController _scrollController = ScrollController();

  //=============================================== FUNCTIONS ====================================================\\
  double calculateSubtotal() {
    return _itemPrice * _itemQuantity;
  }

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _loadingScreen = false;
    });
  }

  //===================== Tab Bar ==========================\\
  void _clickOnTabBarOption() async {
    setState(() {
      _loadingTabBarContent = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _loadingTabBarContent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateAndTime = formatDateAndTime(now);
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: kAccentColor,
      borderWidth: 5.0,
      backgroundColor: kPrimaryColor,
      height: 150,
      animSpeedFactor: 2,
      showChildOpacityTransition: false,
      child: Scaffold(
        appBar: MyAppBar(
          title: "All Orders",
          elevation: 0.0,
          actions: [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                Center(child: SpinKitDoubleBounce(color: kAccentColor));
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
                  ? SpinKitDoubleBounce(color: kAccentColor)
                  : Scrollbar(
                      controller: _scrollController,
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(kDefaultPadding),
                        // controller: _scrollController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding,
                            ),
                            child: Container(
                              width: mediaWidth,
                              decoration: BoxDecoration(
                                color: kDefaultCategoryBackgroundColor,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: kLightGreyColor,
                                  style: BorderStyle.solid,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TabBar(
                                      controller: _tabBarController,
                                      onTap: (value) => _clickOnTabBarOption(),
                                      enableFeedback: true,
                                      mouseCursor: SystemMouseCursors.click,
                                      automaticIndicatorColorAdjustment: true,
                                      overlayColor: MaterialStatePropertyAll(
                                          kAccentColor),
                                      labelColor: kPrimaryColor,
                                      unselectedLabelColor: kTextGreyColor,
                                      indicatorColor: kAccentColor,
                                      indicatorWeight: 2,
                                      splashBorderRadius:
                                          BorderRadius.circular(50),
                                      indicator: BoxDecoration(
                                        color: kAccentColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      tabs: const [
                                        Tab(text: "Completed"),
                                        Tab(text: "Rejected"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          kSizedBox,
                          SizedBox(
                            height: mediaHeight + mediaHeight,
                            width: mediaWidth,
                            child: Column(
                              children: [
                                Expanded(
                                  child: TabBarView(
                                    controller: _tabBarController,
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      _loadingTabBarContent
                                          ? OrdersListSkeleton()
                                          : CompletedOrdersTab(
                                              list: Column(
                                                children: [
                                                  for (_orderID = 1;
                                                      _orderID < 30;
                                                      _orderID +=
                                                          _incrementOrderID)
                                                    AllOrdersContainer(
                                                      mediaWidth: mediaWidth,
                                                      orderImage: _orderImage,
                                                      orderID: _orderID,
                                                      orderStatusIcon: Icon(
                                                        Icons.check_circle,
                                                        color: kSuccessColor,
                                                      ),
                                                      formattedDateAndTime:
                                                          formattedDateAndTime,
                                                      orderItem: _orderItem,
                                                      itemQuantity:
                                                          _itemQuantity,
                                                      itemPrice: _itemPrice,
                                                      customerName:
                                                          _customerName,
                                                      customerAddress:
                                                          _customerAddress,
                                                    ),
                                                ],
                                              ),
                                            ),
                                      _loadingTabBarContent
                                          ? OrdersListSkeleton()
                                          : Column(
                                              children: [
                                                for (_orderID = 1;
                                                    _orderID < 30;
                                                    _orderID +=
                                                        _incrementOrderID)
                                                  AllOrdersContainer(
                                                    mediaWidth: mediaWidth,
                                                    orderImage: _orderImage,
                                                    orderID: _orderID,
                                                    orderStatusIcon: Icon(
                                                      Icons.cancel,
                                                      color: kAccentColor,
                                                    ),
                                                    formattedDateAndTime:
                                                        formattedDateAndTime,
                                                    orderItem: _orderItem,
                                                    itemQuantity: _itemQuantity,
                                                    itemPrice: _itemPrice,
                                                    customerName: _customerName,
                                                    customerAddress:
                                                        _customerAddress,
                                                  ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
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
