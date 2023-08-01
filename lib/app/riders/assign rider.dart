// ignore_for_file: file_names, unused_local_variable

import 'dart:math';

import 'package:benji_aggregator/app/riders/riders.dart';
import 'package:benji_aggregator/src/common_widgets/my%20appbar.dart';
import 'package:benji_aggregator/src/common_widgets/my%20outlined%20elevatedButton.dart';
import 'package:benji_aggregator/src/providers/custom%20show%20search.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../src/providers/constants.dart';
import 'riders detail.dart';

class AssignRider extends StatefulWidget {
  const AssignRider({super.key});

  @override
  State<AssignRider> createState() => _AssignRiderState();
}

class _AssignRiderState extends State<AssignRider> {
//============================= ALL VARIABLES ===============================\\
  bool isLoading = false;
  bool isAssigned = false;
  String ridersImage = "martins-okafor";
  String ridersName = "Martins Okafor";
  String ridersLocation = "Achara Layout";
  int noOfTrips = 238;
  int ridersPhoneNumber = 8032300044;
//============================= FUNCTIONS ===============================\\
  void toSeeAllRiders() => Get.to(
        () => Riders(
          appBarBackgroundColor: kAccentColor,
          appTitleColor: kPrimaryColor,
          appBarSearchIconColor: kPrimaryColor,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "All Riders",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );
  void toRidersDetailPage() => Get.to(
        () => RidersDetail(
          ridersImage: ridersImage,
          ridersName: ridersName,
          ridersPhoneNumber: ridersPhoneNumber,
          noOfTrips: noOfTrips,
          onlineIndicator: Container(
            height: 20,
            width: 20,
            decoration: const ShapeDecoration(
              color: kSuccessColor,
              shape: OvalBorder(),
            ),
          ),
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Rider Details",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  //Rider Assigned
  void processAssignRider() {
    setState(() {
      isLoading = true;
    });

    // Simulating an asynchronous process
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
        isAssigned = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: MyAppBar(
        title: "Available Riders",
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: Icon(
              color: kAccentColor,
              Icons.search,
            ),
          ),
          TextButton(
            onPressed: toSeeAllRiders,
            child: Text(
              "See all",
              style: TextStyle(
                fontSize: 16,
                color: kAccentColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          kWidthSizedBox,
        ],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(kDefaultPadding),
          children: [
            ListView.builder(
              itemCount: 32,
              addAutomaticKeepAlives: true,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => InkWell(
                onTap: toRidersDetailPage,
                child: Container(
                  width: max(mediaWidth, 374),
                  margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
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
                          Container(
                            height: 45,
                            width: 45,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/rider/$ridersImage.png"),
                              ),
                              shape: const OvalBorder(),
                            ),
                          ),
                          Positioned(
                            right: 5,
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
                      SizedBox(
                        height: 70,
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 140,
                              child: Text(
                                ridersName,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 14,
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
                                  Icons.location_on,
                                  color: kAccentColor,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    ridersLocation,
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
                          ],
                        ),
                      ),
                      isAssigned
                          ? const SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  Text(
                                    "Assigned",
                                    style: TextStyle(),
                                  ),
                                  Icon(
                                    Icons.check,
                                    color: kSuccessColor,
                                  ),
                                ],
                              ),
                            )
                          : isLoading
                              ? SizedBox(
                                  height: 40,
                                  child: SpinKitFadingFour(
                                    color: kAccentColor,
                                  ),
                                )
                              : SizedBox(
                                  width: 90,
                                  child: MyOutlinedElevatedButton(
                                    onPressed: processAssignRider,
                                    circularBorderRadius: 24,
                                    minimumSizeWidth: 80,
                                    minimumSizeHeight: 30,
                                    maximumSizeWidth: 80,
                                    maximumSizeHeight: 30,
                                    buttonTitle: "Assign",
                                    titleFontSize: 12,
                                    elevation: 10.0,
                                  ),
                                )
                    ],
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
