// ignorFontWeight_for_file: unused_local_variable,

// ignore_for_file: unused_local_variable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../src/providers/constants.dart';
import '../../src/providers/custom show search.dart';
import '../../theme/colors.dart';
import 'riders_detail.dart';

class Riders extends StatefulWidget {
  final Color appBarBackgroundColor;
  final Color appTitleColor;
  final Color appBarSearchIconColor;
  const Riders({
    super.key,
    required this.appBarBackgroundColor,
    required this.appTitleColor,
    required this.appBarSearchIconColor,
  });

  @override
  State<Riders> createState() => _RidersState();
}

class _RidersState extends State<Riders> {
  //================================= ALL VARIABLES ==========================================\\
  bool riderStatus = true;
  bool isLoading = false;
  String onlineRidersImage = "jerry-emmanuel";
  String onlineRidersName = "Jerry Emmanuel";
  String onlineRidersLocation = "Achara Layout";
  int onlineRidersNoOfTrips = 238;
  int onlineRidersPhoneNumber = 8032300044;
  String offlineRidersName = "Martins Okafor";
  String offlineRidersImage = "martins-okafor";
  int offlineRidersPhoneNumber = 8032300253;
  int lastSeenCount = 20;
  String lastSeenMessage = "minutes ago";
  int offlineRiderNoOfTrips = 221;

  //================================= FUNCTIONS ==========================================\\
  void clickOnlineRiders() async {
    setState(() {
      isLoading = true;
      riderStatus = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isLoading = false;
    });
  }

  void clickOfflineRiders() async {
    setState(() {
      isLoading = true;
      riderStatus = false;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isLoading = false;
    });
  }

  void toRidersDetailPage() => Get.to(
        () => RidersDetail(
          ridersImage: riderStatus ? onlineRidersImage : offlineRidersImage,
          ridersName: riderStatus ? onlineRidersName : offlineRidersName,
          ridersPhoneNumber:
              riderStatus ? onlineRidersPhoneNumber : offlineRidersPhoneNumber,
          noOfTrips:
              riderStatus ? onlineRidersNoOfTrips : offlineRiderNoOfTrips,
          onlineIndicator: riderStatus
              ? Container(
                  height: 20,
                  width: 20,
                  decoration: const ShapeDecoration(
                    color: kSuccessColor,
                    shape: OvalBorder(),
                  ),
                )
              : Container(),
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Rider Details",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    void showSearchField() =>
        showSearch(context: context, delegate: CustomSearchDelegate());

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        backgroundColor: widget.appBarBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: Text(
            "All Riders",
            style: TextStyle(
              fontSize: 20,
              color: widget.appTitleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: showSearchField,
            tooltip: "Search",
            icon: Icon(
              Icons.search_rounded,
              color: widget.appBarSearchIconColor,
              size: 30,
            ),
          ),
        ],
        elevation: 0.0,
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: ListView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(kDefaultPadding),
          children: [
            SizedBox(
              width: mediaWidth,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: clickOnlineRiders,
                    onLongPress: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: riderStatus
                          ? kAccentColor
                          : kDefaultCategoryBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Online Riders",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        color: riderStatus ? kTextWhiteColor : kTextGreyColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  kWidthSizedBox,
                  ElevatedButton(
                    onPressed: clickOfflineRiders,
                    onLongPress: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: riderStatus
                          ? kDefaultCategoryBackgroundColor
                          : kAccentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Offline Riders",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        color: riderStatus ? kTextGreyColor : kTextWhiteColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kDefaultPadding * 2),
            isLoading
                ? Center(child: SpinKitFadingFour(color: kAccentColor))
                : riderStatus
                    ? ListView.builder(
                        itemCount: 32,
                        addAutomaticKeepAlives: true,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => InkWell(
                          onTap: toRidersDetailPage,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: max(mediaWidth, 374),
                            margin: const EdgeInsets.only(
                                bottom: kDefaultPadding / 2),
                            padding: const EdgeInsets.all(kDefaultPadding / 2),
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
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                        "assets/images/rider/$onlineRidersImage.png",
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      bottom: 0,
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        decoration: const ShapeDecoration(
                                          color: kSuccessColor,
                                          shape: OvalBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: kDefaultPadding),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          onlineRidersName,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 14,
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
                                            Icons.location_on,
                                            color: kAccentColor,
                                            size: 18,
                                          ),
                                          kHalfWidthSizedBox,
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              onlineRidersLocation,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: kTextGreyColor,
                                                fontWeight: FontWeight.w400,
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
                                            width: 200,
                                            child: Text(
                                              "$onlineRidersNoOfTrips Trips Completed",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: kTextGreyColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        // height: mediaHeight - 120,
                        child: ListView.builder(
                          itemCount: 32,
                          addAutomaticKeepAlives: true,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => InkWell(
                            onTap: toRidersDetailPage,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: max(mediaWidth, 374),
                              margin: const EdgeInsets.only(
                                  bottom: kDefaultPadding / 2),
                              padding:
                                  const EdgeInsets.all(kDefaultPadding / 2),
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
                                      Container(
                                        height: 45,
                                        width: 45,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                              "assets/images/rider/$offlineRidersImage.png",
                                            ),
                                          ),
                                          shape: const OvalBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            offlineRidersName,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 14,
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
                                              Icons.visibility,
                                              color: kAccentColor,
                                              size: 18,
                                            ),
                                            kHalfWidthSizedBox,
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                "Last seen $lastSeenCount $lastSeenMessage",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: kAccentColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                                              width: 200,
                                              child: Text(
                                                "$offlineRiderNoOfTrips Trips Completed",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: kTextGreyColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
