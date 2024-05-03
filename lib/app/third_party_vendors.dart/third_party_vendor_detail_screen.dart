import 'dart:developer';

import 'package:benji_aggregator/controller/business_controller.dart';
import 'package:benji_aggregator/src/components/card/empty.dart';
import 'package:benji_aggregator/src/components/image/my_image.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';
import '../../model/third_party_vendor_model.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/container/business_container.dart';
import '../../src/components/section/dashboard_businesses_display_controller.dart';
import '../../src/components/section/my_liquid_refresh.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../src/skeletons/vendors_list_skeleton.dart';
import '../../theme/colors.dart';
import '../third_party_businesses/add_third_party_business.dart';
import '../third_party_businesses/third_party_business_detail_screen.dart';
import 'about_third_party_vendor.dart';
import 'report_third_party_vendor.dart';

class ThirdPartyVendorDetailPage extends StatefulWidget {
  final ThirdPartyVendorModel vendor;
  const ThirdPartyVendorDetailPage({
    super.key,
    required this.vendor,
  });

  @override
  State<ThirdPartyVendorDetailPage> createState() =>
      _ThirdPartyVendorDetailPageState();
}

class _ThirdPartyVendorDetailPageState extends State<ThirdPartyVendorDetailPage>
    with SingleTickerProviderStateMixin {
  //======================================= INITIAL AND DISPOSE ===============================================\\
  @override
  void initState() {
    super.initState();

    BusinessController.instance
        .getBusinesses(widget.vendor.id.toString(), agentId);
    BusinessController.instance
        .getTotalNumberOfBusinesses(widget.vendor.id.toString(), agentId);
    log("Vendor ID: ${widget.vendor.id} Longitude: ${widget.vendor.longitude} Latitude: ${widget.vendor.latitude}");
    scrollController.addListener(_scrollListener);
    _tabBarController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    scrollController.dispose();
    super.dispose();
  }

//==========================================================================================\\

  //=================================== ALL VARIABLES ====================================\\
  bool loadingScreen = false;
  bool isScrollToTopBtnVisible = false;
  bool showBusinesses = true;
  int tabBar = 0;
  var agentId = UserController.instance.user.value.id;

  //=================================== Orders =======================================\\
  final int _orderQuantity = 2;
  // final double _price = 2500;
  final double _itemPrice = 2500;

  //=============================== Products ====================================\\

  //=================================== CONTROLLERS ====================================\\
  late TabController _tabBarController;
  final ScrollController scrollController = ScrollController();

//===================== KEYS =======================\\
  // final _formKey = GlobalKey<FormState>();

//===================== VENDORS LIST VIEW INDEX =======================\\
  List<int> foodListView = [0, 1, 3, 4, 5, 6];

//===================== FUNCTIONS =======================\\
  double calculateSubtotal() {
    return _itemPrice * _orderQuantity;
  }

//===================== Handle refresh ==========================\\

  Future<void> handleRefresh() async {
    setState(() {
      loadingScreen = true;
    });

    await BusinessController.instance
        .getBusinesses(widget.vendor.id.toString(), agentId);
    await BusinessController.instance
        .getTotalNumberOfBusinesses(widget.vendor.id.toString(), agentId);
    setState(() {
      loadingScreen = false;
    });
  }

  void clickOnTabBarOption(value) async {
    setState(() {
      tabBar = value;
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
      setState(() => isScrollToTopBtnVisible = true);
    }
    //========= Hide action button ========//
    else if (scrollController.position.pixels < 100) {
      setState(() => isScrollToTopBtnVisible = false);
    }
  }

  //=================================== Show Popup Menu =====================================\\
  //Show popup menu
  void showPopupMenu(BuildContext context) {
    // final RenderBox overlay =
    //     Overlay.of(context).context.findRenderObject() as RenderBox;
    const position = RelativeRect.fromLTRB(10, 60, 0, 0);

    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        const PopupMenuItem<String>(
          value: 'about',
          child: Text("Edit vendor"),
        ),
        const PopupMenuItem<String>(
          value: 'report',
          child: Text("Report vendor"),
        ),
      ],
    ).then((value) {
      // Handle the selected value from the popup menu
      if (value != null) {
        switch (value) {
          case 'about':
            Get.to(
              () => AboutThirdPartyVendor(vendor: widget.vendor),
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              routeName: "AboutThirdPartyVendor",
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.rightToLeft,
            );
            break;

          case 'report':
            Get.to(
              () => ReportThirdPartyVendor(vendor: widget.vendor),
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              routeName: "ReportThirdPartyVendor",
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.rightToLeft,
            );
            break;
        }
      }
    });
  }

  //===================== Navigation ==========================\\
  void addBusiness() => Get.to(
        () => AddThirdPartyBusiness(vendor: widget.vendor),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "AddBusiness",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return MyLiquidRefresh(
      onRefresh: handleRefresh,
      child: Scaffold(
        floatingActionButton: isScrollToTopBtnVisible
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
                onPressed: addBusiness,
                elevation: 20.0,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Add Business",
                backgroundColor: kAccentColor,
                foregroundColor: kPrimaryColor,
                child: const FaIcon(FontAwesomeIcons.plus),
              ),
        appBar: MyAppBar(
          title: isScrollToTopBtnVisible
              ? "${widget.vendor.firstName} ${widget.vendor.lastName}"
              : "My Vendor Details",
          elevation: 0,
          backgroundColor: kPrimaryColor,
          actions: [
            IconButton(
              onPressed: () => showPopupMenu(context),
              icon: FaIcon(
                FontAwesomeIcons.ellipsisVertical,
                color: kAccentColor,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Scrollbar(
            child: ListView(
              physics: const ScrollPhysics(),
              controller: scrollController,
              children: [
                SizedBox(
                  height:
                      deviceType(media.width) > 2 && deviceType(media.width) < 4
                          ? 540
                          : deviceType(media.width) > 2
                              ? 470
                              : 320,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: deviceType(media.width) > 3 &&
                                  deviceType(media.width) < 5
                              ? media.height * 0.3
                              : deviceType(media.width) > 2
                                  ? media.height * 0.2
                                  : media.height * 0.15,
                          decoration:
                              const BoxDecoration(color: kTransparentColor),
                          child: Padding(
                            padding: const EdgeInsets.all(kDefaultPadding),
                            child: Opacity(
                              opacity: 0.6,
                              child: MyImage(
                                height: deviceType(media.width) > 3 &&
                                        deviceType(media.width) < 5
                                    ? media.height * 0.3
                                    : deviceType(media.width) > 2
                                        ? media.height * 0.2
                                        : media.height * 0.15,
                                width: media.width,
                                url: widget.vendor.coverImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: deviceType(media.width) > 2
                            ? media.height * 0.25
                            : media.height * 0.1,
                        left: kDefaultPadding,
                        right: kDefaultPadding,
                        child: Container(
                          // width: 200,
                          padding: const EdgeInsets.all(kDefaultPadding / 2),
                          decoration: ShapeDecoration(
                            shadows: [
                              BoxShadow(
                                color: kBlackColor.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal,
                              ),
                            ],
                            color: const Color(0xFFFEF8F8),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 0.50,
                                color: Color(0xFFFDEDED),
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: kDefaultPadding * 2.6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: media.width - 150,
                                  child: Text(
                                    "${widget.vendor.firstName} ${widget.vendor.lastName}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                kHalfSizedBox,
                                SizedBox(
                                  width: media.width - 150,
                                  child: Text(
                                    "ID: ${widget.vendor.code}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                kHalfSizedBox,
                                // Center(
                                //   child: Container(
                                //     padding: const EdgeInsets.all(16.0),
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         FaIcon(
                                //           FontAwesomeIcons.locationDot,
                                //           color: kAccentColor,
                                //           size: 15,
                                //         ),
                                //         kHalfWidthSizedBox,
                                //         Flexible(
                                //           child: Text(
                                //             widget.vendor.address,
                                //             overflow: TextOverflow.ellipsis,
                                //             style:
                                //                 const TextStyle(fontSize: 16.0),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // kHalfSizedBox,
                                // InkWell(
                                //   onTap: widget.vendor.address.isEmpty ||
                                //           widget.vendor.address == ""
                                //       ? null
                                //       : toVendorLocation,
                                //   borderRadius: BorderRadius.circular(10),
                                //   child: Container(
                                //     padding:
                                //         const EdgeInsets.all(kDefaultPadding / 4),
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(10),
                                //       border: Border.all(
                                //         color: kAccentColor,
                                //         width: 1,
                                //       ),
                                //     ),
                                //     child: Text(
                                //       widget.vendor.address.isEmpty ||
                                //               widget.vendor.address ==
                                //                   notAvailable
                                //           ? "Not available"
                                //           : "Show on map",
                                //       textAlign: TextAlign.center,
                                //       style: const TextStyle(
                                //         fontSize: 13,
                                //         fontWeight: FontWeight.w400,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // kHalfSizedBox,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: media.width - 250,
                                      padding:
                                          const EdgeInsets.all(kDefaultPadding),
                                      decoration: ShapeDecoration(
                                        color: kPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(19),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Online",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: kSuccessColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: -0.36,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          FaIcon(
                                            Icons.info,
                                            color: kAccentColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: deviceType(media.width) > 3 &&
                                deviceType(media.width) < 5
                            ? media.height * 0.15
                            : deviceType(media.width) > 2
                                ? media.height * 0.15
                                : media.height * 0.04,
                        left: deviceType(media.width) > 2
                            ? (media.width / 2) - (126 / 2)
                            : (media.width / 2) - (100 / 2),
                        child: SizedBox(
                          width: deviceType(media.width) > 2 ? 126 : 100,
                          height: deviceType(media.width) > 2 ? 126 : 100,
                          child: CircleAvatar(
                            backgroundColor: kLightGreyColor,
                            child: Center(
                              child: ClipOval(
                                child: MyImage(
                                  width:
                                      deviceType(media.width) > 2 ? 126 : 100,
                                  height:
                                      deviceType(media.width) > 2 ? 126 : 100,
                                  url: widget.vendor.profileLogo,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GetBuilder<BusinessController>(
                  init: BusinessController(),
                  builder: (controller) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: DashboardDisplayBusinessesController(
                        refreshing: loadingScreen,
                        showBusinesses: showBusinesses,
                        onTap: () {
                          setState(() {
                            showBusinesses = !showBusinesses;
                          });
                        },
                        numberOfBusinesses:
                            controller.listOfBusinesses.length.toString(),
                      ),
                    );
                  },
                ),
                kSizedBox,

                GetBuilder<BusinessController>(
                  init: BusinessController(),
                  builder: (controller) {
                    return loadingScreen
                        ? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: VendorsListSkeleton(),
                          )
                        : controller.isLoad.value &&
                                controller.listOfBusinesses.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: VendorsListSkeleton(),
                              )
                            : controller.listOfBusinesses.isEmpty
                                ? const Center(
                                    child: EmptyCard(
                                      emptyCardMessage:
                                          "You haven't added any business to this vendor",
                                      animation:
                                          "assets/animations/empty/frame_4.json",
                                    ),
                                  )
                                : showBusinesses
                                    ? ListView.separated(
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        separatorBuilder: (context, index) =>
                                            kHalfSizedBox,
                                        shrinkWrap: true,
                                        addAutomaticKeepAlives: true,
                                        itemCount:
                                            controller.listOfBusinesses.length,
                                        itemBuilder: (context, index) {
                                          return BusinessContainer(
                                            onTap: () {
                                              Get.to(
                                                () =>
                                                    ThirdPartyBusinessDetailScreen(
                                                  business: controller
                                                      .listOfBusinesses[index],
                                                ),
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                fullscreenDialog: true,
                                                curve: Curves.easeIn,
                                                routeName:
                                                    "ThirdPartyBusinessDetailScreen",
                                                preventDuplicates: true,
                                                popGesture: false,
                                                transition:
                                                    Transition.rightToLeft,
                                              );
                                            },
                                            // onTap: toBusinessDetailScreen(
                                            //   controller.businesses[index],
                                            // ),
                                            business: controller
                                                .listOfBusinesses[index],
                                          );
                                        },
                                      )
                                    : const SizedBox();
                  },
                ),

                kSizedBox,
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                //   child: Container(
                //     width: media.width,
                //     decoration: BoxDecoration(
                //       color: kDefaultCategoryBackgroundColor,
                //       borderRadius: BorderRadius.circular(50),
                //       border: Border.all(
                //         color: kLightGreyColor,
                //         style: BorderStyle.solid,
                //         strokeAlign: BorderSide.strokeAlignOutside,
                //       ),
                //     ),
                //     child: Column(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(5.0),
                //           child: TabBar(
                //             controller: _tabBarController,
                //             onTap: clickOnTabBarOption,
                //             splashBorderRadius: BorderRadius.circular(50),
                //             enableFeedback: true,
                //             mouseCursor: SystemMouseCursors.click,
                //             indicatorSize: TabBarIndicatorSize.tab,
                //             dividerColor: kTransparentColor,
                //             automaticIndicatorColorAdjustment: true,
                //             labelColor: kPrimaryColor,
                //             unselectedLabelColor: kTextGreyColor,
                //             indicator: BoxDecoration(
                //               color: kAccentColor,
                //               borderRadius: BorderRadius.circular(50),
                //             ),
                //             tabs: const [
                //               Tab(text: "Products"),
                //               Tab(text: "Orders"),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // kSizedBox,
                // Container(
                //   height: media.height,
                //   width: media.width,
                //   padding: const EdgeInsets.only(
                //     left: kDefaultPadding / 2,
                //     right: kDefaultPadding / 2,
                //   ),
                //   child: Column(
                //     children: [
                //       tabBar == 0
                //           ?
                //           // const VendorsTabBarProductsContentSkeleton()
                //           Column(
                //               mainAxisAlignment: MainAxisAlignment.start,
                //               children: [
                //                 // CategoryButtonSection(
                //                 //   onPressed:
                //                 //       _changeProductCategory,
                //                 //   category:
                //                 //       _categoryButtonText,
                //                 //   categorybgColor:
                //                 //       _categoryButtonBgColor,
                //                 //   categoryFontColor:
                //                 //       _categoryButtonFontColor,
                //                 // ),

                //                 GetBuilder<VendorController>(
                //                   initState: (state) async {
                //                     await VendorController.instance
                //                         .getVendorProduct(widget.vendor.id);
                //                   },
                //                   init: VendorController(),
                //                   builder: (controller) {
                //                     if (controller.isLoad.isFalse &&
                //                         controller.vendorProductList.isEmpty) {
                //                       return const EmptyCard();
                //                     }
                //                     return ListView.builder(
                //                       shrinkWrap: true,
                //                       itemCount:
                //                           controller.vendorProductList.length,
                //                       itemBuilder:
                //                           (BuildContext context, int index) {
                //                         return BusinessProductContainer(
                //                           onTap: () {},
                //                           product:
                //                               controller.vendorProductList[index],
                //                         );
                //                       },
                //                     );
                //                   },
                //                 ),
                //                 GetBuilder<VendorController>(
                //                   builder: (controller) => Column(
                //                     children: [
                //                       controller.isLoadMoreProduct.value
                //                           ? Center(
                //                               child: CircularProgressIndicator(
                //                                 color: kAccentColor,
                //                               ),
                //                             )
                //                           : const SizedBox(),
                //                       controller.loadedAllProduct.value
                //                           ? Container(
                //                               margin: const EdgeInsets.only(
                //                                   top: 20, bottom: 20),
                //                               height: 10,
                //                               width: 10,
                //                               decoration: ShapeDecoration(
                //                                   shape: const CircleBorder(),
                //                                   color: kPageSkeletonColor),
                //                             )
                //                           : const SizedBox(),
                //                     ],
                //                   ),
                //                 )
                //               ],
                //             )
                //           // const VendorsTabBarOrdersContentSkeleton()
                //           : Column(
                //               children: [
                //                 GetBuilder<OrderController>(
                //                   initState: (state) async {
                //                     await OrderController.instance.getOrders();
                //                   },
                //                   init: OrderController(),
                //                   builder: (controller) => ListView.builder(
                //                     shrinkWrap: true,
                //                     itemCount: controller.orderList.length,
                //                     itemBuilder:
                //                         (BuildContext context, int index) {
                //                       return VendorsOrderContainer(
                //                         order: controller.orderList[index],
                //                       );
                //                     },
                //                   ),
                //                 ),
                //                 GetBuilder<OrderController>(
                //                   builder: (controller) => Column(
                //                     children: [
                //                       controller.isLoadMore.value
                //                           ? Center(
                //                               child: CircularProgressIndicator(
                //                                 color: kAccentColor,
                //                               ),
                //                             )
                //                           : const SizedBox(),
                //                       controller.loadedAll.value
                //                           ? Container(
                //                               margin: const EdgeInsets.only(
                //                                   top: 20, bottom: 20),
                //                               height: 10,
                //                               width: 10,
                //                               decoration: ShapeDecoration(
                //                                   shape: const CircleBorder(),
                //                                   color: kPageSkeletonColor),
                //                             )
                //                           : const SizedBox(),
                //                     ],
                //                   ),
                //                 )
                //               ],
                //             ),
                //       // const VendorsTabBarOrdersContentSkeleton()
                //     ],
                //   ),
                // ),
                // kSizedBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
