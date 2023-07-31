import 'dart:math';

import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../src/providers/constants.dart';
import '../../src/providers/custom show search.dart';

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

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    void showSearchField() {
      showSearch(context: context, delegate: CustomSearchDelegate());
    }

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        backgroundColor: widget.appBarBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(
            left: kDefaultPadding,
          ),
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
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
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
                          : kDefaultCategoryBackrgoundColor,
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
                          ? kDefaultCategoryBackrgoundColor
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
