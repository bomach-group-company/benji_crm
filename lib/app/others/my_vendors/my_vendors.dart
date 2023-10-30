import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/src/skeletons/vendors_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../../src/components/appbar/my_appbar.dart';
import '../../../src/components/section/my_liquid_refresh.dart';
import '../../../src/responsive/responsive_constant.dart';
import '../../../theme/colors.dart';
import 'my_vendor_detail.dart';

class MyVendors extends StatefulWidget {
  const MyVendors({super.key});

  @override
  State<MyVendors> createState() => _MyVendorsState();
}

class _MyVendorsState extends State<MyVendors> {
  //=======================================================================\\
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
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
    scrollController.dispose();

    super.dispose();
  }

//=========================================================================\\

  //=================================== ALL VARIABLES ====================================\\
  final int _numberOfVendors = 10;
  final String _vendorName = "Ntachi Osa";
  final String _vendorImage = "ntachi-osa";
  final String _vendorRating = "4.6";
  final String _vendorAddress = "No 450 Ogui Rd, Enugu";
  final String _totalNumberOfUsersRating = intFormattedText(2000);
  final String _vendorActiveStatus = "Online";
  final Color _vendorActiveStatusColor = kSuccessColor;

  //===================== BOOL VALUES =======================\\
  bool _isScrollToTopBtnVisible = false;
  late bool _loadingScreen;

  //=================================== CONTROLLERS ====================================\\
  final ScrollController scrollController = ScrollController();

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

  //============================= Scroll to Top ======================================//
  void _scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void _scrollListener() {
    //========= Show action button ========//
    if (scrollController.position.pixels >= 100) {
      setState(() => _isScrollToTopBtnVisible = true);
    }
    //========= Hide action button ========//
    else if (scrollController.position.pixels < 100) {
      setState(() => _isScrollToTopBtnVisible = false);
    }
  }

  void _seeMoreVendors() {}

  //============================================= Navigation ======================================================\\
  void _toMyVendorDetailsPage() => Get.to(
        () => MyVendorDetailsPage(
          vendorCoverImage: _vendorImage,
          vendorName: _vendorName,
          vendorRating: _vendorRating,
          vendorAddress: _vendorAddress,
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
    final media = MediaQuery.of(context).size;
    return MyLiquidRefresh(
      onRefresh: _handleRefresh,
      child: Scaffold(
        floatingActionButton: _isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: _scrollToTop,
                mini: deviceType(media.width) > 2 ? false : true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: const FaIcon(FontAwesomeIcons.chevronUp, size: 18),
              )
            : const SizedBox(),
        appBar: MyAppBar(
          title: "My Vendors",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: null,
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
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView(
                        controller: scrollController,
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
                                  physics: const ScrollPhysics(
                                      parent: BouncingScrollPhysics()),
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
                                                  width: media.width - 250,
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
                                                kHalfSizedBox,
                                                SizedBox(
                                                  width: media.width - 250,
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
                                                kHalfSizedBox,
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons
                                                          .solidStar,
                                                      size: 18,
                                                      color: kStarColor,
                                                    ),
                                                    SizedBox(
                                                      width: media.width - 250,
                                                      child: Text(
                                                        "$_vendorRating ($_totalNumberOfUsersRating)",
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
