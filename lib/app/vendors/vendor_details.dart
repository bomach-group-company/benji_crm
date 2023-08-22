// ignore_for_file: unused_local_variable

import 'package:benji_aggregator/app/others/products/product_details.dart';
import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/src/providers/custom_show_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../src/common_widgets/category_button_section.dart';
import '../../src/common_widgets/my_appbar.dart';
import '../../src/common_widgets/vendor_orders_tab.dart';
import '../../src/common_widgets/vendor_products_tab.dart';
import '../../src/common_widgets/vendors_order_container.dart';
import '../../src/common_widgets/vendors_product_container.dart';
import '../../src/skeletons/vendors_tabbar_orders_content_skeleton.dart';
import '../../src/skeletons/vendors_tabbar_products_content_skeleton.dart';
import '../../theme/colors.dart';
import 'about_vendor.dart';
import 'suspend_vendor.dart';

class VendorDetailsPage extends StatefulWidget {
  final String vendorCoverImage;
  final String vendorName;
  final double vendorRating;
  final String vendorActiveStatus;
  final Color vendorActiveStatusColor;
  const VendorDetailsPage({
    super.key,
    required this.vendorCoverImage,
    required this.vendorName,
    required this.vendorRating,
    required this.vendorActiveStatus,
    required this.vendorActiveStatusColor,
  });

  @override
  State<VendorDetailsPage> createState() => _VendorDetailsPageState();
}

class _VendorDetailsPageState extends State<VendorDetailsPage>
    with SingleTickerProviderStateMixin {
  //========================================= INITIAL STATE AND DISPOSE =============================================\\
  @override
  void initState() {
    super.initState();

    _tabBarController = TabController(length: 2, vsync: this);
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
    _tabBarController.dispose();
    super.dispose();
  }
//==========================================================================================\\

  //=================================== ALL VARIABLES ====================================\\

//===================== BOOL VALUES =======================\\
  // bool isLoading = false;
  late bool _loadingScreen;
  bool _loadingTabBarContent = false;

  //=================================== Orders =======================================\\
  final int _incrementOrderID = 2 + 2;
  late int _orderID;
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
  final String _productQuantity = "3200";
  final String _productDescription =
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit, tenetur error, harum nesciunt ipsum debitis quas aliquid. Reprehenderit, quia. Quo neque error repudiandae fuga? Ipsa laudantium molestias eos  sapiente officiis modi at sunt excepturi expedita sint? Sed quibusdam recusandae alias error harum maxime adipisci amet laborum. Perspiciatis  minima nesciunt dolorem! Officiis iure rerum voluptates a cumque velit  quibusdam sed amet tempora. Sit laborum ab, eius fugit doloribus tenetur  fugiat, temporibus enim commodi iusto libero magni deleniti quod quam consequuntur! Commodi minima excepturi repudiandae velit hic maxime doloremque. Quaerat provident commodi consectetur veniam similique ad earum omnis ipsum saepe, voluptas, hic voluptates pariatur est explicabo fugiat, dolorum eligendi quam cupiditate excepturi mollitia maiores labore suscipit quas? Nulla, placeat. Voluptatem quaerat non architecto ab laudantium modi minima sunt esse temporibus sint culpa, recusandae aliquam numquam totam ratione voluptas quod exercitationem fuga. Possim";
  final double _productPrice = 1200;

  //=================================== CONTROLLERS ====================================\\
  late TabController _tabBarController;
  final ScrollController _scrollController = ScrollController();

//===================== KEYS =======================\\
  // final _formKey = GlobalKey<FormState>();

  //===================== CATEGORY BUTTONS =======================\\
  final List _categoryButtonText = [
    "Pasta",
    "Burgers",
    "Rice Dishes",
    "Chicken",
    "Snacks"
  ];

  final List<Color> _categoryButtonBgColor = [
    kAccentColor,
    kDefaultCategoryBackgroundColor,
    kDefaultCategoryBackgroundColor,
    kDefaultCategoryBackgroundColor,
    kDefaultCategoryBackgroundColor
  ];
  final List<Color> _categoryButtonFontColor = [
    kPrimaryColor,
    kTextGreyColor,
    kTextGreyColor,
    kTextGreyColor,
    kTextGreyColor
  ];

//===================== VENDORS LIST VIEW INDEX =======================\\
  List<int> foodListView = [0, 1, 3, 4, 5, 6];

//===================== FUNCTIONS =======================\\
  double calculateSubtotal() {
    return _itemPrice * _itemQuantity;
  }

  void _changeProductCategory() {}

  //===================== Number format ==========================\\
  String formattedText(int value) {
    final numberFormat = NumberFormat('#,##0');
    return numberFormat.format(value);
  }

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

  void _clickOnTabBarOption() async {
    setState(() {
      _loadingTabBarContent = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _loadingTabBarContent = false;
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
          value: 'suspend',
          child: Text("Suspend vendor"),
        ),
      ],
    ).then((value) {
      // Handle the selected value from the popup menu
      if (value != null) {
        switch (value) {
          case 'about':
            _toAboutVendor();
            break;
          case 'suspend':
            _toSuspendVendor();
            break;
        }
      }
    });
  }

  //===================== Navigation ==========================\\
  void toProductDetailScreen() => Get.to(
        () => ProductDetails(
          productImage: _productImage,
          productName: _productName,
          productPrice: _productPrice,
          productDescription: _productDescription,
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
          vendorName: widget.vendorName,
          vendorHeadLine:
              "Cruiselings whale shark diving pan Pacific romance at sea rusty dancemoves endless horizon home is where the anchor drops back packers Endless summer cruise insider paradise island languid afternoons the love boat cruise life.",
          monToFriOpeningHours: "8 AM",
          monToFriClosingHours: "10 PM",
          satOpeningHours: "8 AM",
          satClosingHours: "10 PM",
          sunOpeningHours: "8 AM",
          sunClosingHours: "10 PM",
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
        () => SuspendVendor(),
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
          elevation: 10.0,
          backgroundColor: kPrimaryColor,
          toolbarHeight: 40,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: Icon(
                Icons.search,
                color: kAccentColor,
              ),
            ),
            IconButton(
              onPressed: () => showPopupMenu(context),
              icon: Icon(
                Icons.more_vert,
                color: kAccentColor,
              ),
            ),
          ],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                Center(child: SpinKitDoubleBounce(color: kAccentColor));
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
                  ? Center(child: SpinKitDoubleBounce(color: kAccentColor))
                  : Scrollbar(
                      controller: _scrollController,
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        dragStartBehavior: DragStartBehavior.down,
                        children: [
                          SizedBox(
                            height: 340,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    decoration: BoxDecoration(
                                      color: kPageSkeletonColor,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/images/vendors/${widget.vendorCoverImage}.png"),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top:
                                      MediaQuery.of(context).size.height * 0.13,
                                  left: kDefaultPadding,
                                  right: kDefaultPadding,
                                  child: Container(
                                    width: 200,
                                    padding: const EdgeInsets.all(
                                        kDefaultPadding / 2),
                                    decoration: ShapeDecoration(
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
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
                                        children: [
                                          Text(
                                            widget.vendorName,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: kTextBlackColor,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          kHalfSizedBox,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color: kAccentColor,
                                                size: 15,
                                              ),
                                              kHalfWidthSizedBox,
                                              SizedBox(
                                                width: mediaWidth - 100,
                                                child: Text(
                                                  "Old Abakaliki Rd, Thinkers Corner 400103, Enugu",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          kHalfSizedBox,
                                          InkWell(
                                            onTap: (() async {
                                              final websiteurl = Uri.parse(
                                                "https://goo.gl/maps/8pKoBVCsew5oqjU49",
                                              );
                                              if (await canLaunchUrl(
                                                websiteurl,
                                              )) {
                                                launchUrl(
                                                  websiteurl,
                                                  mode: LaunchMode
                                                      .externalApplication,
                                                );
                                              } else {
                                                throw "An unexpected error occured and $websiteurl cannot be loaded";
                                              }
                                            }),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              width: mediaWidth / 4,
                                              padding: const EdgeInsets.all(
                                                  kDefaultPadding / 4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: kAccentColor,
                                                  width: 1,
                                                ),
                                              ),
                                              child: const Text(
                                                "Show on map",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
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
                                                width: mediaWidth * 0.25,
                                                height: 56.67,
                                                decoration: ShapeDecoration(
                                                  color: kPrimaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      19,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .access_time_outlined,
                                                      color: kAccentColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    const Text(
                                                      "30 mins",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        letterSpacing: -0.28,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: mediaWidth * 0.23,
                                                height: 56.67,
                                                decoration: ShapeDecoration(
                                                  color: kPrimaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      19,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.star_rounded,
                                                      color: kStarColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "${widget.vendorRating}",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        letterSpacing: -0.28,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: mediaWidth * 0.25,
                                                height: 56.67,
                                                decoration: ShapeDecoration(
                                                  color: kPrimaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            19),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      widget.vendorActiveStatus,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: widget
                                                            .vendorActiveStatusColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        letterSpacing: -0.36,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    InkWell(
                                                      onTap: _toAboutVendor,
                                                      child: Icon(
                                                        Icons.info_outline,
                                                        color: kAccentColor,
                                                      ),
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
                                  top:
                                      MediaQuery.of(context).size.height * 0.07,
                                  left: MediaQuery.of(context).size.width / 2.7,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: ShapeDecoration(
                                      color: kPageSkeletonColor,
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          "assets/images/vendors/ntachi-osa-logo.png",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(43.50),
                                      ),
                                    ),
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
                                      onTap: (value) => _clickOnTabBarOption(),
                                      enableFeedback: true,
                                      mouseCursor: SystemMouseCursors.click,
                                      automaticIndicatorColorAdjustment: true,
                                      overlayColor: MaterialStatePropertyAll(
                                          kAccentColor),
                                      labelColor: kPrimaryColor,
                                      unselectedLabelColor: kTextGreyColor,
                                      indicatorColor: kAccentColor,
                                      indicatorWeight: 2,
                                      splashBorderRadius:
                                          BorderRadius.circular(50),
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
                            height: mediaHeight,
                            width: mediaWidth,
                            padding: const EdgeInsets.only(
                              left: kDefaultPadding / 2,
                              right: kDefaultPadding / 2,
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TabBarView(
                                    controller: _tabBarController,
                                    physics: const BouncingScrollPhysics(),
                                    dragStartBehavior: DragStartBehavior.down,
                                    children: [
                                      _loadingTabBarContent
                                          ? const VendorsTabBarProductsContentSkeleton()
                                          : VendorsProductsTab(
                                              list: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CategoryButtonSection(
                                                    onPressed:
                                                        _changeProductCategory,
                                                    category:
                                                        _categoryButtonText,
                                                    categorybgColor:
                                                        _categoryButtonBgColor,
                                                    categoryFontColor:
                                                        _categoryButtonFontColor,
                                                  ),
                                                  for (int i = 0;
                                                      i < foodListView.length;
                                                      i++)
                                                    VendorsProductContainer(
                                                      onTap:
                                                          toProductDetailScreen,
                                                      productImage:
                                                          _productImage,
                                                      productName: _productName,
                                                      productDescription:
                                                          _productDescription,
                                                      productPrice:
                                                          _productPrice,
                                                      productQuantity:
                                                          _productQuantity,
                                                    ),
                                                ],
                                              ),
                                            ),
                                      _loadingTabBarContent
                                          ? const VendorsTabBarOrdersContentSkeleton()
                                          : VendorsOrdersTab(
                                              list: Column(
                                                children: [
                                                  for (_orderID = 1;
                                                      _orderID < 30;
                                                      _orderID +=
                                                          _incrementOrderID)
                                                    VendorsOrderContainer(
                                                      mediaWidth: mediaWidth,
                                                      orderImage: _orderImage,
                                                      orderID: _orderID,
                                                      formattedDateAndTime:
                                                          formattedDateAndTime,
                                                      orderItem: _orderItem,
                                                      itemQuantity:
                                                          _itemQuantity,
                                                      itemPrice: _itemPrice,
                                                      customerName:
                                                          _customerName,
                                                      customerAddress:
                                                          _customerAddress,
                                                    ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
