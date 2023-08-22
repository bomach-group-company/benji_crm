// ignore_for_file: unused_local_variable, unused_field

import 'package:benji_aggregator/app/others/add_vendor/add_vendor.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../src/common_widgets/my_outlined_elevatedButton.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/custom_show_search.dart';
import '../../src/skeletons/all_vendors_page_skeleton.dart';
import '../../src/skeletons/vendors_list_skeleton.dart';
import '../../theme/colors.dart';
import '../others/my_vendors/my_vendors.dart';
import 'vendor_details.dart';

class Vendors extends StatefulWidget {
  final VoidCallback showNavigation;
  final VoidCallback hideNavigation;
  final Color appBarBackgroundColor;
  final Color appTitleColor;
  final Color appBarSearchIconColor;

  const Vendors({
    super.key,
    required this.appBarBackgroundColor,
    required this.appTitleColor,
    required this.appBarSearchIconColor,
    required this.showNavigation,
    required this.hideNavigation,
  });

  @override
  State<Vendors> createState() => _VendorsState();
}

class _VendorsState extends State<Vendors> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    VendorController.instance.runTask();

    // _animationController =
    //     AnimationController(vsync: this, duration: const Duration(seconds: 1));
    // _scrollController.addListener(_scrollListener);
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavigation();
      } else {
        widget.hideNavigation();
      }
    });
    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _animationController.dispose();
    _scrollController.dispose();

    _scrollController.removeListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavigation();
      } else {
        widget.hideNavigation();
      }
    });
  }

//============================================== ALL VARIABLES =================================================\\
  late bool _loadingScreen;
  bool _vendorStatus = true;
  bool _isLoadingVendorStatus = false;
  // bool _isScrollToTopBtnVisible = false;

  //Online Vendors
  final String _onlineVendorsName = "Ntachi Osa";
  final String _onlineVendorsImage = "ntachi-osa";
  final double _onlineVendorsRating = 4.6;
  final int _numberOfOnlineVendors = 15;

  final String _vendorActive = "Online";
  final String _vendorInactive = "Offline";
  final Color _vendorActiveColor = kSuccessColor;
  final Color _vendorInactiveColor = kAccentColor;

  //Offline Vendors
  final String _offlineVendorsName = "Best Choice Restaurant";
  final String _offlineVendorsImage = "best-choice-restaurant";
  final double _offlineVendorsRating = 4.0;
  final int _lastSeenCount = 20;
  final String _lastSeenMessage = "minutes ago";
  final int _noOfOfflineVendors = 15;

//============================================== CONTROLLERS =================================================\\
  final ScrollController _scrollController = ScrollController();
  // late AnimationController _animationController;

//============================================== FUNCTIONS =================================================\\

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

// //============================= Scroll to Top ======================================//
//   void _scrollToTop() {
//     _animationController.reverse();
//     _scrollController.animateTo(0,
//         duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
//   }

//   void _scrollListener() {
//     //========= Show action button ========//
//     if (_scrollController.position.pixels >= 200) {
//       _animationController.forward();
//       setState(() => _isScrollToTopBtnVisible = true);
//     }
//     //========= Hide action button ========//
//     else if (_scrollController.position.pixels < 200) {
//       _animationController.reverse();
//       setState(() => _isScrollToTopBtnVisible = true);
//     }
//   }

//===================== Handle Vendor Status ==========================\\
  void _clickOnlineVendors() async {
    setState(() {
      _isLoadingVendorStatus = true;
      _vendorStatus = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoadingVendorStatus = false;
    });
  }

  void _clickOfflineVendors() async {
    setState(() {
      _isLoadingVendorStatus = true;
      _vendorStatus = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoadingVendorStatus = false;
    });
  }

//=============================== See more ========================================\\
  void _seeMoreOnlineVendors() {}
  void _seeMoreOfflineVendors() {}

//===================== Navigation ==========================\\

  void _toAddVendor() => Get.to(
        () => const AddVendor(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Add vendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _toMyVendorsPage() => Get.to(
        () => const MyVendors(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "My vendors",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _toVendorDetailsPage() => Get.to(
        () => VendorDetailsPage(
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
        routeName: "Vendor details",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _showSearchField() =>
      showSearch(context: context, delegate: CustomSearchDelegate());
  @override
  Widget build(BuildContext context) {
    //============================ MediaQuery Size ===============================\\
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
        floatingActionButton: FloatingActionButton(
          onPressed: _toAddVendor,
          elevation: 20.0,
          mouseCursor: SystemMouseCursors.click,
          tooltip: "Add a vendor",
          backgroundColor: kAccentColor,
          foregroundColor: kPrimaryColor,
          child: const Icon(
            Icons.add,
          ),
        ),
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
              onPressed: _showSearchField,
              tooltip: "Search for a vendor",
              icon: Icon(
                Icons.search_rounded,
                color: widget.appBarSearchIconColor,
                size: 24,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              child: MyOutlinedElevatedButton(
                onPressed: _toMyVendorsPage,
                circularBorderRadius: 20,
                minimumSizeWidth: 100,
                minimumSizeHeight: 30,
                maximumSizeWidth: 100,
                maximumSizeHeight: 30,
                buttonTitle: "My Vendors",
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
          child: GetBuilder<VendorController>(
            init: VendorController(),
            builder: (controller) {
              return controller.isLoad.value
                  ? const AllVendorsPageSkeleton()
                  : Scrollbar(
                      controller: _scrollController,
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          kDefaultPadding,
                          0,
                          kDefaultPadding,
                          kDefaultPadding,
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
                                kHalfWidthSizedBox,
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
                          controller.isLoad.value
                              ? const VendorsListSkeleton()
                              : ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                          height: kDefaultPadding / 2),
                                  itemCount: controller.vendorList.length,
                                  addAutomaticKeepAlives: true,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: _toVendorDetailsPage,
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
                                              color: kPageSkeletonColor,
                                              // image: DecorationImage(
                                              //   image: AssetImage(
                                              //     "assets/images/vendors/$_onlineVendorsImage.png",
                                              //   ),
                                              //   fit: BoxFit.fill,
                                              // ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: "",
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                  color: kRedColor,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                Icons.error,
                                                color: kRedColor,
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
                                                  width: mediaWidth - 200,
                                                  child: Text(
                                                    controller.vendorList[index]
                                                        .username!,
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
                                                  width: mediaWidth - 200,
                                                  child: Text(
                                                    "Restaurant",
                                                    style: TextStyle(
                                                      color: kTextGreyColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
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
                                                      width: 25,
                                                      height: 25,
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
                                                          color:
                                                              kTextBlackColor,
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
                          kSizedBox,
                          kSizedBox,
                          _vendorStatus
                              ? TextButton(
                                  onPressed: _seeMoreOnlineVendors,
                                  child: Text(
                                    "See more",
                                    style: TextStyle(color: kAccentColor),
                                  ),
                                )
                              : TextButton(
                                  onPressed: _seeMoreOfflineVendors,
                                  child: Text(
                                    "See more",
                                    style: TextStyle(color: kAccentColor),
                                  ),
                                ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
