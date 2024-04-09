import 'dart:async';

import 'package:benji_aggregator/app/vendors/my_vendor_detail.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/model/my_vendor_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/providers/constants.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../src/skeletons/vendors_list_skeleton.dart';
import '../../theme/colors.dart';
import '../third_party_vendors.dart/third_party_vendors.dart';
import 'my_vendors.dart';
import 'register_vendor.dart';

class Vendors extends StatefulWidget {
  const Vendors({
    super.key,
  });

  @override
  State<Vendors> createState() => _VendorsState();
}

class _VendorsState extends State<Vendors> with SingleTickerProviderStateMixin {
  //=======================================================================\\
  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await VendorController.instance.getMyVendors();
      await VendorController.instance.getThirdPartyVendors();
    });

    scrollController.addListener(_scrollListener);

    scrollController.addListener(
        () => VendorController.instance.scrollListenerVendor(scrollController));

    scrollController.addListener(() => VendorController.instance
        .scrollListenerThirdPartyVendor(scrollController));
  }

  @override
  void dispose() {
    super.dispose();

    _tabBarController.dispose();

    scrollController.dispose();

    handleRefresh().ignore();
  }

//============================================== ALL VARIABLES =================================================\\
  bool loadingScreen = false;
  bool _isScrollToTopBtnVisible = false;

//============================================== CONTROLLERS =================================================\\
  late TabController _tabBarController;
  final scrollController = ScrollController();

//============================================== FUNCTIONS =================================================\\
  int selectedtabbar = 0;

  void _clickOnTabBarOption(value) async {
    setState(() {
      selectedtabbar = value;
    });
  }

//===================== Handle refresh ==========================\\

  Future<void> handleRefresh() async {
    setState(() {
      loadingScreen = true;
    });
    await VendorController.instance.refreshData();

    setState(() {
      loadingScreen = false;
    });
  }

//============================= Scroll to Top ======================================//
  void scrollToTop() {
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

//===================== Navigation ==========================\\

  void toBusinessDetailPage(MyVendorModel data) => Get.to(
        () => MyVendorDetailPage(vendor: data),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "VendorDetails",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );
  void toAddVendor() => Get.to(
        () => const RegisterVendor(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "RegisterVendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  // void showSearchField() =>
  //     showSearch(context: context, delegate: CustomSearchDelegate());

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: handleRefresh,
      color: kAccentColor,
      child: Scaffold(
        floatingActionButton: _isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: scrollToTop,
                mini: deviceType(media.width) > 2 ? false : true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: FaIcon(
                  FontAwesomeIcons.chevronUp,
                  size: 18,
                  color: kPrimaryColor,
                ),
              )
            : FloatingActionButton(
                onPressed: toAddVendor,
                elevation: 20.0,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Add a vendor",
                backgroundColor: kAccentColor,
                foregroundColor: kPrimaryColor,
                child: const FaIcon(FontAwesomeIcons.plus),
              ),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          title: const Padding(
            padding: EdgeInsets.only(left: kDefaultPadding),
            child: Text(
              "Vendors",
              style: TextStyle(
                fontSize: 20,
                color: kTextBlackColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          actions: const [],
        ),
        body: SafeArea(
          child: GetBuilder<VendorController>(
            builder: (controller) {
              return Scrollbar(
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(kDefaultPadding),
                  children: [
                    loadingScreen
                        ? LinearProgressIndicator(color: kAccentColor)
                        : const SizedBox(),
                    Container(
                      width: media.width,
                      decoration: BoxDecoration(
                        color: kDefaultCategoryBackgroundColor,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: kLightGreyColor,
                          style: BorderStyle.solid,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TabBar(
                              controller: _tabBarController,
                              onTap: (value) => _clickOnTabBarOption(value),
                              splashBorderRadius: BorderRadius.circular(50),
                              enableFeedback: true,
                              mouseCursor: SystemMouseCursors.click,
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: kTransparentColor,
                              automaticIndicatorColorAdjustment: true,
                              labelColor: kPrimaryColor,
                              unselectedLabelColor: kTextGreyColor,
                              indicator: BoxDecoration(
                                color: kAccentColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              tabs: const [
                                Tab(text: "All Vendors"),
                                Tab(text: "Third Party Vendors"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    kSizedBox,
                    loadingScreen
                        ? selectedtabbar == 0
                            ? const VendorsListSkeleton()
                            : const VendorsListSkeleton()
                        : Container(
                            child: selectedtabbar == 0
                                ? const MyVendors()
                                : const ThirdPartyVendors(),
                          ),
                    selectedtabbar == 0
                        ? GetBuilder<VendorController>(
                            builder: (controller) => Column(
                              children: [
                                controller.isLoadMoreVendor.value
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: kAccentColor,
                                        ),
                                      )
                                    : const SizedBox(),
                                controller.loadedAllVendor.value
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                            top: 20, bottom: 20),
                                        height: 5,
                                        width: 5,
                                        decoration: ShapeDecoration(
                                          shape: const CircleBorder(),
                                          color: kPageSkeletonColor,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          )
                        : GetBuilder<VendorController>(
                            builder: (controller) => Column(
                              children: [
                                controller.isLoadMoreMyVendor.value
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: kAccentColor,
                                        ),
                                      )
                                    : const SizedBox(),
                                controller.loadedAllMyVendor.value
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                            top: 20, bottom: 20),
                                        height: 5,
                                        width: 5,
                                        decoration: ShapeDecoration(
                                          shape: const CircleBorder(),
                                          color: kPageSkeletonColor,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
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
