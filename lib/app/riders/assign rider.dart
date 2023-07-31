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

class AssignRider extends StatefulWidget {
  const AssignRider({super.key});

  @override
  State<AssignRider> createState() => _AssignRiderState();
}

class _AssignRiderState extends State<AssignRider> {
//============================= ALL VARIABLES ===============================\\
  bool isLoading = false;
  bool isAssigned = false;
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
            SizedBox(
              // height: mediaHeight - 120,
              child: ListView.builder(
                itemCount: 32,
                itemExtent: 90,
                addAutomaticKeepAlives: true,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => Container(
                  width: max(mediaWidth, 374),
                  margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
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
                            decoration: const ShapeDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/rider/martins-okafor.png"),
                              ),
                              shape: OvalBorder(),
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
                            const SizedBox(
                              width: 140,
                              child: Text(
                                "Jerry Emmanuel",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
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
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    "Achara Layout",
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
