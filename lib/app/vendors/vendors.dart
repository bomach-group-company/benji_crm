import 'dart:async';

import 'package:benji_aggregator/app/vendors/my_vendor_detail.dart';
import 'package:benji_aggregator/app/vendors/my_vendors.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/model/my_vendor_model.dart';
import 'package:benji_aggregator/src/components/container/myvendor_container.dart';
import 'package:benji_aggregator/src/components/section/my_liquid_refresh.dart';
import 'package:benji_aggregator/src/skeletons/vendors_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/providers/constants.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../theme/colors.dart';
import 'register_vendor.dart';

class Vendors extends StatefulWidget {
  final VoidCallback showNavigation;
  final VoidCallback hideNavigation;
  const Vendors({
    required this.showNavigation,
    required this.hideNavigation,
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
    scrollController.addListener(_scrollListener);

    _tabBarController = TabController(length: 2, vsync: this);
    scrollController.addListener(() =>
        VendorController.instance.scrollListenerMyVendor(scrollController));
    VendorController.instance.getMyVendors();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward ||
          scrollController.position.pixels < 100) {
        widget.showNavigation();
      } else {
        widget.hideNavigation();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _animationController.dispose();
    _tabBarController.dispose();

    scrollController.dispose();
    scrollController.removeListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavigation();
      } else {
        widget.hideNavigation();
      }
    });
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
    await VendorController.instance.getMyVendors();
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
    return MyLiquidRefresh(
      onRefresh: handleRefresh,
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
              "My Vendors",
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
                    Padding(
                      padding: deviceType(media.width) > 2
                          ? const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding * 6)
                          : const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding * 1.5),
                      child: Container(
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
                                  Tab(text: "My Vendors"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    kSizedBox,
                    loadingScreen
                        ? Center(
                            child: CircularProgressIndicator(
                              color: kAccentColor,
                            ),
                          )
                        : Container(
                            padding: deviceType(media.width) > 2
                                ? const EdgeInsets.symmetric(horizontal: 20)
                                : const EdgeInsets.symmetric(horizontal: 10),
                            child: selectedtabbar == 0
                                ? const SizedBox()
                                : const MyVendors(),
                          ),
                    loadingScreen
                        ? const VendorsListSkeleton()
                        : controller.isLoad.value &&
                                controller.vendorMyList.isEmpty
                            ? const VendorsListSkeleton()
                            : ListView.separated(
                                separatorBuilder: (context, index) =>
                                    kHalfSizedBox,
                                itemCount: controller.vendorMyList.length,
                                addAutomaticKeepAlives: true,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    decoration: ShapeDecoration(
                                      color: kPrimaryColor,
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
                                    child: MyVendorContainer(
                                      onTap: () => toBusinessDetailPage(
                                        controller.vendorMyList[index],
                                      ),
                                      vendor: controller.vendorMyList[index],
                                    ),
                                  ),
                                ),
                              ),
                    kSizedBox,
                    GetBuilder<VendorController>(
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
                                  height: 10,
                                  width: 10,
                                  decoration: ShapeDecoration(
                                      shape: const CircleBorder(),
                                      color: kPageSkeletonColor),
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
