// ignore_for_file: unused_local_variable

import 'package:benji_aggregator/model/business_order_model.dart';
import 'package:benji_aggregator/src/components/section/my_liquid_refresh.dart';
import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/src/skeletons/dashboard_orders_list_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/my_future_builder.dart';
import '../../theme/colors.dart';
import 'active_order_details.dart';

class ActiveOrders extends StatefulWidget {
  final List<BusinessOrderModel>? orderList;
  const ActiveOrders({super.key, required this.orderList});

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
      const Duration(milliseconds: 1000),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  //=================================== CONTROLLERS ====================================\\
  final ScrollController scrollController = ScrollController();

//========================================================= ALL VARIABLES =======================================================\\
  late bool _loadingScreen;
  int incrementOrderID = 2 + 2;
  late int orderID;
  String orderItem = "Jollof Rice and Chicken";
  String customerImage = "customer/juliet_gomes.png";
  String customerName = "Juliet Gomes";
  String customerAddress = "21 Odogwu Street, New Haven";
  String customerPhoneNumber = "07023348400";
  int itemQuantity = 2;
  double price = 2500;
  double itemPrice = 2500;
  String orderImage = "chizzy's-food";

//========================================================= FUNCTIONS =======================================================\\

  double calculateSubtotal() {
    return itemPrice * itemQuantity;
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

//====================================================================================\\

    return MyLiquidRefresh(
      onRefresh: _handleRefresh,
      child: Scaffold(
        appBar: MyAppBar(
          title: "Active Orders",
          elevation: 0.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        body: SafeArea(
          child: MyFutureBuilder(
            future: null,
            child: () {
              return _loadingScreen
                  ? const Padding(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: OrdersListSkeleton(),
                    )
                  : Scrollbar(
                      controller: scrollController,
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(kDefaultPadding),
                        children: [
                          Column(
                            children: List.generate(widget.orderList!.length,
                                (index) {
                              final BusinessOrderModel order =
                                  widget.orderList![index];

                              return OrderDetail(order: order);
                            }),
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

class OrderDetail extends StatelessWidget {
  final BusinessOrderModel order;
  const OrderDetail({super.key, required this.order});
  void _toActiveOrderDetailsPage() => Get.to(
        () => ActiveOrderDetails(
          customerImage: "",
          customerName: "",
          customerPhoneNumber: "",
          customerAddress: "",
          formatted12HrTime: "",
          orderID: 3,
          orderImage: "",
          orderItem: "",
          itemQuantity: 2,
          subtotalPrice: 14.0,
          order: order,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Active order details",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  @override
  Widget build(BuildContext context) {
    int qty = 0;

    //  String formattedDateAndTime = formatDateAndTime(now);
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () => _toActiveOrderDetailsPage(),
      borderRadius: BorderRadius.circular(kDefaultPadding),
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
            borderRadius: BorderRadius.circular(kDefaultPadding),
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
                    borderRadius: BorderRadius.circular(16),
                    // image: DecorationImage(
                    //   image: AssetImage(
                    //     "assets/images/products/$orderImage.png",
                    //   ),
                    // ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: order.client.image ?? "",
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => const Center(
                            child: CupertinoActivityIndicator(
                      color: kRedColor,
                    )),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: kRedColor,
                    ),
                  ),
                ),
                kHalfSizedBox,
                SizedBox(
                  width: 60,
                  child: Text(
                    "#00${order.id}",
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
            kWidthSizedBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: mediaWidth / 1.55,
                  // color: kAccentColor,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Text(
                          "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'date here',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
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
                  child: const Text(
                    "Order",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
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
                          text: "x $qty",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const TextSpan(text: "  "),
                        TextSpan(
                          text:
                              "₦ ${convertToCurrency(order.totalPrice.toString())}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'sen',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                kHalfSizedBox,
                Container(
                  color: kLightGreyColor,
                  height: 1,
                  width: mediaWidth / 1.8,
                ),
                kHalfSizedBox,
                SizedBox(
                  width: mediaWidth / 1.8,
                  child: Text(
                    "${order.client.lastName} ${order.client.firstName}",
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
                  child: const Text(
                    "address here",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
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
    );
  }
}
