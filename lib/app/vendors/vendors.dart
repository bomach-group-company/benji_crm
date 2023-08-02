// ignore_for_file: unused_local_variable

import 'package:benji_aggregator/app/vendors/vendors_detail.dart';
import 'package:benji_aggregator/src/common_widgets/my_outlined_elevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../src/providers/constants.dart';
import '../../src/providers/custom show search.dart';
import '../../theme/colors.dart';
import 'add_vendor.dart';

class Vendors extends StatefulWidget {
  final Color appBarBackgroundColor;
  final Color appTitleColor;
  final Color appBarSearchIconColor;

  const Vendors({
    super.key,
    required this.appBarBackgroundColor,
    required this.appTitleColor,
    required this.appBarSearchIconColor,
  });

  @override
  State<Vendors> createState() => _VendorsState();
}

class _VendorsState extends State<Vendors> {
//============================================== ALL VARIABLES =================================================\\
  bool vendorStatus = true;
  bool isLoading = false;
  String onlineVendorsName = "Ntachi Osa";
  String onlineVendorsImage = "ntachi-osa";

  String offlineVendorsName = "Best Choice Restaurant";
  String offlineVendorsImage = "best-choice-restaurant";
  int lastSeenCount = 20;
  String lastSeenMessage = "minutes ago";

//============================================== FUNCTIONS =================================================\\
  void clickOnlineVendors() async {
    setState(() {
      isLoading = true;
      vendorStatus = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isLoading = false;
    });
  }

  void clickOfflineVendors() async {
    setState(() {
      isLoading = true;
      vendorStatus = false;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isLoading = false;
    });
  }

  toAddVendorPage() => Get.to(
        () => const AddVendor(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Add vendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void toVendorDetailsPage() => Get.to(
        () => const VendorsDetailPage(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Vendor Details",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void showSearchField() =>
      showSearch(context: context, delegate: CustomSearchDelegate());
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        backgroundColor: widget.appBarBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: Text(
            "All Vendors",
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
            tooltip: "Search for a vendor",
            icon: Icon(
              Icons.search_rounded,
              color: widget.appBarSearchIconColor,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: MyOutlinedElevatedButton(
              onPressed: toAddVendorPage,
              circularBorderRadius: 20,
              minimumSizeWidth: 100,
              minimumSizeHeight: 30,
              maximumSizeWidth: 100,
              maximumSizeHeight: 30,
              buttonTitle: "Add Vendor",
              titleFontSize: 12,
              elevation: 10.0,
            ),
          ),
        ],
        elevation: 0.0,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(kDefaultPadding),
          children: [
            SizedBox(
              width: mediaWidth,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: clickOnlineVendors,
                    onLongPress: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vendorStatus
                          ? kAccentColor
                          : kDefaultCategoryBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Online Vendors",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        color: vendorStatus ? kTextWhiteColor : kTextGreyColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  kWidthSizedBox,
                  ElevatedButton(
                    onPressed: clickOfflineVendors,
                    onLongPress: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vendorStatus
                          ? kDefaultCategoryBackgroundColor
                          : kAccentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Offline Vendors",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        color: vendorStatus ? kTextGreyColor : kTextWhiteColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            kSizedBox,
            isLoading
                ? Center(child: SpinKitFadingFour(color: kAccentColor))
                : vendorStatus
                    ? ListView.builder(
                        itemCount: 248,
                        addAutomaticKeepAlives: true,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => InkWell(
                          onTap: toVendorDetailsPage,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 10,
                            ),
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
                                  width: 130,
                                  height: 130,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/vendors/$onlineVendorsImage.png",
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                kHalfWidthSizedBox,
                                Container(
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding / 2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          onlineVendorsName,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.36,
                                          ),
                                        ),
                                      ),
                                      kSizedBox,
                                      SizedBox(
                                        width: 200,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Restaurant",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(
                                                  0x662F2E3C,
                                                ),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              width: 3.90,
                                              height: 3.90,
                                              decoration: const ShapeDecoration(
                                                color: Color(0x662F2E3C),
                                                shape: OvalBorder(),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8.0,
                                            ),
                                            const Text(
                                              "Food",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0x662F2E3C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 3.90,
                                            height: 3.90,
                                            decoration: const ShapeDecoration(
                                              color: kSuccessColor,
                                              shape: OvalBorder(),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          const Text(
                                            "Online",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: kSuccessColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      kSizedBox,
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Icon(
                                              Icons.star_rounded,
                                              color: kAccentColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: kDefaultPadding / 2,
                                          ),
                                          Container(
                                            width: 81,
                                            height: 19,
                                            padding: const EdgeInsets.only(
                                              top: 4,
                                            ),
                                            child: const Text(
                                              "4.6 (500+)",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: -0.24,
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
                      )
                    : ListView.builder(
                        itemCount: 142,
                        addAutomaticKeepAlives: true,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => InkWell(
                          onTap: toVendorDetailsPage,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
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
                                  width: 130,
                                  height: 130,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/vendors/$offlineVendorsImage.png",
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                kHalfWidthSizedBox,
                                Container(
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding / 2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          offlineVendorsName,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.36,
                                          ),
                                        ),
                                      ),
                                      kSizedBox,
                                      SizedBox(
                                        width: 200,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Restaurant",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(
                                                  0x662F2E3C,
                                                ),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              width: 3.90,
                                              height: 3.90,
                                              decoration: const ShapeDecoration(
                                                color: Color(0x662F2E3C),
                                                shape: OvalBorder(),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8.0,
                                            ),
                                            const Text(
                                              "Fast Food",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0x662F2E3C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
                                            width: 180,
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
                                      kSizedBox,
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Icon(
                                              Icons.star_rounded,
                                              color: kAccentColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: kDefaultPadding / 2,
                                          ),
                                          Container(
                                            width: 81,
                                            height: 19,
                                            padding: const EdgeInsets.only(
                                              top: 4,
                                            ),
                                            child: const Text(
                                              "4.0 (500+)",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: -0.24,
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
            kSizedBox,
          ],
        ),
      ),
    );
  }
}
