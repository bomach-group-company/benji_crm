// ignore_for_file: unused_local_variable, unused_element

import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/src/providers/custom_show_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../controller/vendor_controller.dart';
import '../../../src/components/category_button_section.dart';
import '../../../src/components/my_appbar.dart';
import '../../../src/components/my_liquid_refresh.dart';
import '../../../src/components/vendor_orders_tab.dart';
import '../../../src/components/vendor_products_tab.dart';
import '../../../src/components/vendors_order_container.dart';
import '../../../src/components/vendors_product_container.dart';
import '../../../src/responsive/responsive_constant.dart';
import '../../../src/skeletons/vendors_tabbar_orders_content_skeleton.dart';
import '../../../src/skeletons/vendors_tabbar_products_content_skeleton.dart';
import '../../../theme/colors.dart';
import '../my_products/add_product.dart';
import '../my_products/my_product_details.dart';
import 'about_my_vendor.dart';
import 'delete_my_vendor.dart';
import 'my_vendors_location.dart';
import 'suspend_my_vendor.dart';

class MyVendorDetailsPage extends StatefulWidget {
  final String vendorCoverImage;
  final String vendorName;
  final String vendorRating;
  final String vendorAddress;
  final String vendorActiveStatus;
  final Color vendorActiveStatusColor;
  const MyVendorDetailsPage({
    super.key,
    required this.vendorCoverImage,
    required this.vendorName,
    required this.vendorRating,
    required this.vendorActiveStatus,
    required this.vendorActiveStatusColor,
    required this.vendorAddress,
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
  final String _vendorImage = "ntachi-osa-logo.png";

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
  final ScrollController scrollController = ScrollController();

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
              () => const SuspendMyVendor(),
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
              () => const DeleteMyVendor(),
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
        () => const AddProduct(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Add product",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _toVendorLocation() => Get.to(
        () => MyVendorLocation(
          vendorName: widget.vendorName,
          vendorAddress: widget.vendorAddress,
          vendorRating: widget.vendorRating,
        ),
        routeName: 'MyVendorLocation',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateAndTime = formatDateAndTime(now);
    var media = MediaQuery.of(context).size;
    double subtotalPrice = calculateSubtotal();
//==========================================================================\\
    return MyLiquidRefresh(
      onRefresh: _handleRefresh,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _toAddProduct,
          elevation: 20.0,
          mouseCursor: SystemMouseCursors.click,
          tooltip: "Add Product",
          backgroundColor: kAccentColor,
          foregroundColor: kPrimaryColor,
          child: const FaIcon(FontAwesomeIcons.plus),
        ),
        appBar: MyAppBar(
          title: "My Vendor Details",
          elevation: 0,
          backgroundColor: kPrimaryColor,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: kAccentColor,
              ),
            ),
            IconButton(
              onPressed: () => _showPopupMenu(context),
              icon: FaIcon(
                FontAwesomeIcons.ellipsisVertical,
                color: kAccentColor,
              ),
            ),
          ],
        ),
        body: SafeArea(
            maintainBottomViewPadding: true,
            child: _loadingScreen
                ? Center(child: CircularProgressIndicator(color: kAccentColor))
                : Scrollbar(
                    controller: scrollController,
                    radius: const Radius.circular(10),
                    scrollbarOrientation: ScrollbarOrientation.right,
                    child: ListView(
                      physics: const ScrollPhysics(),
                      dragStartBehavior: DragStartBehavior.down,
                      children: [
                        SizedBox(
                          height: deviceType(media.width) > 2 &&
                                  deviceType(media.width) < 4
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
                                      ? media.height * 0.325
                                      : deviceType(media.width) > 2
                                          ? media.height * 0.305
                                          : media.height * 0.28,
                                  decoration: BoxDecoration(
                                    color: kPageSkeletonColor,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                        "assets/images/vendors/${widget.vendorCoverImage}.png",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: deviceType(media.width) > 2
                                    ? media.height * 0.21
                                    : media.height * 0.13,
                                left: kDefaultPadding,
                                right: kDefaultPadding,
                                child: Container(
                                  width: 200,
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding / 2),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: media.width - 200,
                                          child: Text(
                                            widget.vendorName,
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
                                          width: media.width - 90,
                                          alignment: Alignment.center,
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
                                                width: media.width - 120,
                                                child: const Text(
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
                                        ),
                                        kHalfSizedBox,
                                        InkWell(
                                          onTap: _toVendorLocation,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
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
                                              width: media.width * 0.23,
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
                                                    widget.vendorRating,
                                                    style: const TextStyle(
                                                      color: kBlackColor,
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
                                              width: media.width * 0.25,
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
                                                  const Text(
                                                    "Online",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: kSuccessColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                    ? media.height * 0.12
                                    : deviceType(media.width) > 2
                                        ? media.height * 0.14
                                        : media.height * 0.08,
                                left: deviceType(media.width) > 3 &&
                                        deviceType(media.width) < 5
                                    ? media.width / 2.24
                                    : deviceType(media.width) > 2
                                        ? media.width / 2.36
                                        : media.width / 2.7,
                                child: Container(
                                  width:
                                      deviceType(media.width) > 2 ? 150 : 100,
                                  height:
                                      deviceType(media.width) > 2 ? 150 : 100,
                                  decoration: ShapeDecoration(
                                    color: kPageSkeletonColor,
                                    image: const DecorationImage(
                                      image: AssetImage(
                                        "assets/images/vendors/ntachi-osa-logo.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
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
                                _loadingTabBarContent
                                    ? const VendorsTabBarProductsContentSkeleton()
                                    : VendorsProductsTab(
                                        list: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CategoryButtonSection(
                                              onPressed: _changeProductCategory,
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
                                _loadingTabBarContent
                                    ? const VendorsTabBarOrdersContentSkeleton()
                                    : VendorsOrdersTab(
                                        list: Column(
                                          children: [
                                            for (_orderID = 1;
                                                _orderID < 30;
                                                _orderID += _incrementOrderID)
                                              VendorsOrderContainer(
                                                mediaWidth: media.width,
                                                orderImage: _orderImage,
                                                orderID: _orderID,
                                                formattedDateAndTime:
                                                    formattedDateAndTime,
                                                orderItem: _orderItem,
                                                itemQuantity: _orderQuantity,
                                                itemPrice: _itemPrice,
                                                customerName: _customerName,
                                                customerAddress:
                                                    _customerAddress,
                                                order: null,
                                              ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        kSizedBox,
                      ],
                    ),
                  )),
      ),
    );
  }
}
