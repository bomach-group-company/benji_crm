// ignore_for_file: file_names, unused_local_variable

import 'package:benji_aggregator/src/common_widgets/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../src/common_widgets/my_outlined_elevatedButton.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/custom show search.dart';

class RidersDetail extends StatefulWidget {
  final String ridersImage;
  final String ridersName;
  final int noOfTrips;
  final int ridersPhoneNumber;
  final Widget onlineIndicator;
  const RidersDetail(
      {super.key,
      required this.ridersName,
      required this.noOfTrips,
      required this.ridersPhoneNumber,
      required this.ridersImage,
      required this.onlineIndicator});

  @override
  State<RidersDetail> createState() => _RidersDetailState();
}

class _RidersDetailState extends State<RidersDetail> {
  //============================ ALL VARIABLES =============================\\
  bool isLoadingScreen = false;

  bool deliveryStatus = true;
  bool isLoading = false;
  String get message => deliveryStatus
      ? "This item has been delivered"
      : "This item is being delivered";
  Color get messageColor => deliveryStatus ? kSuccessColor : kLoadingColor;
  //============================ FUNCTIONS =============================\\
  void clickOnDelivered() async {
    setState(() {
      isLoading = true;
      deliveryStatus = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isLoading = false;
    });
  }

  void clickOnPending() async {
    setState(() {
      isLoading = true;
      deliveryStatus = false;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isLoading = false;
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

    Future.delayed(
      const Duration(seconds: 3),
      () => setState(
        () => isLoadingScreen = true,
      ),
    );

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
    return Scaffold(
      appBar: MyAppBar(
        title: "Riders Details",
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: showSearchField,
            tooltip: "Search",
            icon: Icon(
              Icons.search_rounded,
              color: kAccentColor,
            ),
          ),
        ],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Builder(builder: (context) {
          return !isLoadingScreen
              ? SpinKitDoubleBounce(
                  color: kAccentColor,
                )
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    top: kDefaultPadding / 4,
                    bottom: kDefaultPadding,
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(kDefaultPadding),
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
                                backgroundColor: kSecondaryColor,
                                backgroundImage: AssetImage(
                                  "assets/images/rider/${widget.ridersImage}.png",
                                ),
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
                                horizontal: kDefaultPadding),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 140,
                                  child: Text(
                                    widget.ridersName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                kHalfSizedBox,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: kAccentColor,
                                      size: 18,
                                    ),
                                    kHalfWidthSizedBox,
                                    SizedBox(
                                      width: 140,
                                      child: Text(
                                        "0${widget.ridersPhoneNumber}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: kTextGreyColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                kHalfSizedBox,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.route,
                                      color: kAccentColor,
                                      size: 18,
                                    ),
                                    kHalfWidthSizedBox,
                                    SizedBox(
                                      width: 140,
                                      child: Text(
                                        "${widget.noOfTrips} Trips Completed",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: kTextGreyColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                kHalfSizedBox,
                                MyOutlinedElevatedButton(
                                  onPressed: () {},
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
                              backgroundColor: deliveryStatus
                                  ? kAccentColor
                                  : kDefaultCategoryBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Delivered",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                                color: deliveryStatus
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
                              backgroundColor: deliveryStatus
                                  ? kDefaultCategoryBackgroundColor
                                  : kAccentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Pending",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                                color: deliveryStatus
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
                    isLoading
                        ? Center(
                            child: SpinKitDoubleBounce(color: kAccentColor))
                        : deliveryStatus
                            ? ListView.builder(
                                itemCount: 30,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) => Container(
                                  margin: const EdgeInsets.only(
                                      bottom: kDefaultPadding / 2),
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
                                      Container(
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: kAccentColor,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            bottomLeft: Radius.circular(16),
                                          ),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/food/new-food.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(
                                            kDefaultPadding / 2),
                                        // color: kAccentColor,
                                        width: 240,
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
                                                      const SizedBox(
                                                        width: 120,
                                                        child: Text(
                                                          "ID 213081",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 120,
                                                        child: Text(
                                                          "Food",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                kTextGreyColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: seeDeliveredMessage,
                                                  enableFeedback: true,
                                                  splashColor: kSuccessColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            kDefaultPadding /
                                                                3),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: kGreyColor1,
                                                        strokeAlign: BorderSide
                                                            .strokeAlignInside,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: const Text(
                                                      "Delivered",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: kSuccessColor,
                                                        fontWeight:
                                                            FontWeight.w400,
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
                                                      Icons.my_location,
                                                      color: kAccentColor,
                                                      size: 18,
                                                    ),
                                                    kHalfWidthSizedBox,
                                                    const SizedBox(
                                                      width: 160,
                                                      child: Text(
                                                        "21 Bartus Street, Abuja Nigeria",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: kAccentColor,
                                                      size: 18,
                                                    ),
                                                    kHalfWidthSizedBox,
                                                    const SizedBox(
                                                      width: 160,
                                                      child: Text(
                                                        "3 Edwins Close, Wuse, Abuja",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  formattedDateAndTime,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
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
                              )
                            : ListView.builder(
                                itemCount: 30,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) => Container(
                                  margin: const EdgeInsets.only(
                                      bottom: kDefaultPadding / 2),
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
                                      Container(
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: kAccentColor,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            bottomLeft: Radius.circular(16),
                                          ),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/food/new-food.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(
                                            kDefaultPadding / 2),
                                        // color: kAccentColor,
                                        width: 240,
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
                                                      const Text(
                                                        "ID 213081",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Food",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: kTextGreyColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: seeDeliveredMessage,
                                                  enableFeedback: true,
                                                  splashColor: kSuccessColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            kDefaultPadding /
                                                                3),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: kGreyColor1,
                                                        strokeAlign: BorderSide
                                                            .strokeAlignInside,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Text(
                                                      "Pending",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: kLoadingColor,
                                                        fontWeight:
                                                            FontWeight.w400,
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
                                                      Icons.my_location,
                                                      color: kAccentColor,
                                                      size: 18,
                                                    ),
                                                    kHalfWidthSizedBox,
                                                    const SizedBox(
                                                      width: 160,
                                                      child: Text(
                                                        "21 Bartus Street, Abuja Nigeria",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                kHalfSizedBox,
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: kAccentColor,
                                                      size: 18,
                                                    ),
                                                    kHalfWidthSizedBox,
                                                    const SizedBox(
                                                      width: 160,
                                                      child: Text(
                                                        "3 Edwins Close, Wuse, Abuja",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  formattedDateAndTime,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
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
                  ],
                );
        }),
      ),
    );
  }
}
