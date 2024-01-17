// ignore_for_file: unused_local_variable, unused_element

import 'dart:developer';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/business_controller.dart';
import 'package:benji_aggregator/model/my_vendor_model.dart';
import 'package:benji_aggregator/src/components/image/my_image.dart';
import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/section/my_liquid_refresh.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../src/skeletons/vendors_list_skeleton.dart';
import '../../theme/colors.dart';
import 'my_vendors_location.dart';
import 'report_my_vendor.dart';

class MyVendorDetailsPage extends StatefulWidget {
  final MyVendorModel vendor;
  const MyVendorDetailsPage({
    super.key,
    required this.vendor,
  });

  @override
  State<MyVendorDetailsPage> createState() => _MyVendorDetailsPageState();
}

class _MyVendorDetailsPageState extends State<MyVendorDetailsPage>
    with SingleTickerProviderStateMixin {
  //======================================= INITIAL AND DISPOSE ===============================================\\
  @override
  void initState() {
    super.initState();
    BusinessController.instance.getBusinesses(widget.vendor.id.toString());
    BusinessController.instance.getAllBusinesses(widget.vendor.id.toString());
    log("User ID: ${widget.vendor.id} Longitude: ${widget.vendor.longitude}Latitude: ${widget.vendor.latitude}");
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
        .getBusinesses(widget.vendor.id.toString());
    await BusinessController.instance
        .getAllBusinesses(widget.vendor.id.toString());
    setState(() {
      loadingScreen = false;
    });
  }

  void _clickOnTabBarOption(value) async {
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
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    const position = RelativeRect.fromLTRB(10, 60, 0, 0);

    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        // const PopupMenuItem<String>(
        //   value: 'about',
        //   child: Text("About vendor"),
        // ),
        const PopupMenuItem<String>(
          value: 'report',
          child: Text("Report vendor"),
        ),
      ],
    ).then((value) {
      // Handle the selected value from the popup menu
      if (value != null) {
        switch (value) {
          // case 'about':
          //   Get.to(
          //     () => AboutMyVendor(vendor: widget.vendor),
          //     duration: const Duration(milliseconds: 300),
          //     fullscreenDialog: true,
          //     curve: Curves.easeIn,
          //     routeName: "About my vendor",
          //     preventDuplicates: true,
          //     popGesture: true,
          //     transition: Transition.rightToLeft,
          //   );
          //   break;

          case 'report':
            Get.to(
              () => ReportMyVendor(vendor: widget.vendor),
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              routeName: "ReportMyVendor",
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
  // void toProductDetailScreen() => Get.to(
  //       () => MyProductDetails(
  //         productImage: _productImage,
  //         productName: _productName,
  //         productPrice: _productPrice,
  //         productDescription: _productDescription,
  //       ),
  //       duration: const Duration(milliseconds: 300),
  //       fullscreenDialog: true,
  //       curve: Curves.easeIn,
  //       routeName: "My product details",
  //       preventDuplicates: true,
  //       popGesture: true,
  //       transition: Transition.rightToLeft,
  //     );

  // void toAddProduct() => Get.to(
  //       () => AddProduct(vendor: widget.vendor),
  //       duration: const Duration(milliseconds: 300),
  //       fullscreenDialog: true,
  //       curve: Curves.easeIn,
  //       routeName: "Add product",
  //       preventDuplicates: true,
  //       popGesture: true,
  //       transition: Transition.downToUp,
  //     );

  toVendorLocation() {
    double latitude;
    double longitude;

    try {
      latitude = double.parse(widget.vendor.latitude);
      longitude = double.parse(widget.vendor.longitude);
      if (latitude >= -90 &&
          latitude <= 90 &&
          longitude >= -180 &&
          longitude <= 180) {
      } else {
        ApiProcessorController.errorSnack(
            "Couldn't get the address. Please refresh");
        return;
      }
    } catch (e) {
      ApiProcessorController.errorSnack("Couldn't get the address.\nERROR: $e");
      return;
    }
    Get.to(
      () => MyVendorLocation(
        vendorName: widget.vendor.username,
        vendorAddress: widget.vendor.address,
        latitude: widget.vendor.latitude,
        longitude: widget.vendor.longitude,
      ),
      routeName: 'MyVendorLocation',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateAndTime = formatDateAndTime(now);
    var media = MediaQuery.of(context).size;
    double subtotalPrice = calculateSubtotal();
//==========================================================================\\
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
            : const SizedBox(),
        //     :
        // FloatingActionButton(
        //   onPressed: toAddProduct,
        //   elevation: 20.0,
        //   mouseCursor: SystemMouseCursors.click,
        //   tooltip: "Add Product",
        //   backgroundColor: kAccentColor,
        //   foregroundColor: kPrimaryColor,
        //   child: const FaIcon(FontAwesomeIcons.plus),
        // ),
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
                              child: Image.asset(
                                "assets/images/logo/benji_full_logo.png",
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.contain,
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
                        child: Container(
                          width: deviceType(media.width) > 2 ? 126 : 100,
                          height: deviceType(media.width) > 2 ? 126 : 100,
                          decoration: ShapeDecoration(
                            color: kPageSkeletonColor,
                            shape: const OvalBorder(),
                          ),
                          child: MyImage(url: widget.vendor.profileLogo),
                        ),
                      ),
                    ],
                  ),
                ),
                GetBuilder<BusinessController>(
                    init: BusinessController(),
                    builder: (controller) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              showBusinesses = !showBusinesses;
                            });
                          },
                          borderRadius: BorderRadius.circular(kDefaultPadding),
                          child: Container(
                            padding: const EdgeInsets.all(kDefaultPadding),
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
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.shop,
                                  color: kAccentColor,
                                  size: 16,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      showBusinesses
                                          ? "Hide Businesses"
                                          : "Show Businesses",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: kTextBlackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    kHalfWidthSizedBox,
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "(",
                                            style: TextStyle(
                                              color: kTextGreyColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: loadingScreen
                                                ? "..."
                                                : "${controller.allBusinessesList.length}",
                                            style: TextStyle(
                                              color: kAccentColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ")",
                                            style: TextStyle(
                                              color: kTextGreyColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                FaIcon(
                                  showBusinesses
                                      ? FontAwesomeIcons.caretDown
                                      : FontAwesomeIcons.caretUp,
                                  color: kAccentColor,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
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
                                controller.businessesList.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: VendorsListSkeleton(),
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
                                    itemCount: controller.businessesList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          decoration: ShapeDecoration(
                                            color: kPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 120,
                                                width: 120,
                                                decoration: ShapeDecoration(
                                                  color: kLightGreyColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: MyImage(
                                                    url: controller
                                                        .businessesList[index]
                                                        .shopImage,
                                                  ),
                                                ),
                                              ),
                                              kHalfWidthSizedBox,
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: media.width - 200,
                                                    child: Text(
                                                      controller
                                                          .businessesList[index]
                                                          .shopName,
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: kTextBlackColor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                  kHalfSizedBox,
                                                  SizedBox(
                                                    width: media.width - 200,
                                                    child: Text(
                                                      controller
                                                          .businessesList[index]
                                                          .address,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: kAccentColor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                  kSizedBox,
                                                  SizedBox(
                                                    width: media.width - 150,
                                                    child: Row(
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .solidIdCard,
                                                          color: kAccentColor,
                                                          size: 16,
                                                        ),
                                                        kHalfWidthSizedBox,
                                                        SizedBox(
                                                          width:
                                                              media.width - 200,
                                                          child: Text.rich(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                  text: "TIN: ",
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kTextBlackColor,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: controller
                                                                      .businessesList[
                                                                          index]
                                                                      .businessId,
                                                                  style:
                                                                      const TextStyle(
                                                                    color:
                                                                        kTextBlackColor,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
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
                //             onTap: _clickOnTabBarOption,
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
                //                         return VendorsProductContainer(
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
