// ignore_for_file: file_names, unused_local_variable, unused_element

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../controller/url_launch_controller.dart';
import '../../../model/order_list_model.dart';
import '../../../src/components/my_appbar.dart';
import '../../../src/components/my_elevatedButton.dart';
import '../../../src/components/my_outlined_elevatedButton.dart';
import '../../../src/providers/constants.dart';
import '../../../theme/colors.dart';
import '../../riders/assign_rider.dart';

class PendingOrderDetails extends StatefulWidget {
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
  const PendingOrderDetails(
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
  State<PendingOrderDetails> createState() => _PendingOrderDetailsState();
}

class _PendingOrderDetailsState extends State<PendingOrderDetails> {
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
  bool _orderProcessing = false;
  bool _orderAccepted = false;
  bool isOrderCanceled = false;
  double deliveryFee = 300.00;
//============================== FUNCTIONS ================================\\

//============================== Navigation ================================\\
  //ASSIGN RIDER
  void _assignRider() => Get.to(
        () => AssignRider(
          item: widget.order,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Assign rider",
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

  //Order Accepted
  void _processOrderAccepted() {
    setState(() {
      _orderProcessing = true;
    });

    // Simulating an asynchronous process
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _orderProcessing = false;
        _orderAccepted = true;
      });
    });
  }

  //Order Canceled
  void _processOrderCanceled() {
    setState(() {
      _orderProcessing = true;
    });

    // Simulating an asynchronous process
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _orderProcessing = false;
        isOrderCanceled = true;
      });
    });
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
                                      color: Color(0xFF222222),
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
                                    "#00${01231.toString()}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF222222),
                                      fontSize: 16.09,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.32,
                                    ),
                                  ),
                                  widget.order.assignedStatus!
                                          .toLowerCase()
                                          .contains("CANC".toLowerCase())
                                      ? Text(
                                          'Canceled',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 16.09,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.32,
                                          ),
                                        )
                                      : widget.order.assignedStatus!
                                              .toLowerCase()
                                              .contains("ACCE".toLowerCase())
                                          ? const Text(
                                              'Accepted',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: kSuccessColor,
                                                fontSize: 16.09,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: -0.32,
                                              ),
                                            )
                                          : widget.order.assignedStatus!
                                                  .toLowerCase()
                                                  .contains(
                                                      "ASSG".toLowerCase())
                                              ? Text(
                                                  'Assigned',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: kLoadingColor,
                                                    fontSize: 16.09,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: -0.32,
                                                  ),
                                                )
                                              : Text(
                                                  'Pending',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: kSecondaryColor,
                                                    fontSize: 16.09,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: -0.32,
                                                  ),
                                                ),
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
                              'Items ordered',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
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
                                        const TextSpan(
                                          text: "order",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.52,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: " ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.52,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "x ${widget.order.orderitems!.first.quantity}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.52,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "₦ ${convertToCurrency(widget.order.totalPrice.toString())}",
                                        style: const TextStyle(
                                          color: Color(0xFF222222),
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
                                color: Colors.black,
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
                                  child: CachedNetworkImage(
                                    imageUrl: widget.order.client!.image ?? "",
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.order.client!.lastName} ${widget.order.client!.firstName}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
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
                                        widget.order.deliveryAddress!
                                                .streetAddress ??
                                            "",
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
                                _orderAccepted
                                    ? Container(
                                        height: 48,
                                        width: 48,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFFDD5D5),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                width: 0.40,
                                                color: Color(0xFFD4DAF0)),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: () =>
                                              UrlLaunchController.makePhoneCall(
                                                  "+237039502751"),
                                          icon: FaIcon(
                                            FontAwesomeIcons.phone,
                                            color: kAccentColor,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 48,
                                        width: 48,
                                        decoration: ShapeDecoration(
                                          color: kLightGreyColor,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                width: 0.40,
                                                color: Color(0xFFD4DAF0)),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: null,
                                          disabledColor: kLightGreyColor,
                                          icon: FaIcon(
                                            FontAwesomeIcons.phone,
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
                              'Order Summary',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.09,
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
                                    color: Colors.black,
                                    fontSize: 12.52,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "₦",
                                        style: TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 9.83,
                                          fontFamily: 'Sen',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' ',
                                        style: TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 12.52,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.subtotalPrice
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 14.30,
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
                                    color: Colors.black,
                                    fontSize: 12.52,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "₦",
                                        style: TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 14,
                                          fontFamily: 'Sen',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' ',
                                        style: TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 12.52,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: deliveryFee.toStringAsFixed(2),
                                        style: const TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 14.30,
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
                                    color: Colors.black,
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
                                          color: Color(0xFF222222),
                                          fontSize: 14,
                                          fontFamily: 'Sen',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' ',
                                        style: TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 12.52,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: totalPrice.toStringAsFixed(2),
                                        style: const TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 14.30,
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
                      isOrderCanceled
                          ? Container(
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
                                  FaIcon(
                                    color: kAccentColor,
                                    Icons.info_outline_rounded,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Order Canceled',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.09,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.32,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: mediaWidth * 0.5,
                                        child: const Text(
                                          'This order has been canceled',
                                          style: TextStyle(
                                            color: Color(0xFF6E6E6E),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -0.28,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          : _orderAccepted
                              ? MyElevatedButton(
                                  onPressed: () {
                                    _assignRider();
                                  },
                                  title: "Assign a rider",
                                )
                              : _orderProcessing
                                  ? SpinKitChasingDots(
                                      color: kAccentColor,
                                      duration: const Duration(seconds: 2),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MyOutlinedElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                            //  _processOrderCanceled();
                                          },
                                          buttonTitle: "Cancel Order",
                                          elevation: 10.0,
                                          titleFontSize: 16.09,
                                          circularBorderRadius: 10.0,
                                          maximumSizeHeight: 50.07,
                                          maximumSizeWidth: mediaWidth / 2.5,
                                          minimumSizeHeight: 50.07,
                                          minimumSizeWidth: mediaWidth / 2.5,
                                        ),
                                        MyElevatedButton(
                                          onPressed: () {
                                            _processOrderAccepted();
                                          },
                                          title: "Accept Order",
                                        ),
                                      ],
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
