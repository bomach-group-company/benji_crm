// ignore_for_file: unused_local_variable

import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/src/skeletons/dashboard_orders_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../src/common_widgets/my_appbar.dart';
import '../../../theme/colors.dart';
import 'my_order_details.dart';

class ActiveOrders extends StatefulWidget {
  const ActiveOrders({super.key});

  @override
  State<ActiveOrders> createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends State<ActiveOrders> {
  //===================== Initial State ==========================\\
  @override
  void initState() {
    super.initState();

    _loadingScreen = true;
    Future.delayed(
      const Duration(seconds: 2),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  //=================================== CONTROLLERS ====================================\\
  final ScrollController _scrollController = ScrollController();

//========================================================= ALL VARIABLES =======================================================\\
  late bool _loadingScreen;
  int incrementOrderID = 2 + 2;
  late int orderID;
  String orderItem = "Jollof Rice and Chicken";
  String customerAddress = "21 Odogwu Street, New Haven";
  int itemQuantity = 2;
  double price = 2500;
  double itemPrice = 2500;
  String orderImage = "chizzy's-food";
  String customerName = "Mercy Luke";

//========================================================= FUNCTIONS =======================================================\\

  double calculateSubtotal() {
    return itemPrice * itemQuantity;
  }

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _loadingScreen = false;
    });
  }
//========================================================================================\\

  void _seeMoreActiveOrders() {}

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateAndTime = formatDateAndTime(now);
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    double subtotalPrice = calculateSubtotal();

    //===================== Navigate to Order Details Page ================================\\
    void toOrderDetailsPage() => Get.to(
          () => MyOrderDetails(
            formatted12HrTime: formattedDateAndTime,
            orderID: orderID,
            orderImage: orderImage,
            orderItem: orderItem,
            itemQuantity: itemQuantity,
            subtotalPrice: subtotalPrice,
            customerName: customerName,
            customerAddress: customerAddress,
          ),
          duration: const Duration(milliseconds: 300),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "Order details",
          preventDuplicates: true,
          popGesture: true,
          transition: Transition.downToUp,
        );

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
        appBar: MyAppBar(
          title: "Active Orders",
          elevation: 0.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const DashboardOrdersListSkeleton();
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
                  ? const Padding(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: DashboardOrdersListSkeleton(),
                    )
                  : Scrollbar(
                      controller: _scrollController,
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(kDefaultPadding),
                        children: [
                          Column(
                            children: [
                              for (orderID = 1;
                                  orderID < 30;
                                  orderID += incrementOrderID)
                                InkWell(
                                  onTap: toOrderDetailsPage,
                                  borderRadius:
                                      BorderRadius.circular(kDefaultPadding),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: kDefaultPadding / 2,
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: kDefaultPadding / 2,
                                      left: kDefaultPadding / 2,
                                      right: kDefaultPadding / 2,
                                    ),
                                    width: mediaWidth / 1.1,
                                    height: 150,
                                    decoration: ShapeDecoration(
                                      color: kPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            kDefaultPadding),
                                      ),
                                      shadows: const [
                                        BoxShadow(
                                          color: Color(0x0F000000),
                                          blurRadius: 24,
                                          offset: Offset(0, 4),
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: kPageSkeletonColor,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    "assets/images/products/$orderImage.png",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            kHalfSizedBox,
                                            Text(
                                              "#00${orderID.toString()}",
                                              style: TextStyle(
                                                color: kTextGreyColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          ],
                                        ),
                                        kWidthSizedBox,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: mediaWidth / 1.55,
                                              // color: kAccentColor,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const SizedBox(
                                                    child: Text(
                                                      "Hot Kitchen",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: Text(
                                                      formattedDateAndTime,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            kHalfSizedBox,
                                            Container(
                                              color: kTransparentColor,
                                              width: 250,
                                              child: Text(
                                                orderItem,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            kHalfSizedBox,
                                            Container(
                                              width: 200,
                                              color: kTransparentColor,
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "x $itemQuantity",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    const TextSpan(text: "  "),
                                                    TextSpan(
                                                      text:
                                                          "₦ ${itemPrice.toStringAsFixed(2)}",
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: 'sen',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            kHalfSizedBox,
                                            Container(
                                              color: kGreyColor1,
                                              height: 1,
                                              width: mediaWidth / 1.8,
                                            ),
                                            kHalfSizedBox,
                                            SizedBox(
                                              width: mediaWidth / 1.8,
                                              child: Text(
                                                customerName,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: mediaWidth / 1.8,
                                              child: Text(
                                                customerAddress,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          kSizedBox,
                          TextButton(
                            onPressed: _seeMoreActiveOrders,
                            child: Text(
                              "See more",
                              style: TextStyle(color: kAccentColor),
                            ),
                          ),
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
