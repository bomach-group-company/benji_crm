// ignore_for_file:  unused_local_variable

import 'package:benji_aggregator/src/skeletons/dashboard_page_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../src/common_widgets/dashboard_appBar.dart';
import '../../src/common_widgets/dashboard_orders_container.dart';
import '../../src/common_widgets/dashboard_rider_vendor_container.dart';
import '../../src/common_widgets/dashboard_showModalBottomSheet.dart';
import '../../src/providers/constants.dart';
import '../../src/skeletons/all_riders_page_skeleton.dart';
import '../../theme/colors.dart';
import '../others/add_product.dart';
import '../others/order_details.dart';
import '../riders/riders.dart';
import '../vendors/add_vendor.dart';
import '../vendors/vendors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

typedef ModalContentBuilder = Widget Function(BuildContext);

class _DashboardState extends State<Dashboard> {
//=================================== ALL VARIABLES =====================================\\
  late bool _loadingScreen;
  int incrementOrderID = 2 + 2;
  late int orderID;
  String orderItem = "Jollof Rice and Chicken";
  String customerAddress = "21 Odogwu Street, New Haven";
  int itemQuantity = 2;
  double price = 2500;
  double itemPrice = 2500;
  String orderImage = "chizzy's-food";
  String customerName = "Mercy Luke";

//============================================== CONTROLLERS =================================================\\
  final ScrollController scrollController = ScrollController();

//=================================== FUNCTIONS =====================================\\
  double calculateSubtotal() {
    return itemPrice * itemQuantity;
  }

//===================== Initial State ==========================\\
  @override
  void initState() {
    _loadingScreen = true;
    Future.delayed(
      const Duration(seconds: 3),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
    super.initState();
  }
//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _loadingScreen = false;
    });
  }

//=================================== Show Popup Menu =====================================\\
  void showPopupMenu(BuildContext context) {
    // Show the popup menu
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromLTRB(
      MediaQuery.of(context).size.width - 50,
      MediaQuery.of(context).size.height - 250,
      0,
      0,
    );

    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        const PopupMenuItem<String>(
          value: 'Add new Vendor',
          child: Text('Add new Vendor'),
        ),
        const PopupMenuItem<String>(
          value: 'Add new Product',
          child: Text('Add new Product'),
        ),
      ],
    ).then((value) {
      // Handle the selected value from the popup menu
      if (value != null) {
        switch (value) {
          case 'Add new Vendor':
            Get.to(
              () => const AddVendor(),
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              routeName: "Add vendor",
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.downToUp,
            );
            break;
          case 'Add new Product':
            Get.to(
              () => const AddProduct(),
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              routeName: "Add product",
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.downToUp,
            );
            break;
        }
      }
    });
  }

//=================================== Navigation =====================================\\

  void toSeeAllRiders() => Get.to(
        () => Riders(
          appBarBackgroundColor: kAccentColor,
          appTitleColor: kPrimaryColor,
          appBarSearchIconColor: kPrimaryColor,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "All Riders",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void toSeeAllVendors() => Get.to(
        () => Vendors(
          appBarBackgroundColor: kAccentColor,
          appTitleColor: kPrimaryColor,
          appBarSearchIconColor: kPrimaryColor,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "All Riders",
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

    //===================== Navigate to Order Details Page ================================\\
    void toOrderDetailsPage() => Get.to(
          () => OrderDetails(
            formatted12HrTime: formattedDateAndTime,
            orderID: orderID,
            orderImage: orderImage,
            orderItem: orderItem,
            itemQuantity: itemQuantity,
            subtotalPrice: subtotalPrice,
            customerName: customerName,
            customerAddress: customerAddress,
          ),
          duration: const Duration(milliseconds: 300),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "Order Details",
          preventDuplicates: true,
          popGesture: true,
          transition: Transition.downToUp,
        );

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showPopupMenu(context);
          },
          elevation: 20.0,
          backgroundColor: kAccentColor,
          foregroundColor: kPrimaryColor,
          child: const Icon(
            Icons.add,
          ),
        ),
        appBar: const DashboardAppBar(),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: FutureBuilder(builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              const AllRidersPageSkeleton();
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
                ? const DashboardPageSkeleton()
                : Scrollbar(
                    controller: scrollController,
                    radius: const Radius.circular(10),
                    scrollbarOrientation: ScrollbarOrientation.right,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(kDefaultPadding),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OrdersContainer(
                              containerColor: kPrimaryColor,
                              typeOfOrderColor: kTextGreyColor,
                              iconColor: kGreyColor1,
                              numberOfOrders: "20",
                              typeOfOrders: "Active",
                              onTap: () {
                                OrdersContainerBottomSheet(
                                  context,
                                  "20 Running",
                                  20,
                                );
                              },
                            ),
                            OrdersContainer(
                              containerColor: Colors.red.shade100,
                              typeOfOrderColor: kAccentColor,
                              iconColor: kAccentColor,
                              numberOfOrders: "5",
                              typeOfOrders: "Pending",
                              onTap: () {
                                OrdersContainerBottomSheet(
                                  context,
                                  "5 Pending",
                                  5,
                                );
                              },
                            ),
                          ],
                        ),
                        kSizedBox,
                        RiderVendorContainer(
                          onTap: toSeeAllVendors,
                          number: "390",
                          typeOf: "Vendors",
                          onlineStatus: "248 Online",
                        ),
                        kSizedBox,
                        RiderVendorContainer(
                          onTap: toSeeAllRiders,
                          number: "90",
                          typeOf: "Riders",
                          onlineStatus: "32 Online",
                        ),
                        const SizedBox(height: kDefaultPadding * 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 200,
                              child: Text(
                                "New Orders",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: SizedBox(
                                child: Text(
                                  "See All",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: kAccentColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        kSizedBox,
                        Column(
                          children: [
                            for (orderID = 1;
                                orderID < 30;
                                orderID += incrementOrderID)
                              InkWell(
                                onTap: toOrderDetailsPage,
                                borderRadius:
                                    BorderRadius.circular(kDefaultPadding),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: kDefaultPadding / 2,
                                  ),
                                  padding: const EdgeInsets.only(
                                    top: kDefaultPadding / 2,
                                    left: kDefaultPadding / 2,
                                    right: kDefaultPadding / 2,
                                  ),
                                  width: mediaWidth / 1.1,
                                  height: 150,
                                  decoration: ShapeDecoration(
                                    color: kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          kDefaultPadding),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x0F000000),
                                        blurRadius: 24,
                                        offset: Offset(0, 4),
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/products/$orderImage.png",
                                                ),
                                              ),
                                            ),
                                          ),
                                          kHalfSizedBox,
                                          Text(
                                            "#00${orderID.toString()}",
                                            style: TextStyle(
                                              color: kTextGreyColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                      kWidthSizedBox,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: mediaWidth / 1.55,
                                            // color: kAccentColor,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const SizedBox(
                                                  child: Text(
                                                    "Hot Kitchen",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  child: Text(
                                                    formattedDateAndTime,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          kHalfSizedBox,
                                          Container(
                                            color: kTransparentColor,
                                            width: 250,
                                            child: Text(
                                              orderItem,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          kHalfSizedBox,
                                          Container(
                                            width: 200,
                                            color: kTransparentColor,
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "x $itemQuantity",
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const TextSpan(text: "  "),
                                                  TextSpan(
                                                    text:
                                                        "₦ ${itemPrice.toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'sen',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          kHalfSizedBox,
                                          Container(
                                            color: kGreyColor1,
                                            height: 1,
                                            width: mediaWidth / 1.8,
                                          ),
                                          kHalfSizedBox,
                                          SizedBox(
                                            width: mediaWidth / 1.8,
                                            child: Text(
                                              customerName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: mediaWidth / 1.8,
                                            child: Text(
                                              customerAddress,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
