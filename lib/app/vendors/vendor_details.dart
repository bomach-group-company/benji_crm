// ignore_for_file: unused_local_variable

import 'package:benji_aggregator/app/products/product_details.dart';
import 'package:benji_aggregator/controller/order_controller.dart';
import 'package:benji_aggregator/model/product_model.dart';
import 'package:benji_aggregator/model/vendor_model.dart';
import 'package:benji_aggregator/src/components/image/my_image.dart';
import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/src/providers/custom_show_search.dart';
import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../controller/vendor_controller.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/container/vendors_order_container.dart';
import '../../src/components/container/vendors_product_container.dart';
import '../../theme/colors.dart';
import 'about_vendor.dart';
import 'report_vendor.dart';

class VendorDetailsPage extends StatefulWidget {
  final VendorModel vendor;
  const VendorDetailsPage({super.key, required this.vendor});

  @override
  State<VendorDetailsPage> createState() => _VendorDetailsPageState();
}

class _VendorDetailsPageState extends State<VendorDetailsPage>
    with SingleTickerProviderStateMixin {
  //========================================= INITIAL STATE AND DISPOSE =============================================\\
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() => VendorController.instance
        .scrollListenerProduct(scrollController, widget.vendor.id));
    scrollController.addListener(
        () => OrderController.instance.scrollListener(scrollController));

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

//===================== BOOL VALUES =======================\\
  // bool isLoading = false;
  int tabBar = 0;

  //=================================== Orders =======================================\\
  final int _incrementOrderID = 2 + 2;
  final int _orderID = 0;
  final String _orderItem = "Jollof Rice and Chicken";
  final String _customerAddress = "21 Odogwu Street, New Haven";
  final int _itemQuantity = 2;
  // final double _price = 2500;
  final double _itemPrice = 2500;
  final String _orderImage = "chizzy's-food";
  final String _customerName = "Mercy Luke";

  //=============================== Products ====================================\\
  final String _productName = "Smokey Jollof Pasta";
  final String _productImage = "pasta";

  final String _productDescription =
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit, tenetur error, harum nesciunt ipsum debitis quas aliquid. Reprehenderit, quia. Quo neque error repudiandae fuga? Ipsa laudantium molestias eos  sapiente officiis modi at sunt excepturi expedita sint? Sed quibusdam recusandae alias error harum maxime adipisci amet laborum. Perspiciatis  minima nesciunt dolorem! Officiis iure rerum voluptates a cumque velit  quibusdam sed amet tempora. Sit laborum ab, eius fugit doloribus tenetur  fugiat, temporibus enim commodi iusto libero magni deleniti quod quam consequuntur! Commodi minima excepturi repudiandae velit hic maxime doloremque. Quaerat provident commodi consectetur veniam similique ad earum omnis ipsum saepe, voluptas, hic voluptates pariatur est explicabo fugiat, dolorum eligendi quam cupiditate excepturi mollitia maiores labore suscipit quas? Nulla, placeat. Voluptatem quaerat non architecto ab laudantium modi minima sunt esse temporibus sint culpa, recusandae aliquam numquam totam ratione voluptas quod exercitationem fuga. Possim";
  final double _productPrice = 1200;

  //=================================== CONTROLLERS ====================================\\
  late TabController _tabBarController;
  final ScrollController scrollController = ScrollController();

//===================== KEYS =======================\\
  // final _formKey = GlobalKey<FormState>();

//===================== VENDORS LIST VIEW INDEX =======================\\

//===================== FUNCTIONS =======================\\
  double calculateSubtotal() {
    return _itemPrice * _itemQuantity;
  }

  //===================== Number format ==========================\\
  String formattedText(int value) {
    final numberFormat = NumberFormat('#,##0');
    return numberFormat.format(value);
  }

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {}

  void _clickOnTabBarOption(value) async {
    setState(() {
      tabBar = value;
    });
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
        const PopupMenuItem<String>(
          value: 'about',
          child: Text("About vendor"),
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
            _toAboutVendor();
            break;
          case 'report':
            _toSuspendVendor();
            break;
        }
      }
    });
  }

  //===================== Navigation ==========================\\
  void toProductDetailScreen(Product data) => Get.to(
        () => ProductDetails(
          productImage: _productImage,
          productName: _productName,
          productPrice: _productPrice,
          productDescription: _productDescription,
          product: data,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Product Details",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toAboutVendor() => Get.to(
        () => AboutVendor(
          vendor: widget.vendor,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "About vendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toSuspendVendor() => Get.to(
        () => ReportVendor(vendor: widget.vendor),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Suspend vendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateAndTime = formatDateAndTime(now);
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    double subtotalPrice = calculateSubtotal();

//====================================================================================\\

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
          title: "Vendor Details",
          elevation: 0,
          backgroundColor: kPrimaryColor,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon:
                  FaIcon(FontAwesomeIcons.magnifyingGlass, color: kAccentColor),
            ),
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
          maintainBottomViewPadding: true,
          child: Scrollbar(
            controller: scrollController,
            radius: const Radius.circular(10),
            scrollbarOrientation: ScrollbarOrientation.right,
            child: ListView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              dragStartBehavior: DragStartBehavior.down,
              children: [
                SizedBox(
                  height:
                      deviceType(mediaWidth) > 2 && deviceType(mediaWidth) < 4
                          ? 540
                          : deviceType(mediaWidth) > 2
                              ? 470
                              : 370,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: deviceType(mediaWidth) > 3 &&
                                  deviceType(mediaWidth) < 5
                              ? mediaHeight * 0.4
                              : deviceType(mediaWidth) > 2
                                  ? mediaHeight * 0.415
                                  : mediaHeight * 0.28,
                          decoration: BoxDecoration(
                            color: kPageSkeletonColor,
                          ),
                          child: MyImage(url: widget.vendor.shopImage),
                        ),
                      ),
                      Positioned(
                        top: deviceType(mediaWidth) > 2
                            ? mediaHeight * 0.25
                            : mediaHeight * 0.13,
                        left: kDefaultPadding,
                        right: kDefaultPadding,
                        child: Container(
                          width: 200,
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
                                  width: mediaWidth - 200,
                                  child: Text(
                                    widget.vendor.shopName,
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
                                Container(
                                  width: mediaWidth - 90,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.locationDot,
                                        color: kAccentColor,
                                        size: 15,
                                      ),
                                      kHalfWidthSizedBox,
                                      Text(
                                        widget.vendor.address,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                kHalfSizedBox,
                                InkWell(
                                  onTap: () {},
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
                                      widget.vendor.address == notAvailable
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
                                      width: mediaWidth * 0.23,
                                      height: 57,
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
                                            '${widget.vendor.averageRating}',
                                            style: const TextStyle(
                                              color: kBlackColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: -0.28,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: mediaWidth * 0.25,
                                      height: 57,
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
                                            widget.vendor.isOnline
                                                ? "Online"
                                                : 'Offline',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: widget.vendor.isOnline
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
                      Positioned(
                        top: deviceType(mediaWidth) > 3 &&
                                deviceType(mediaWidth) < 5
                            ? mediaHeight * 0.15
                            : deviceType(mediaWidth) > 2
                                ? mediaHeight * 0.15
                                : mediaHeight * 0.08,
                        left: deviceType(mediaWidth) > 2
                            ? (mediaWidth / 2) - (126 / 2)
                            : (mediaWidth / 2) - (100 / 2),
                        child: Container(
                          width: deviceType(mediaWidth) > 2 ? 126 : 100,
                          height: deviceType(mediaWidth) > 2 ? 126 : 100,
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                  ),
                  child: Container(
                    width: mediaWidth,
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
                            onTap: _clickOnTabBarOption,
                            enableFeedback: true,
                            mouseCursor: SystemMouseCursors.click,
                            automaticIndicatorColorAdjustment: true,
                            overlayColor:
                                MaterialStatePropertyAll(kAccentColor),
                            labelColor: kPrimaryColor,
                            unselectedLabelColor: kTextGreyColor,
                            indicatorColor: kAccentColor,
                            indicatorWeight: 2,
                            splashBorderRadius: BorderRadius.circular(50),
                            indicator: BoxDecoration(
                              color: kAccentColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            tabs: const [
                              Tab(text: "Products"),
                              Tab(text: "Orders"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                kSizedBox,
                Container(
                  width: mediaWidth,
                  padding: const EdgeInsets.only(
                    left: kDefaultPadding / 2,
                    right: kDefaultPadding / 2,
                  ),
                  child: Column(
                    children: [
                      tabBar == 0
                          ?
                          // const VendorsTabBarProductsContentSkeleton()
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // CategoryButtonSection(
                                //   onPressed:
                                //       _changeProductCategory,
                                //   category:
                                //       _categoryButtonText,
                                //   categorybgColor:
                                //       _categoryButtonBgColor,
                                //   categoryFontColor:
                                //       _categoryButtonFontColor,
                                // ),

                                GetBuilder<VendorController>(
                                  initState: (state) async {
                                    await VendorController.instance
                                        .getVendorProduct(widget.vendor.id);
                                  },
                                  init: VendorController(),
                                  builder: (controller) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          controller.vendorProductList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return VendorsProductContainer(
                                          onTap: () {},
                                          product: controller
                                              .vendorProductList[index],
                                        );
                                      },
                                    );
                                  },
                                ),
                                GetBuilder<VendorController>(
                                  builder: (controller) => Column(
                                    children: [
                                      controller.isLoadMoreProduct.value
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                color: kAccentColor,
                                              ),
                                            )
                                          : const SizedBox(),
                                      controller.loadedAllProduct.value
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
                            )
                          // const VendorsTabBarOrdersContentSkeleton()
                          : Column(
                              children: [
                                GetBuilder<OrderController>(
                                  initState: (state) async {
                                    await OrderController.instance.getOrders();
                                  },
                                  init: OrderController(),
                                  builder: (controller) => ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.orderList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return VendorsOrderContainer(
                                        order: controller.orderList[index],
                                      );
                                    },
                                  ),
                                ),
                                GetBuilder<OrderController>(
                                  builder: (controller) => Column(
                                    children: [
                                      controller.isLoadMore.value
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                color: kAccentColor,
                                              ),
                                            )
                                          : const SizedBox(),
                                      controller.loadedAll.value
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
                      // const VendorsTabBarOrdersContentSkeleton()
                    ],
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
