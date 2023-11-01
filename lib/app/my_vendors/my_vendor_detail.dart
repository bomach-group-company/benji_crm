// ignore_for_file: unused_local_variable, unused_element

import 'package:benji_aggregator/controller/order_controller.dart';
import 'package:benji_aggregator/model/my_vendor_model.dart';
import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/src/providers/custom_show_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/vendor_controller.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/container/vendors_order_container.dart';
import '../../src/components/container/vendors_product_container.dart';
import '../../src/components/section/my_liquid_refresh.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../theme/colors.dart';
import '../my_products/add_product.dart';
import '../my_products/my_product_details.dart';
import 'about_my_vendor.dart';
import 'delete_my_vendor.dart';
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

  int tabBar = 0;

  //=================================== Orders =======================================\\
  final int _orderQuantity = 2;
  // final double _price = 2500;
  final double _itemPrice = 2500;

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
  List<int> foodListView = [0, 1, 3, 4, 5, 6];

//===================== FUNCTIONS =======================\\
  double calculateSubtotal() {
    return _itemPrice * _orderQuantity;
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
                vendorName: widget.vendor.shopName,
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
              () => ReportMyVendor(vendor: widget.vendor),
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

  void toVendorLocation() => Get.to(
        () => MyVendorLocation(
          vendorName: widget.vendor.shopName,
          vendorAddress: widget.vendor.address,
          vendorRating: widget.vendor.averageRating.toString(),
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
            child: Scrollbar(
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
                                ? media.height * 0.4
                                : deviceType(media.width) > 2
                                    ? media.height * 0.415
                                    : media.height * 0.28,
                            decoration: BoxDecoration(
                              color: kPageSkeletonColor,
                              image: const DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  "assets/images/vendors/ntachi-osa.png",
                                ),
                              ),
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
                                    width: media.width - 200,
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
                                    onTap: widget.vendor.address.isEmpty
                                        ? null
                                        : toVendorLocation,
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
                                        widget.vendor.address.isEmpty
                                            ? notAvailable
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
                                            Text(
                                              widget.vendor.isOnline == false
                                                  ? "Online"
                                                  : 'Offline',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: widget.vendor.isOnline ==
                                                        false
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
                          top: deviceType(media.width) > 3 &&
                                  deviceType(media.width) < 5
                              ? media.height * 0.15
                              : deviceType(media.width) > 2
                                  ? media.height * 0.15
                                  : media.height * 0.08,
                          left: deviceType(media.width) > 2
                              ? (media.width / 2) - (126 / 2)
                              : (media.width / 2) - (100 / 2),
                          child: Container(
                            width: deviceType(media.width) > 2 ? 126 : 100,
                            height: deviceType(media.width) > 2 ? 126 : 100,
                            decoration: ShapeDecoration(
                              color: kPageSkeletonColor,
                              image: const DecorationImage(
                                image: AssetImage(
                                  "assets/images/vendors/ntachi-osa-logo.png",
                                ),
                                fit: BoxFit.cover,
                              ),
                              shape: const OvalBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: media.height,
                    width: media.width,
                    padding: const EdgeInsets.only(
                      left: kDefaultPadding / 2,
                      right: kDefaultPadding / 2,
                    ),
                    child: Column(
                      children: [
                        tabBar == 0
                            ?
                            //  const VendorsTabBarProductsContentSkeleton()
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // CategoryButtonSection(
                                  //   onPressed: _changeProductCategory,
                                  //   category: _categoryButtonText,
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
                                    builder: (controller) {
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) =>
                                            kSizedBox,
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
                                  )
                                ],
                              )
                            //  const VendorsTabBarOrdersContentSkeleton()
                            : GetBuilder<OrderController>(
                                initState: (state) async {
                                  await OrderController.instance.getOrders();
                                },
                                builder: (controller) => ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: controller.orderList.length,
                                  separatorBuilder: (context, index) =>
                                      kSizedBox,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return VendorsOrderContainer(
                                      order: controller.orderList[index],
                                    );
                                  },
                                ),
                              ),
                      ],
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
