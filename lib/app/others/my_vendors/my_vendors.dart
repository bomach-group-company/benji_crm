import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/src/skeletons/vendors_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../src/common_widgets/my_appbar.dart';
import '../../../theme/colors.dart';
import 'my_vendor_detail.dart';

class MyVendors extends StatefulWidget {
  const MyVendors({super.key});

  @override
  State<MyVendors> createState() => _MyVendorsState();
}

class _MyVendorsState extends State<MyVendors> {
  //=================================== ALL VARIABLES ====================================\\
  final int _numberOfVendors = 10;
  final String _vendorName = "Ntachi Osa";
  final String _vendorImage = "ntachi-osa";
  final double _vendorRating = 4.6;

  final String _vendorActiveStatus = "Online";
  final Color _vendorActiveStatusColor = kSuccessColor;

  //===================== BOOL VALUES =======================\\
  late bool _loadingScreen;

  //=================================== CONTROLLERS ====================================\\
  final ScrollController _scrollController = ScrollController();

//==========================================================================================\\
  @override
  void initState() {
    super.initState();

    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

//==========================================================================================\\

  //============================================= FUNCTIONS ===============================================\\

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _loadingScreen = false;
    });
  }
  //==========================================================================\\

  void _seeMoreVendors() {}

  //============================================= Navigation ======================================================\\
  void _toMyVendorDetailsPage() => Get.to(
        () => MyVendorDetailsPage(
          vendorCoverImage: _vendorImage,
          vendorName: _vendorName,
          vendorRating: _vendorRating,
          vendorActiveStatus: _vendorActiveStatus,
          vendorActiveStatusColor: _vendorActiveStatusColor,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Vendor details",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: kAccentColor,
      borderWidth: 5.0,
      backgroundColor: kPrimaryColor,
      height: 150,
      animSpeedFactor: 2,
      showChildOpacityTransition: false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: "My Vendors",
          elevation: 10.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        body: SafeArea(
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const VendorsListSkeleton();
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
                  ? const Padding(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: VendorsListSkeleton(),
                    )
                  : Scrollbar(
                      controller: _scrollController,
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(kDefaultPadding),
                        children: [
                          _loadingScreen
                              ? const VendorsListSkeleton()
                              : ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                          height: kDefaultPadding / 2),
                                  itemCount: _numberOfVendors,
                                  addAutomaticKeepAlives: true,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: _toMyVendorDetailsPage,
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
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/vendors/$_vendorImage.png",
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
                                                    _vendorName,
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
                                                            _vendorActiveStatusColor,
                                                        shape:
                                                            const OvalBorder(),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5.0),
                                                    Text(
                                                      _vendorActiveStatus,
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
                                                        "$_vendorRating (500+)",
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
                          kSizedBox,
                          TextButton(
                            onPressed: _seeMoreVendors,
                            child: Text(
                              "See more",
                              style: TextStyle(color: kAccentColor),
                            ),
                          )
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
