// ignore_for_file: unused_local_variable, unused_field

import 'dart:async';

import 'package:benji_aggregator/app/add_vendor/add_vendor.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/model/vendor_model.dart';
import 'package:benji_aggregator/src/components/container/vendors_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/components/button/my_outlined_elevatedButton.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/custom_show_search.dart';
import '../../src/skeletons/vendors_list_skeleton.dart';
import '../../theme/colors.dart';
import '../my_vendors/my_vendors.dart';
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
    scrollController.dispose();
    _timer.cancel();
    scrollController.removeListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavigation();
      } else {
        widget.hideNavigation();
      }
    });
  }

//============================================== ALL VARIABLES =================================================\\
  late bool loadingScreen;
  bool vendorStatus = true;
  // bool _isScrollToTopBtnVisible = false;
  late Timer _timer;

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
  final scrollController = ScrollController();
  // late AnimationController _animationController;

//============================================== FUNCTIONS =================================================\\

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      loadingScreen = true;
    });
    // await Future.delayed(const Duration(milliseconds: 1000));
    await VendorController.instance.getVendors();
    setState(() {
      loadingScreen = false;
    });
  }

// //============================= Scroll to Top ======================================//
//   void _scrollToTop() {
//     _animationController.reverse();
//     scrollController.animateTo(0,
//         duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
//   }

//   void _scrollListener() {
//     //========= Show action button ========//
//     if (scrollController.position.pixels >= 200) {
//       _animationController.forward();
//       setState(() => _isScrollToTopBtnVisible = true);
//     }
//     //========= Hide action button ========//
//     else if (scrollController.position.pixels < 200) {
//       _animationController.reverse();
//       setState(() => _isScrollToTopBtnVisible = true);
//     }
//   }

//===================== Navigation ==========================\\

  void _toAddVendor() => Get.to(
        () => const AddVendor(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "AddVendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _toMyVendorsPage() => Get.to(
        () => const MyVendors(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "MyVendors",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _toVendorDetailsPage(VendorModel data) => Get.to(
        () => VendorDetailsPage(
          vendor: data,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "VendorDetails",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _showSearchField() =>
      showSearch(context: context, delegate: CustomSearchDelegate());
  @override
  Widget build(BuildContext context) {
    //============================ MediaQuery Size ===============================\\
    var media = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: kAccentColor,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _toAddVendor,
          elevation: 20.0,
          mouseCursor: SystemMouseCursors.click,
          tooltip: "Add a vendor",
          backgroundColor: kAccentColor,
          foregroundColor: kPrimaryColor,
          child: const FaIcon(FontAwesomeIcons.plus),
        ),
        appBar: AppBar(
          backgroundColor: widget.appBarBackgroundColor,
          elevation: 0.0,
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
              icon: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: widget.appBarSearchIconColor,
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
                elevation: 0.0,
              ),
            ),
          ],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: GetBuilder<VendorController>(
            initState: (state) async {
              await VendorController.instance.getVendors();
            },
            builder: (controller) {
              return Scrollbar(
                controller: scrollController,
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    kDefaultPadding,
                    0,
                    kDefaultPadding,
                    kDefaultPadding,
                  ),
                  children: [
                    kSizedBox,
                    controller.isLoad.value
                        ? const VendorsListSkeleton()
                        : ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: kDefaultPadding / 2),
                            itemCount: controller.vendorList.length,
                            addAutomaticKeepAlives: true,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => InkWell(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
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
                                  child: VendorContainer(
                                    onTap: () => _toVendorDetailsPage(
                                        controller.vendorList[index]),
                                    vendor: controller.vendorList[index],
                                  )),
                            ),
                          ),
                    kSizedBox,
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
