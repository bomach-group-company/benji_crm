import 'dart:async';

import 'package:benji_aggregator/app/my_vendors/my_vendor_detail.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/model/my_vendor_model.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/container/myvendor_container.dart';
import 'package:benji_aggregator/src/components/section/my_liquid_refresh.dart';
import 'package:benji_aggregator/src/skeletons/vendors_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/providers/constants.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../theme/colors.dart';
import '../add_vendor/add_third_party_vendor.dart';

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
    scrollController.addListener(() =>
        VendorController.instance.scrollListenerMyVendor(scrollController));
  }

  @override
  void dispose() {
    super.dispose();
    // _animationController.dispose();
    scrollController.dispose();
    handleRefresh().ignore();
  }

//============================================== ALL VARIABLES =================================================\\
  bool loadingScreen = false;
  bool _isScrollToTopBtnVisible = false;

//============================================== CONTROLLERS =================================================\\
  final scrollController = ScrollController();

//============================================== FUNCTIONS =================================================\\

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

//===================== Navigation ==========================\\

  void toVendorDetailsPage(MyVendorModel data) => Get.to(
        () => MyVendorDetailsPage(vendor: data),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "VendorDetails",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );
  void addThirdPartyVendor() => Get.to(
        () => const AddThirdPartyVendor(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "AddThirdPartyVendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  // void toMyVendorsPage() => Get.to(
  //       () => const MyVendors(),
  //       duration: const Duration(milliseconds: 300),
  //       fullscreenDialog: true,
  //       curve: Curves.easeIn,
  //       routeName: "MyVendors",
  //       preventDuplicates: true,
  //       popGesture: true,
  //       transition: Transition.downToUp,
  //     );

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
                onPressed: _scrollToTop,
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
            : const SizedBox(),
        appBar: MyAppBar(
          title: "My Vendors",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
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
                    kSizedBox,
                    loadingScreen
                        ? const VendorsListSkeleton()
                        : controller.isLoad.value &&
                                controller.vendorMyList.isEmpty
                            ? const VendorsListSkeleton()
                            : ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: kDefaultPadding / 2),
                                itemCount: controller.vendorMyList.length,
                                addAutomaticKeepAlives: true,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => InkWell(
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
                                      child: MyVendorContainer(
                                        onTap: () => toVendorDetailsPage(
                                            controller.vendorMyList[index]),
                                        vendor: controller.vendorMyList[index],
                                      )),
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
