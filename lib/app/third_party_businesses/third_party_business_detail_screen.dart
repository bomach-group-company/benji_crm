import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../controller/api_processor_controller.dart';
import '../../controller/order_controller.dart';
import '../../controller/product_controller.dart';
import '../../controller/reviews_controller.dart';
import '../../model/business_model.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/image/my_image.dart';
import '../../src/components/section/my_liquid_refresh.dart';
import '../../src/providers/constants.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../theme/colors.dart';
import '../business_orders/orders.dart';
import '../third_party_business_products/add_third_party_product.dart';
import '../third_party_business_products/third_party_business_products.dart';
import 'about_third_party_business.dart';
import 'edit_third_party_business.dart';
import 'third_party_business_location.dart';

class ThirdPartyBusinessDetailScreen extends StatefulWidget {
  final BusinessModel business;
  const ThirdPartyBusinessDetailScreen({
    super.key,
    required this.business,
  });

  @override
  State<ThirdPartyBusinessDetailScreen> createState() =>
      _ThirdPartyBusinessDetailScreenState();
}

class _ThirdPartyBusinessDetailScreenState
    extends State<ThirdPartyBusinessDetailScreen>
    with SingleTickerProviderStateMixin {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);
    _tabBarController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  //========================= VARIABLES =========================\\
  bool refreshing = false;

  Future<void> _handleRefresh() async {
    setState(() {
      refreshing = true;
    });
    await ProductController.instance.getBusinessProducts(widget.business.id);
    await OrderController.instance.getOrders();
    await ReviewsController.instance.getReviews();
    setState(() {
      refreshing = false;
    });
  }

  toBusinessLocation() {
    double latitude;
    double longitude;
    if (kIsWeb) {
      ApiProcessorController.errorSnack("Not supported on the web");
      return;
    }
    try {
      latitude = double.parse(widget.business.latitude);
      longitude = double.parse(widget.business.longitude);
      if (latitude >= -90 &&
          latitude <= 90 &&
          longitude >= -180 &&
          longitude <= 180) {
      } else {
        ApiProcessorController.errorSnack(
            "An error occured, fetching the address failed. Please try again later.");
        return;
      }
    } catch (e) {
      ApiProcessorController.errorSnack(
        "An error occured, fetching the address failed. Please try again later.\nERROR: $e. Please try again later",
      );
      return;
    }
    Get.to(
      () => ThirdPartyBusinessLocation(business: widget.business),
      routeName: 'ThirdPartyBusinessLocation',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

//==========================================================================================\\

  //=================================== ALL VARIABLES ====================================\\
  int selectedRating = 0;

  //=================================== CONTROLLERS ====================================\\
  late TabController _tabBarController;
  final ScrollController scrollController = ScrollController();

//===================== KEYS =======================\\
  // final _formKey = GlobalKey<FormState>();

//===================== FOCUS NODES =======================\\
  FocusNode rateVendorFN = FocusNode();

//===================== BOOL VALUES =======================\\
  bool isScrollToTopBtnVisible = false;

//================================================= FUNCTIONS ===================================================\\

  Future<void> scrollToTop() async {
    await scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      isScrollToTopBtnVisible = false;
    });
  }

  Future<void> scrollListener() async {
    if (scrollController.position.pixels >= 200 &&
        isScrollToTopBtnVisible != true) {
      setState(() {
        isScrollToTopBtnVisible = true;
      });
    }
    if (scrollController.position.pixels < 200 &&
        isScrollToTopBtnVisible == true) {
      setState(() {
        isScrollToTopBtnVisible = false;
      });
    }
  }

  int selectedtabbar = 0;

  void _clickOnTabBarOption(value) async {
    setState(() {
      selectedtabbar = value;
    });
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
          value: 'edit',
          child: Text("Edit Business"),
        ),
      ],
    ).then((value) {
      // Handle the selected value from the popup menu
      if (value != null) {
        switch (value) {
          case 'edit':
            Get.to(
              () => EditThirdPartyBusiness(business: widget.business),
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              routeName: "EditBusiness",
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.rightToLeft,
            );
            break;
        }
      }
    });
  }

//=================================== Navigation =====================================\\

  addProduct() => Get.to(
        () => AddThirdPartyBusinessProduct(business: widget.business),
        routeName: 'AddThirdPartyBusinessProduct',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return MyLiquidRefresh(
      onRefresh: _handleRefresh,
      child: Scaffold(
        appBar: MyAppBar(
          title: isScrollToTopBtnVisible
              ? widget.business.shopName
              : "Business Details",
          elevation: 0.0,
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
        floatingActionButton: isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: scrollToTop,
                mini: true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: FaIcon(FontAwesomeIcons.chevronUp,
                    size: 18, color: kPrimaryColor),
              )
            : FloatingActionButton(
                onPressed: addProduct,
                elevation: 20.0,
                backgroundColor: kAccentColor,
                foregroundColor: kPrimaryColor,
                tooltip: "Add a product",
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                child: const FaIcon(FontAwesomeIcons.plus),
              ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            child: ListView(
              controller: scrollController,
              physics: const ScrollPhysics(),
              children: [
                SizedBox(
                  height:
                      deviceType(media.width) > 2 && deviceType(media.width) < 4
                          ? 540
                          : deviceType(media.width) > 2
                              ? 470
                              : 370,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: deviceType(media.width) > 3 &&
                                  deviceType(media.width) < 5
                              ? media.height * 0.4
                              : deviceType(media.width) > 2
                                  ? media.height * 0.415
                                  : media.height * 0.28,
                          decoration: BoxDecoration(color: kLightGreyColor),
                          child: MyImage(
                            url: widget.business.coverImage,
                          ),
                        ),
                      ),
                      Positioned(
                        top: deviceType(media.width) > 2
                            ? media.height * 0.25
                            : media.height * 0.13,
                        left: kDefaultPadding,
                        right: kDefaultPadding,
                        child: Container(
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
                            child: SizedBox(
                              width: media.width - 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: media.width - 200,
                                    child: Text(
                                      widget.business.shopName,
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
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.locationDot,
                                          color: kAccentColor,
                                          size: 15,
                                        ),
                                        kHalfWidthSizedBox,
                                        SizedBox(
                                          width: deviceType(media.width) >= 2
                                              ? media.width - 850
                                              : media.width - 220,
                                          child: Text(
                                            widget.business.address,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  kHalfSizedBox,
                                  InkWell(
                                    onTap: widget.business.address.isEmpty
                                        ? null
                                        : toBusinessLocation,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                          kDefaultPadding / 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: kAccentColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        widget.business.address.isEmpty
                                            ? "Not Available"
                                            : "Show on map",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  kHalfSizedBox,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: media.width * 0.23,
                                        padding: const EdgeInsets.all(
                                            kDefaultPadding),
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
                                            FaIcon(
                                              FontAwesomeIcons.solidStar,
                                              color: kStarColor,
                                              size: 17,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              doubleFormattedText(
                                                (widget.business.averageRating),
                                              ),
                                              style: const TextStyle(
                                                color: kBlackColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: media.width * 0.28,
                                        // height: 57,
                                        padding: const EdgeInsets.all(
                                            kDefaultPadding),
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
                                            Text(
                                              widget.business.vendorOwner
                                                      .isOnline
                                                  ? "Online"
                                                  : 'Offline',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: widget.business
                                                        .vendorOwner.isOnline
                                                    ? kSuccessColor
                                                    : kAccentColor,
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
                      ),
                      Positioned(
                        top: deviceType(media.width) > 3 &&
                                deviceType(media.width) < 5
                            ? media.height * 0.15
                            : deviceType(media.width) > 2
                                ? media.height * 0.15
                                : media.height * 0.08,
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
                                  url: widget.business.shopImage,
                                  width:
                                      deviceType(media.width) > 2 ? 126 : 100,
                                  height:
                                      deviceType(media.width) > 2 ? 126 : 100,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                deviceType(media.width) > 2 ? kSizedBox : kHalfSizedBox,
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
                              Tab(text: "Products"),
                              Tab(text: "Orders"),
                              Tab(text: "About"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                kSizedBox,
                refreshing
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
                            ? ThirdPartyBusinessProducts(
                                business: widget.business,
                              )
                            : selectedtabbar == 1
                                ? const Orders()
                                : AboutThirdPartyBusiness(
                                    business: widget.business,
                                  ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
