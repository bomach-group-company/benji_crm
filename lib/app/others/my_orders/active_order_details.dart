// ignore_for_file: file_names, unused_local_variable, unused_element

import 'package:benji_aggregator/app/others/my_orders/track_order.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../controller/url_launch_controller.dart';
import '../../../model/order_list_model.dart';
import '../../../src/components/my_appbar.dart';
import '../../../src/components/my_elevatedButton.dart';
import '../../../src/providers/constants.dart';
import '../../../theme/colors.dart';

class ActiveOrderDetails extends StatefulWidget {
  final int orderID;
  final String formatted12HrTime;
  final String orderItem;
  final String customerImage;
  final String customerName;
  final String customerAddress;
  final String customerPhoneNumber;
  final int itemQuantity;
  final double subtotalPrice;
  final String orderImage;
  final OrderItem order;
  const ActiveOrderDetails(
      {super.key,
      required this.orderID,
      required this.orderItem,
      required this.customerAddress,
      required this.itemQuantity,
      required this.subtotalPrice,
      required this.orderImage,
      required this.formatted12HrTime,
      required this.customerName,
      required this.customerImage,
      required this.customerPhoneNumber,
      required this.order});

  @override
  State<ActiveOrderDetails> createState() => _ActiveOrderDetailsState();
}

class _ActiveOrderDetailsState extends State<ActiveOrderDetails> {
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

//============================== ALL VARIABLES ================================\\

//============================== BOOLS ================================\\
  late bool _loadingScreen;

  double deliveryFee = 300.00;
//============================== FUNCTIONS ================================\\

//============================== Navigation ================================\\

  void _trackOrder() => Get.to(
        () => const TrackOrder(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Track order",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
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

  double calculateTotalPrice() {
    return widget.subtotalPrice + deliveryFee;
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
//=======================================================================\\

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
          title: "Order Details",
          elevation: 10.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        body: FutureBuilder(
          future: null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              SpinKitDoubleBounce(color: kAccentColor);
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
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(kDefaultPadding),
                    children: [
                      Container(
                        width: mediaWidth,
                        padding: const EdgeInsets.all(kDefaultPadding / 2),
                        decoration: ShapeDecoration(
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.30),
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
                        child: SizedBox(
                          width: mediaWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Oder ID',
                                    style: TextStyle(
                                      color: Color(0xFF808080),
                                      fontSize: 11.62,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    widget.formatted12HrTime,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 12.52,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              kHalfSizedBox,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "#00${widget.orderID.toString()}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 16.09,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.32,
                                    ),
                                  ),
                                  Text(
                                    !widget.order.assignedStatus!
                                            .toLowerCase()
                                            .contains("ASSG".toLowerCase())
                                        ? "Pending"
                                        : "Accepted",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: kSuccessColor,
                                      fontSize: 16.09,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.32,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      kSizedBox,
                      Container(
                        width: mediaWidth,
                        padding: const EdgeInsets.all(kDefaultPadding / 2),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.30),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x0F000000),
                              blurRadius: 24,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Items ordered',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 16.09,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.32,
                              ),
                            ),
                            kHalfSizedBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: ShapeDecoration(
                                    // image: DecorationImage(
                                    //   image: AssetImage(
                                    //     "assets/images/products/${widget.orderImage}.png",
                                    //   ),
                                    //   fit: BoxFit.fill,
                                    // ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: "",
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        const Center(
                                            child: CupertinoActivityIndicator(
                                      color: kRedColor,
                                    )),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      color: kRedColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 182.38,
                                  child: Text.rich(
                                    maxLines: 3,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: widget.orderItem,
                                          style: const TextStyle(
                                            color: kTextBlackColor,
                                            fontSize: 12.52,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: " ",
                                          style: TextStyle(
                                            color: kTextBlackColor,
                                            fontSize: 12.52,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "x ${widget.order.orderitems!.first.quantity}",
                                          style: const TextStyle(
                                            color: kTextBlackColor,
                                            fontSize: 12.52,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "₦ ${0.0}",
                                        style: TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontFamily: 'Sen',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      kSizedBox,
                      Container(
                        width: mediaWidth,
                        padding: const EdgeInsets.all(kDefaultPadding / 2),
                        decoration: ShapeDecoration(
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.30),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x0F000000),
                              blurRadius: 24,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Customer's Detail",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 16.09,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.32,
                              ),
                            ),
                            kSizedBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: ShapeDecoration(
                                    color: kPageSkeletonColor,
                                    // image: DecorationImage(
                                    //   image: AssetImage(
                                    //     "assets/images/${widget.customerImage}",
                                    //   ),
                                    //   fit: BoxFit.cover,
                                    // ),
                                    shape: const OvalBorder(),
                                  ),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          widget.order.client!.image ?? "",
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          const Center(
                                              child: CupertinoActivityIndicator(
                                        color: kRedColor,
                                      )),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error,
                                        color: kRedColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.order.client!.lastName} ${widget.order.client!.firstName} ",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: kTextBlackColor,
                                        fontSize: 12.52,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    kHalfSizedBox,
                                    Text(
                                      widget.order.client!.phone ?? "",
                                      style: TextStyle(
                                        color: kTextGreyColor,
                                        fontSize: 11.62,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    kSizedBox,
                                    const Text(
                                      'Delivery address',
                                      style: TextStyle(
                                        color: kTextBlackColor,
                                        fontSize: 10.73,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    kHalfSizedBox,
                                    SizedBox(
                                      width: 155,
                                      child: Text(
                                        "${widget.order.deliveryAddress!.streetAddress}",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: kTextGreyColor,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 12.52,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFFDD5D5),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 0.40,
                                          color: Color(0xFFD4DAF0)),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: IconButton(
                                    splashRadius: 30,
                                    onPressed: () {
                                      if (widget.order.client!.phone != null) {
                                        if (widget
                                            .order.client!.phone!.isNotEmpty) {
                                          UrlLaunchController.makePhoneCall(
                                              widget.order.client!.phone!);
                                        }
                                      }
                                    },
                                    icon: Icon(
                                      Icons.phone,
                                      color: kAccentColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      kSizedBox,
                      Container(
                        width: mediaWidth,
                        padding: const EdgeInsets.all(kDefaultPadding / 2),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.30),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x0F000000),
                              blurRadius: 24,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Order Summary',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.32,
                              ),
                            ),
                            kSizedBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "₦",
                                        style: TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontFamily: 'Sen',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' ',
                                        style: TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 12.52,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: convertToCurrency(
                                            widget.order.totalPrice.toString()),
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                            kHalfSizedBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Delivery Fee',
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "₦",
                                        style: TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontFamily: 'Sen',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' ',
                                        style: TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 12.52,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: deliveryFee.toStringAsFixed(2),
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                            kHalfSizedBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "₦",
                                        style: TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontFamily: 'Sen',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' ',
                                        style: TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 12.52,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: totalPrice.toStringAsFixed(2),
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                            kHalfSizedBox,
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                      Container(
                        width: mediaWidth,
                        padding: const EdgeInsets.all(15),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFEF8F8),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 0.50,
                              color: Color(0xFFFDEDED),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              color: kSuccessColor,
                              Icons.check_circle_outline,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Order Accepted",
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 16.09,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: mediaWidth / 1.4,
                                  child: Row(
                                    children: [
                                      Text(
                                        "This order is being delivered...",
                                        style: TextStyle(
                                          color: kTextGreyColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Icon(
                                        Icons.delivery_dining,
                                        color: kAccentColor,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      kSizedBox,
                      MyElevatedButton(
                        onPressed: _trackOrder,
                        title: "Track order",
                      ),
                      kSizedBox,
                    ],
                  );
          },
        ),
      ),
    );
  }
}
