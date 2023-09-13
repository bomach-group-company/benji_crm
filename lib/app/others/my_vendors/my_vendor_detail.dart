// ignore_for_file: unused_local_variable

import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/src/providers/custom_show_search.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/vendor_controller.dart';
import '../../../model/my_vendor.dart';
import '../../../src/common_widgets/category_button_section.dart';
import '../../../src/common_widgets/my_appbar.dart';
import '../../../src/common_widgets/vendor_orders_tab.dart';
import '../../../src/common_widgets/vendor_products_tab.dart';
import '../../../src/common_widgets/vendors_order_container.dart';
import '../../../src/common_widgets/vendors_product_container.dart';
import '../../../src/skeletons/vendors_tabbar_orders_content_skeleton.dart';
import '../../../src/skeletons/vendors_tabbar_products_content_skeleton.dart';
import '../../../theme/colors.dart';
import '../my_products/add_product.dart';
import '../my_products/my_product_details.dart';
import 'about_my_vendor.dart';
import 'delete_my_vendor.dart';
import 'suspend_my_vendor.dart';

class MyVendorDetailsPage extends StatefulWidget {
  final String vendorCoverImage;
  final String vendorName;
  final double vendorRating;
  final String vendorActiveStatus;
  final Color vendorActiveStatusColor;
  final MyVendorModel vendor;
  const MyVendorDetailsPage({
    super.key,
    required this.vendorCoverImage,
    required this.vendorName,
    required this.vendorRating,
    required this.vendorActiveStatus,
    required this.vendorActiveStatusColor,
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      VendorController.instance.listVendorProduct(widget.vendor.vendor!.id);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      VendorController.instance.listVendorOrder(widget.vendor.vendor!.id);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VendorController.instance.getSubCat();
    });
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

  //=================================== Vendor Details =======================================\\
  String _vendorImage = "ntachi-osa-logo.png";

  //=================================== Orders =======================================\\
  final int _incrementOrderID = 2 + 2;
  late int _orderID;
  final String _orderItem = "Jollof Rice and Chicken";
  final String _customerAddress = "21 Odogwu Street, New Haven";
  final int _orderQuantity = 2;
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
    return _itemPrice * _orderQuantity;
  }

  void _changeProductCategory() {}

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await VendorController.instance
          .listVendorProduct(widget.vendor.vendor!.id);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await VendorController.instance.listVendorOrder(widget.vendor.vendor!.id);
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

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _loadingTabBarContent = false;
    });
  }

  //=================================== Show Popup Menu =====================================\\
  //Show popup menu
  void _showPopupMenu(BuildContext context) {
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
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text("Delete vendor"),
        ),
      ],
    ).then((value) {
      // Handle the selected value from the popup menu
      if (value != null) {
        switch (value) {
          case 'about':
            Get.to(
              () => AboutMyVendor(
                vendorName: widget.vendorName,
                vendorHeadLine:
                    "Cruiselings whale shark diving pan Pacific romance at sea rusty dancemoves endless horizon home is where the anchor drops back packers Endless summer cruise insider paradise island languid afternoons the love boat cruise life.",
                monToFriOpeningHours: "8 AM",
                monToFriClosingHours: "10 PM",
                satOpeningHours: "8 AM",
                satClosingHours: "10 PM",
                sunClosingHours: "Closed",
                sunOpeningHours: "Closed",
              ),
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              routeName: "About my vendor",
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.rightToLeft,
            );
            break;
          case 'suspend':
            Get.to(
              () => SuspendMyVendor(),
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              routeName: "Suspend my vendor",
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.rightToLeft,
            );
            break;

          case 'delete':
            Get.to(
              () => DeleteMyVendor(),
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              routeName: "Delete my vendor",
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
  void toProductDetailScreen() => Get.to(
        () => MyProductDetails(
          productImage: _productImage,
          productName: _productName,
          productPrice: _productPrice,
          productDescription: _productDescription,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "My product details",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toAddProduct() => Get.to(
        () => AddProduct(
          vendor: widget.vendor,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Add product",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
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
        floatingActionButton: FloatingActionButton(
          onPressed: _toAddProduct,
          elevation: 20.0,
          mouseCursor: SystemMouseCursors.click,
          tooltip: "Add Product",
          backgroundColor: kAccentColor,
          foregroundColor: kPrimaryColor,
          child: const Icon(
            Icons.add,
          ),
        ),
        appBar: MyAppBar(
          title: "My Vendor Details",
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
              onPressed: () => _showPopupMenu(context),
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
              future: null,
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      decoration: BoxDecoration(
                                        color: kPageSkeletonColor,
                                        // image: DecorationImage(
                                        //   fit: BoxFit.cover,
                                        //   image: AssetImage(
                                        //       "assets/images/vendors/${widget.vendorCoverImage}.png"),
                                        // ),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            widget.vendor.vendor!.shopImage ??
                                                "",
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                          color: kRedColor,
                                        )),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error,
                                          color: kRedColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: MediaQuery.of(context).size.height *
                                        0.13,
                                    left: kDefaultPadding,
                                    right: kDefaultPadding,
                                    child: Container(
                                      width: 200,
                                      padding: const EdgeInsets.all(
                                          kDefaultPadding / 2),
                                      decoration: ShapeDecoration(
                                        shadows: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
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
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: kDefaultPadding * 2.6),
                                        child: Column(
                                          children: [
                                            Text(
                                              widget.vendor.vendor!.shopName ??
                                                  "",
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
                                                widget.vendor.vendor!.address ==
                                                        null
                                                    ? SizedBox.shrink()
                                                    : Icon(
                                                        Icons.location_pin,
                                                        color: kAccentColor,
                                                        size: 15,
                                                      ),
                                                widget.vendor.vendor!.address ==
                                                        null
                                                    ? SizedBox.shrink()
                                                    : kHalfWidthSizedBox,
                                                // width: mediaWidth - 100,
                                                Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth: 150),
                                                  child: Text(
                                                    widget.vendor.vendor!
                                                            .address ??
                                                        "",
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            kHalfSizedBox,
                                            InkWell(
                                              onTap: (() async {
                                                // final websiteurl = Uri.parse(
                                                //   "https://goo.gl/maps/8pKoBVCsew5oqjU49",
                                                // );
                                                // if (await canLaunchUrl(
                                                //   websiteurl,
                                                // )) {
                                                //   launchUrl(
                                                //     websiteurl,
                                                //     mode: LaunchMode
                                                //         .externalApplication,
                                                //   );
                                                // } else {
                                                //   throw "An unexpected error occured and $websiteurl cannot be loaded";
                                                // }
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
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        19,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        19,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.star_rounded,
                                                        color: kStarColor,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${double.tryParse(widget.vendor.vendor!.averageRating.toString())!.toStringAsFixed(1)}",
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
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              19),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        widget
                                                                    .vendor
                                                                    .vendor!
                                                                    .shopType!
                                                                    .isActive ==
                                                                true
                                                            ? "online"
                                                            : "offline",
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
                                                      Icon(
                                                        Icons.info_outline,
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
                                    top: MediaQuery.of(context).size.height *
                                        0.07,
                                    left:
                                        MediaQuery.of(context).size.width / 2.7,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: ShapeDecoration(
                                        color: kPageSkeletonColor,
                                        // image: DecorationImage(
                                        //   image: AssetImage(
                                        //     "assets/images/vendors/$_vendorImage",
                                        //   ),
                                        //   fit: BoxFit.cover,
                                        // ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(44),
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              widget.vendor.vendor!.shopImage ??
                                                  "",
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                            color: kRedColor,
                                          )),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error,
                                            color: kRedColor,
                                          ),
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
                                                  category: _categoryButtonText,
                                                  categorybgColor:
                                                      _categoryButtonBgColor,
                                                  categoryFontColor:
                                                      _categoryButtonFontColor,
                                                ),
                                                GetBuilder<VendorController>(
                                                  init: VendorController(),
                                                  builder: (controller) {
                                                    return Column(
                                                      children: [
                                                        ...controller
                                                            .vendorProductList
                                                            .map(
                                                          (element) =>
                                                              VendorsProductContainer(
                                                            onTap:
                                                                toProductDetailScreen,
                                                            productImage:
                                                                _productImage,
                                                            productName:
                                                                _productName,
                                                            productDescription:
                                                                _productDescription,
                                                            productPrice:
                                                                _productPrice,
                                                            productQuantity:
                                                                _productQuantity,
                                                            // ignore: invalid_use_of_protected_member
                                                            product: element,
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                    // _loadingTabBarContent
                                    //     ? const VendorsTabBarOrdersContentSkeleton()
                                    //     : VendorsOrdersTab(
                                    //         list: Column(
                                    //           children: [
                                    //             for (_orderID = 1;
                                    //                 _orderID < 30;
                                    //                 _orderID +=
                                    //                     _incrementOrderID)
                                    //               VendorsOrderContainer(
                                    //                 mediaWidth: mediaWidth,
                                    //                 orderImage: _orderImage,
                                    //                 orderID: _orderID,
                                    //                 formattedDateAndTime:
                                    //                     formattedDateAndTime,
                                    //                 orderItem: _orderItem,
                                    //                 itemQuantity:
                                    //                     _orderQuantity,
                                    //                 itemPrice: _itemPrice,
                                    //                 customerName: _customerName,
                                    //                 customerAddress:
                                    //                     _customerAddress,
                                    //                 order: null,
                                    //               ),
                                    //           ],
                                    //         ),
                                    //       ),
                                  ],
                                ),
                              ),
                            ),
                            kSizedBox,
                            // SizedBox(
                            //   height: mediaHeight + mediaHeight + mediaHeight,
                            //   width: mediaWidth,
                            //   child: Column(
                            //     children: [
                            //       Expanded(
                            //         child: TabBarView(
                            //           controller: _tabBarController,
                            //           physics: const BouncingScrollPhysics(),
                            //           dragStartBehavior: DragStartBehavior.down,
                            //           children: [
                            //             _loadingTabBarContent
                            //                 ? const VendorsTabBarProductsContentSkeleton()
                            //                 : VendorsProductsTab(
                            //                     list: Column(
                            //                       mainAxisAlignment:
                            //                           MainAxisAlignment.start,
                            //                       children: [
                            //                         CategoryButtonSection(
                            //                           onPressed:
                            //                               _changeProductCategory,
                            //                           category:
                            //                               _categoryButtonText,
                            //                           categorybgColor:
                            //                               _categoryButtonBgColor,
                            //                           categoryFontColor:
                            //                               _categoryButtonFontColor,
                            //                         ),
                            //                         for (int i = 0;
                            //                             i < foodListView.length;
                            //                             i++)
                            //                           VendorsProductContainer(
                            //                             onTap:
                            //                                 toProductDetailScreen,
                            //                             productImage:
                            //                                 _productImage,
                            //                             productName:
                            //                                 _productName,
                            //                             productDescription:
                            //                                 _productDescription,
                            //                             productPrice:
                            //                                 _productPrice,
                            //                             productQuantity:
                            //                                 _productQuantity,
                            //                             product: null,
                            //                           ),
                            //                       ],
                            //                     ),
                            //                   ),
                            //             _loadingTabBarContent
                            //                 ? const VendorsTabBarOrdersContentSkeleton()
                            //                 : VendorsOrdersTab(
                            //                     list: Column(
                            //                       children: [
                            //                         for (_orderID = 1;
                            //                             _orderID < 30;
                            //                             _orderID +=
                            //                                 _incrementOrderID)
                            //                           VendorsOrderContainer(
                            //                             mediaWidth: mediaWidth,
                            //                             orderImage: _orderImage,
                            //                             orderID: _orderID,
                            //                             formattedDateAndTime:
                            //                                 formattedDateAndTime,
                            //                             orderItem: _orderItem,
                            //                             itemQuantity:
                            //                                 _orderQuantity,
                            //                             itemPrice: _itemPrice,
                            //                             customerName:
                            //                                 _customerName,
                            //                             customerAddress:
                            //                                 _customerAddress,
                            //                             order: null,
                            //                           ),
                            //                       ],
                            //                     ),
                            //                   ),
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                      );
              }),
        ),
      ),
    );
  }
}
