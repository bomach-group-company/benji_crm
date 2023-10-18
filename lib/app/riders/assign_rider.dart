// ignore_for_file: file_names, unused_local_variable

import 'package:benji_aggregator/controller/rider_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/src/common_widgets/my_appbar.dart';
import 'package:benji_aggregator/src/common_widgets/my_outlined_elevatedButton.dart';
import 'package:benji_aggregator/src/providers/custom_show_search.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../model/order_list_model.dart';
import '../../model/rider_list_model.dart';
import '../../src/providers/constants.dart';
import '../../src/skeletons/assign_rider_page_skeleton.dart';
import 'riders_detail.dart';

class AssignRider extends StatefulWidget {
  final OrderItem? item;
  const AssignRider({super.key, required this.item});

  @override
  State<AssignRider> createState() => _AssignRiderState();
}

class _AssignRiderState extends State<AssignRider> {
  //===================== Initial State ==========================\\
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RiderController.instance.runTask();
    });
    super.initState();

    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

//============================= ALL VARIABLES ===============================\\
  late bool _loadingScreen;
  // final bool _assigningRider = false;
  final bool _isAssigned = false;
  String ridersImage = "rider/martins_okafor.png";
  String ridersName = "Martins Okafor";
  String ridersLocation = "Achara Layout";
  String ridersPhoneNumber = "08032300044";
  // final int _numberOfAvailableRider = 10;
  int noOfTrips = 238;

  //============================================== CONTROLLERS =================================================\\
  final ScrollController _scrollController = ScrollController();

//============================= FUNCTIONS ===============================\\

  void _seeMoreAvailableRiders() {}

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _loadingScreen = false;
    });
  }

  void toRidersDetailPage() => Get.to(
        () => RidersDetail(
            ridersImage: ridersImage,
            ridersName: ridersName,
            ridersPhoneNumber: ridersPhoneNumber,
            noOfTrips: noOfTrips,
            onlineIndicator: Container(
              height: 20,
              width: 20,
              decoration: const ShapeDecoration(
                color: kSuccessColor,
                shape: OvalBorder(),
              ),
            ),
            rider: null),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Rider details",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  //Rider Assigned
  void _processAssignRider(riderId) {
    RiderController.instance.assignRiderTask(
        UserController.instance.user.value.id, riderId, widget.item!.id!);
    // setState(() {
    //   _assigningRider = true;
    // });

    // // Simulating an asynchronous process
    // Future.delayed(const Duration(seconds: 3), () {
    //   setState(() {
    //     _assigningRider = false;
    //     _isAssigned = true;
    //   });
    // });
  }

  // void _callRider() => Get.to(
  //       () => CallPage(
  //         userName: ridersName,
  //         userImage: ridersImage,
  //         userPhoneNumber: ridersPhoneNumber,
  //       ),
  //       duration: const Duration(milliseconds: 300),
  //       fullscreenDialog: true,
  //       curve: Curves.easeIn,
  //       routeName: "Call rider",
  //       preventDuplicates: true,
  //       popGesture: true,
  //       transition: Transition.rightToLeft,
  //     );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    //=============================================================================\\

    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: kAccentColor,
      borderWidth: 5.0,
      backgroundColor: kPrimaryColor,
      height: 150,
      animSpeedFactor: 2,
      showChildOpacityTransition: false,
      child: Scaffold(
        appBar: MyAppBar(
          title: "Available Riders",
          elevation: 10.0,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: Icon(
                color: kAccentColor,
                Icons.search,
              ),
            ),
            kWidthSizedBox,
          ],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            controller: _scrollController,
            radius: const Radius.circular(10),
            scrollbarOrientation: ScrollbarOrientation.right,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(kDefaultPadding),
              children: [
                FutureBuilder(
                  future: null,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      SpinKitDoubleBounce(color: kAccentColor);
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
                        ? const AssignRiderPageSkeleton()
                        : GetBuilder<RiderController>(
                            init: RiderController(),
                            builder: (controller) {
                              return ListView.builder(
                                  itemCount: controller.riderList.length,
                                  addAutomaticKeepAlives: true,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    RiderItem rider =
                                        controller.riderList[index];
                                    return InkWell(
                                      onTap: _isAssigned
                                          ? toRidersDetailPage
                                          : null,
                                      child: Container(
                                        // width: max(mediaWidth, 374),
                                        margin: const EdgeInsets.only(
                                            bottom: kDefaultPadding / 2.5),
                                        padding: const EdgeInsets.all(
                                            kDefaultPadding / 2.5),
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
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
                                        child: Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration:
                                                      const ShapeDecoration(
                                                    // image: DecorationImage(
                                                    //   image: AssetImage(
                                                    //       "assets/images/$ridersImage"),
                                                    // ),
                                                    shape: OvalBorder(),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl: "",
                                                    fit: BoxFit.cover,
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        const Center(
                                                            child:
                                                                CupertinoActivityIndicator(
                                                      color: kRedColor,
                                                    )),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                      Icons.error,
                                                      color: kRedColor,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 5,
                                                  bottom: 0,
                                                  child: Container(
                                                    height: 10,
                                                    width: 10,
                                                    decoration:
                                                        const ShapeDecoration(
                                                      color: kSuccessColor,
                                                      shape: OvalBorder(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 70,
                                              width: 160,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 140,
                                                    child: Text(
                                                      "${rider.lastName} ${rider.firstName}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                  kHalfSizedBox,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: kAccentColor,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                          rider.address ?? "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                kTextGreyColor,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // _isAssigned
                                            //     ? SizedBox(
                                            //         width: 90,
                                            //         child:
                                            //             MyOutlinedElevatedButton(
                                            //           onPressed: () {},
                                            //           circularBorderRadius: 24,
                                            //           minimumSizeWidth: 80,
                                            //           minimumSizeHeight: 30,
                                            //           maximumSizeWidth: 80,
                                            //           maximumSizeHeight: 30,
                                            //           buttonTitle: "Call",
                                            //           titleFontSize: 12,
                                            //           elevation: 10.0,
                                            //         ),
                                            //       )
                                            //     :
                                            GetBuilder<RiderController>(
                                                init: RiderController(),
                                                builder: (assign) {
                                                  return assign.isLoadAssign
                                                              .value ==
                                                          true
                                                      ? SizedBox(
                                                          height: 30,
                                                          width: 40,
                                                          child: SpinKitFadingFour(
                                                              color:
                                                                  kAccentColor),
                                                        )
                                                      : SizedBox(
                                                          width: 90,
                                                          child:
                                                              MyOutlinedElevatedButton(
                                                            onPressed: () =>
                                                                _processAssignRider(
                                                                    rider.id),
                                                            circularBorderRadius:
                                                                24,
                                                            minimumSizeWidth:
                                                                80,
                                                            minimumSizeHeight:
                                                                30,
                                                            maximumSizeWidth:
                                                                80,
                                                            maximumSizeHeight:
                                                                30,
                                                            buttonTitle:
                                                                "Assign",
                                                            titleFontSize: 12,
                                                            elevation: 10.0,
                                                          ),
                                                        );
                                                })
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            });
                  },
                ),
                kSizedBox,
                _loadingScreen
                    ? const SizedBox(height: kDefaultPadding)
                    : TextButton(
                        onPressed: _seeMoreAvailableRiders,
                        child: Text(
                          "See more",
                          style: TextStyle(color: kAccentColor),
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
