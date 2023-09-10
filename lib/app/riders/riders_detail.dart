// ignore_for_file: file_names, unused_local_variable

import 'package:benji_aggregator/controller/operation.dart';
import 'package:benji_aggregator/src/common_widgets/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../controller/rider_controller.dart';
import '../../controller/url_launch_controller.dart';
import '../../model/driver_history_model.dart';
import '../../model/rider_list_model.dart';
import '../../src/common_widgets/my_outlined_elevatedButton.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/custom_show_search.dart';
import '../../src/skeletons/dashboard_orders_list_skeleton.dart';
import '../others/call_page.dart';
import 'suspend_rider.dart';

class RidersDetail extends StatefulWidget {
  final String ridersImage;
  final String ridersName;
  final int noOfTrips;
  final String ridersPhoneNumber;
  final Widget onlineIndicator;
  final RiderItem? rider;
  const RidersDetail(
      {super.key,
      required this.ridersName,
      required this.noOfTrips,
      required this.ridersPhoneNumber,
      required this.ridersImage,
      required this.onlineIndicator,
      required this.rider});

  @override
  State<RidersDetail> createState() => _RidersDetailState();
}

class _RidersDetailState extends State<RidersDetail> {
  //===================== Initial State ==========================\\
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RiderController.instance.riderHistory(widget.rider!.id!);
    });
    super.initState();

    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  //============================ ALL VARIABLES =============================\\
  late bool _loadingScreen;
  final int _numberOfOrders = 10;
  bool _deliveryStatus = true;
  bool _loadingDeliveryStatus = false;
  String get message => _deliveryStatus
      ? "This item has been delivered"
      : "This item is being delivered";
  Color get messageColor => _deliveryStatus ? kSuccessColor : kLoadingColor;

  //============================================== CONTROLLERS =================================================\\
  final ScrollController _scrollController = ScrollController();

  //============================ FUNCTIONS =============================\\

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
//==========================================================================================\\

//=========================================== Navigation ===============================================\\
  void _callRider() => Get.to(
        () => CallPage(
          userName: widget.ridersName,
          userImage: widget.ridersImage,
          userPhoneNumber: widget.ridersPhoneNumber,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Call rider",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _seeMoreDeliveredOrders() {}
  void _seeMorePendingOrders() {}

  void _toSuspendRider() => Get.to(
        () => SuspendRider(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Suspend rider",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

//=====================================================================================\\
  void clickOnDelivered() async {
    setState(() {
      _loadingDeliveryStatus = false;
      _deliveryStatus = true;
    });

  }

  void clickOnPending() async {
    setState(() {
      _loadingDeliveryStatus = false;
      _deliveryStatus = false;
    });

      //  await Future.delayed(const Duration(seconds: 3));
     // setState(() {
     //   _loadingDeliveryStatus = false;
     // });
  }

  //=================================== Show Popup Menu =====================================\\
  //Show popup menu
  void showPopupMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    const position = RelativeRect.fromLTRB(10, 60, 0, 0);

    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        const PopupMenuItem<String>(
          value: 'suspend',
          child: Text("Suspend rider"),
        ),
      ],
    ).then((value) {
      // Handle the selected value from the popup menu
      if (value != null) {
        switch (value) {
          case 'suspend':
            _toSuspendRider();
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateAndTime = formatDateAndTime(now);
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    void showSearchField() {
      showSearch(context: context, delegate: CustomSearchDelegate());
    }

    void seeDeliveredMessage() => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          elevation: 20,
          barrierColor: kBlackColor.withOpacity(0.6),
          showDragHandle: true,
          useSafeArea: true,
          isDismissible: true,
          shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(kDefaultPadding)),
          ),
          enableDrag: true,
          builder: (context) => SizedBox(
            height: 80,
            child: Center(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 20,
                  color: messageColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );

    //====================================================================\\
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
          title: "Riders Details",
          elevation: 10.0,
          actions: [
            IconButton(
              onPressed: showSearchField,
              tooltip: "Search",
              icon: Icon(
                Icons.search_rounded,
                color: kAccentColor,
              ),
            ),
            IconButton(
              onPressed: () => showPopupMenu(context),
              icon: Icon(
                Icons.more_vert,
                color: kAccentColor,
              ),
            ),
          ],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: _loadingScreen
              ? SpinKitDoubleBounce(color: kAccentColor)
              : FutureBuilder(
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
                    return StreamBuilder<Object>(
                        stream: null,
                        builder: (context, snapshot) {
                          return GetBuilder<RiderController>(builder: (rider) {
                            List<HistoryItem> history = _deliveryStatus
                                ? rider.historyList
                                    .where((p0) => p0.deliveryStatus!
                                        .toLowerCase()
                                        .contains("completed".toLowerCase()))
                                    .toList()
                                : rider.historyList
                                    .where((p0) => !p0.deliveryStatus!
                                        .toLowerCase()
                                        .contains("completed".toLowerCase()))
                                    .toList();
                            return Scrollbar(
                              controller: _scrollController,
                              radius: const Radius.circular(10),
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(
                                  top: kDefaultPadding / 4,
                                  bottom: kDefaultPadding,
                                  left: kDefaultPadding,
                                  right: kDefaultPadding,
                                ),
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.all(kDefaultPadding),
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
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
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 60,
                                              backgroundColor: Colors.white54,
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      widget.rider!.image ?? "",
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      Center(
                                                          child:
                                                              CupertinoActivityIndicator(
                                                    color: kRedColor,
                                                  )),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(
                                                    Icons.error,
                                                    color: kRedColor,
                                                  ),
                                                ),
                                              ),
                                              // backgroundImage: AssetImage(
                                              //   "assets/images/${widget.ridersImage}",
                                              // ),
                                            ),
                                            Positioned(
                                              right: 15,
                                              bottom: 0,
                                              child: widget.onlineIndicator,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: kDefaultPadding / 2),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: mediaWidth - 250,
                                                child: Text(
                                                  "${widget.rider!.lastName ?? ""} ${widget.rider!.firstName ?? ""}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              kHalfSizedBox,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.phone,
                                                    color: kAccentColor,
                                                    size: 18,
                                                  ),
                                                  kHalfWidthSizedBox,
                                                  SizedBox(
                                                    width: mediaWidth - 250,
                                                    child: Text(
                                                      widget.rider!.phone ?? "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: kTextGreyColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              kHalfSizedBox,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.route,
                                                    color: kAccentColor,
                                                    size: 18,
                                                  ),
                                                  kHalfWidthSizedBox,
                                                  SizedBox(
                                                    width: mediaWidth - 250,
                                                    child: Text(
                                                      "0 Trips Completed",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: kTextGreyColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              kHalfSizedBox,
                                              MyOutlinedElevatedButton(
                                                onPressed: () =>
                                                    UrlLaunchController
                                                        .makePhoneCall(widget
                                                            .rider!.phone!),
                                                circularBorderRadius: 16,
                                                minimumSizeWidth: 100,
                                                minimumSizeHeight: 30,
                                                maximumSizeWidth: 100,
                                                maximumSizeHeight: 30,
                                                buttonTitle: "Call",
                                                titleFontSize: 14,
                                                elevation: 10.0,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: kDefaultPadding),
                                  const Text(
                                    "Shipping History",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  kHalfSizedBox,
                                  SizedBox(
                                    width: mediaWidth,
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: clickOnDelivered,
                                          onLongPress: null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _deliveryStatus
                                                ? kAccentColor
                                                : kDefaultCategoryBackgroundColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Text(
                                            "Delivered",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 14,
                                              color: _deliveryStatus
                                                  ? kTextWhiteColor
                                                  : kTextGreyColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        kWidthSizedBox,
                                        ElevatedButton(
                                          onPressed: clickOnPending,
                                          onLongPress: null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _deliveryStatus
                                                ? kDefaultCategoryBackgroundColor
                                                : kAccentColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Text(
                                            "Pending",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 14,
                                              color: _deliveryStatus
                                                  ? kTextGreyColor
                                                  : kTextWhiteColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  kHalfSizedBox,
                                  ListView.builder(
                                          itemCount: history.length,
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) =>
                                              Container(
                                            margin: const EdgeInsets.only(
                                                bottom: kDefaultPadding / 2),
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
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
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 120,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    color: kAccentColor,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(16),
                                                      bottomLeft:
                                                          Radius.circular(16),
                                                    ),
                                                    // image: const DecorationImage(
                                                    //   image: AssetImage(
                                                    //       "assets/images/products/new-food.png"),
                                                    //   fit: BoxFit.cover,
                                                    // ),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl: history[index]
                                                            .orders!
                                                            .first
                                                            .client!
                                                            .image ??
                                                        "",
                                                    fit: BoxFit.cover,
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        Center(
                                                            child:
                                                                CupertinoActivityIndicator(
                                                      color: kRedColor,
                                                    )),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                      Icons.error,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                      kDefaultPadding / 2),
                                                  // color: kAccentColor,
                                                  width: mediaWidth - 175,
                                                  height: 120,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 80,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: 100,
                                                                  child: Text(
                                                                    "ID ${history[index].orders!.first.code ?? "000"}",
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 120,
                                                                  child: Text(
                                                                    "Items",
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          kTextGreyColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap:
                                                                seeDeliveredMessage,
                                                            enableFeedback:
                                                                true,
                                                            splashColor:
                                                                kSuccessColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      kDefaultPadding /
                                                                          3),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color:
                                                                      kLightGreyColor,
                                                                  strokeAlign:
                                                                      BorderSide
                                                                          .strokeAlignInside,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Text(
                                                                _deliveryStatus
                                                                    ? "Delivered"
                                                                    : "Pending",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  color:
                                                                      kSuccessColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      kHalfSizedBox,
                                                      Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .my_location,
                                                                color:
                                                                    kAccentColor,
                                                                size: 18,
                                                              ),
                                                              kHalfWidthSizedBox,
                                                              SizedBox(
                                                                width:
                                                                    mediaWidth -
                                                                        230,
                                                                child: Text(
                                                                  history[index]
                                                                          .orders!
                                                                          .first
                                                                          .deliveryAddress!
                                                                          .streetAddress ??
                                                                      "",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on,
                                                                color:
                                                                    kAccentColor,
                                                                size: 18,
                                                              ),
                                                              kHalfWidthSizedBox,
                                                              SizedBox(
                                                                width:
                                                                    mediaWidth -
                                                                        230,
                                                                child: Text(
                                                                  history[index]
                                                                          .orders!
                                                                          .first
                                                                          .deliveryAddress!
                                                                          .streetAddress ??
                                                                      "",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          Text(
                                                            history[index]
                                                                        .createdDate ==
                                                                    null
                                                                ? formattedDateAndTime
                                                                : Operation.convertDate(
                                                                    history[index]
                                                                        .createdDate!),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                  kSizedBox,
                                  _deliveryStatus
                                      ? TextButton(
                                          onPressed: _seeMoreDeliveredOrders,
                                          child: Text(
                                            "See more",
                                            style:
                                                TextStyle(color: kAccentColor),
                                          ),
                                        )
                                      : TextButton(
                                          onPressed: _seeMorePendingOrders,
                                          child: Text(
                                            "See more",
                                            style:
                                                TextStyle(color: kAccentColor),
                                          ),
                                        ),
                                ],
                              ),
                            );
                          });
                        });
                  },
                ),
        ),
      ),
    );
  }
}
