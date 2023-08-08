import 'package:benji_aggregator/app/others/call_page.dart';
import 'package:benji_aggregator/src/common_widgets/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../src/common_widgets/my_elevatedButton.dart';
import '../../../src/providers/constants.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder({super.key});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
//=============================================== INITIAL STATE AND DISPOSE ===================================================\\
  @override
  void initState() {
    super.initState();
    _loadingScreen = true;
    Future.delayed(
      const Duration(seconds: 2),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //=================================== CONTROLLERS ======================================================\\
  GoogleMapController? _googleMapController;

//=============================================== ALL VARIABLES ===================================================\\
  late bool _loadingScreen;
  String riderImage = "rider/martins-okafor.png";
  String riderName = "Martins Okafor";
  String riderPhoneNumber = "09047589382";

  final LatLng _latLng = const LatLng(
    6.456076934514027,
    7.507987759047121,
  );

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

//=============================================== FUNCTIONS ===================================================\\

  void _showModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kPrimaryColor,
      barrierColor: kBlackColor.withOpacity(
        0.5,
      ),
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(kDefaultPadding)),
      ),
      enableDrag: true,
      builder: (context) => SingleChildScrollView(
        physics: ScrollPhysics(),
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Delivery Officer",
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            kSizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/$riderImage",
                      ),
                      fit: BoxFit.cover,
                    ),
                    shape: OvalBorder(),
                  ),
                ),
                // kWidthSizedBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 30,
                          child: Text(
                            riderName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: kTextBlackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 30,
                          child: Text(
                            riderPhoneNumber,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: kTextBlackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: kAccentColor,
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "3.2km away",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: kTextGreyColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                IconButton.filled(
                  onPressed: _callRider,
                  icon: Icon(
                    Icons.phone_rounded,
                  ),
                  color: kAccentColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//=============================================== Navigation ===================================================\\
  void _callRider() => Get.to(
        () => CallPage(
          userImage: riderImage,
          userName: riderName,
          userPhoneNumber: riderPhoneNumber,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Call screen",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Track order",
        elevation: 0.0,
        actions: [],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: _loadingScreen
          ? SpinKitDoubleBounce(color: kAccentColor)
          : FutureBuilder(
              builder: (context, snapshot) => Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    buildingsEnabled: true,
                    compassEnabled: false,
                    indoorViewEnabled: true,
                    mapToolbarEnabled: true,
                    minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                    tiltGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    cameraTargetBounds: CameraTargetBounds.unbounded,
                    rotateGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    trafficEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: _latLng,
                      zoom: 20.0,
                      tilt: 16,
                    ),
                    onMapCreated: _onMapCreated,
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 25,
                    child: MyElevatedButton(
                      buttonTitle: "Track Order",
                      onPressed: _showModal,
                      circularBorderRadius: 16,
                      elevation: 10.0,
                      maximumSizeHeight: 60,
                      maximumSizeWidth: 60,
                      minimumSizeHeight: 60,
                      minimumSizeWidth: 60,
                      titleFontSize: 14,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
