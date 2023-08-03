// ignore_for_file: unused_local_variable

import 'package:benji_aggregator/app/vendors/vendors_detail.dart';
import 'package:benji_aggregator/src/common_widgets/my_outlined_elevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../src/providers/constants.dart';
import '../../src/providers/custom show search.dart';
import '../../src/skeletons/all_vendors_list_skeleton.dart';
import '../../src/skeletons/all_vendors_page_skeleton.dart';
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
  late bool _loadingScreen;
  bool _vendorStatus = true;
  bool _isLoadingVendorStatus = false;
  final String _onlineVendorsName = "Ntachi Osa";
  final String _onlineVendorsImage = "ntachi-osa";
  final double _onlineVendorsRating = 4.6;

  final String _vendorActive = "Online";
  final String _vendorInactive = "Offline";
  final Color _vendorActiveColor = kSuccessColor;
  final Color _vendorInactiveColor = kAccentColor;

  final String _offlineVendorsName = "Best Choice Restaurant";
  final String _offlineVendorsImage = "best-choice-restaurant";
  final double _offlineVendorsRating = 4.0;
  final int _lastSeenCount = 20;
  final String _lastSeenMessage = "minutes ago";
  final int _numberOfVendors = 30;

//============================================== FUNCTIONS =================================================\\

  @override
  void initState() {
    _loadingScreen = true;
    Future.delayed(
      const Duration(seconds: 3),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
    super.initState();
  }

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _loadingScreen = false;
    });
  }

//===================== Handle Vendor Status ==========================\\
  void _clickOnlineVendors() async {
    setState(() {
      _isLoadingVendorStatus = true;
      _vendorStatus = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoadingVendorStatus = false;
    });
  }

  void _clickOfflineVendors() async {
    setState(() {
      _isLoadingVendorStatus = true;
      _vendorStatus = false;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoadingVendorStatus = false;
    });
  }

//===================== Navigation ==========================\\

  void toAddVendorPage() => Get.to(
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
        () => VendorsDetailPage(
          vendorCoverImage:
              _vendorStatus ? _onlineVendorsImage : _offlineVendorsImage,
          vendorName: _vendorStatus ? _onlineVendorsName : _offlineVendorsName,
          vendorRating:
              _vendorStatus ? _onlineVendorsRating : _offlineVendorsRating,
          vendorActiveStatus: _vendorStatus ? _vendorActive : _vendorInactive,
          vendorActiveStatusColor:
              _vendorStatus ? _vendorActiveColor : _vendorInactiveColor,
        ),
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
    double mediaHeight = MediaQuery.of(context).size.height;

    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: kAccentColor,
      borderWidth: 5.0,
      backgroundColor: kPrimaryColor,
      height: 150,
      animSpeedFactor: 2,
      showChildOpacityTransition: false,
      child: Scaffold(
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
          child: FutureBuilder(builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              const AllVendorsPageSkeleton();
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
                ? const AllVendorsPageSkeleton()
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      bottom: kDefaultPadding,
                      right: kDefaultPadding,
                      left: kDefaultPadding,
                    ),
                    children: [
                      SizedBox(
                        width: mediaWidth,
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: _clickOnlineVendors,
                              onLongPress: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _vendorStatus
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
                                  color: _vendorStatus
                                      ? kTextWhiteColor
                                      : kTextGreyColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            kWidthSizedBox,
                            ElevatedButton(
                              onPressed: _clickOfflineVendors,
                              onLongPress: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _vendorStatus
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
                                  color: _vendorStatus
                                      ? kTextGreyColor
                                      : kTextWhiteColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      kSizedBox,
                      _isLoadingVendorStatus
                          ? const AllVendorsListSkeleton()
                          : _vendorStatus
                              ? ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                          height: kDefaultPadding / 2),
                                  itemCount: _numberOfVendors,
                                  addAutomaticKeepAlives: true,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: toVendorDetailsPage,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
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
                                            width: 130,
                                            height: 130,
                                            decoration: ShapeDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/vendors/$_onlineVendorsImage.png",
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                          kHalfWidthSizedBox,
                                          Container(
                                            padding: const EdgeInsets.all(
                                                kDefaultPadding / 2),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    _onlineVendorsName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      color: kBlackColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: -0.36,
                                                    ),
                                                  ),
                                                ),
                                                kSizedBox,
                                                SizedBox(
                                                  width: 200,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        "Restaurant",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Color(
                                                            0x662F2E3C,
                                                          ),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        width: 3.90,
                                                        height: 3.90,
                                                        decoration:
                                                            const ShapeDecoration(
                                                          color:
                                                              Color(0x662F2E3C),
                                                          shape: OvalBorder(),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 8.0,
                                                      ),
                                                      const Text(
                                                        "Food",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0x662F2E3C),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
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
                                                      decoration:
                                                          ShapeDecoration(
                                                        color:
                                                            _vendorActiveColor,
                                                        shape:
                                                            const OvalBorder(),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5.0),
                                                    Text(
                                                      _vendorActive,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: kSuccessColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                kSizedBox,
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                        color: kStarColor,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width: kDefaultPadding /
                                                            2),
                                                    Container(
                                                      width: 81,
                                                      height: 19,
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 4,
                                                      ),
                                                      child: Text(
                                                        "$_onlineVendorsRating (500+)",
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
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
                              : ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                          height: kDefaultPadding / 2),
                                  itemCount: 142,
                                  addAutomaticKeepAlives: true,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: toVendorDetailsPage,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
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
                                            width: 130,
                                            height: 130,
                                            decoration: ShapeDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/vendors/$_offlineVendorsImage.png",
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                          kHalfWidthSizedBox,
                                          Container(
                                            padding: const EdgeInsets.all(
                                                kDefaultPadding / 2),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    _offlineVendorsName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: -0.36,
                                                    ),
                                                  ),
                                                ),
                                                kSizedBox,
                                                SizedBox(
                                                  width: 200,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        "Restaurant",
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: Color(
                                                            0x662F2E3C,
                                                          ),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        width: 3.90,
                                                        height: 3.90,
                                                        decoration:
                                                            const ShapeDecoration(
                                                          color:
                                                              Color(0x662F2E3C),
                                                          shape: OvalBorder(),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 8.0,
                                                      ),
                                                      const Text(
                                                        "Fast Food",
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0x662F2E3C),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
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
                                                        "Last seen $_lastSeenCount $_lastSeenMessage",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: kAccentColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                kSizedBox,
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                      width:
                                                          kDefaultPadding / 2,
                                                    ),
                                                    Container(
                                                      width: 81,
                                                      height: 19,
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 4,
                                                      ),
                                                      child: Text(
                                                        "$_offlineVendorsRating (500+)",
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
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
                    ],
                  );
          }),
        ),
      ),
    );
  }
}
