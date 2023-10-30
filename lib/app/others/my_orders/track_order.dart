// ignore_for_file: unused_field

import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../controller/url_launch_controller.dart';
import '../../../src/components/button/my_elevatedButton.dart';
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
      const Duration(milliseconds: 1000),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  //=================================== CONTROLLERS ======================================================\\
  GoogleMapController? _googleMapController;

//=============================================== ALL VARIABLES ===================================================\\
  late bool _loadingScreen;
  String riderImage = "rider/martins_okafor.png";
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
      barrierColor: kBlackColor.withOpacity(0.5),
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(kDefaultPadding)),
      ),
      enableDrag: true,
      builder: (context) => SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
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
                    shape: const OvalBorder(),
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
                            style: const TextStyle(
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
                            style: const TextStyle(
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
                Container(
                  height: 48,
                  width: 48,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFDD5D5),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 0.40, color: Color(0xFFD4DAF0)),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: IconButton(
                    splashRadius: 30,
                    onPressed: () =>
                        UrlLaunchController.makePhoneCall("+237039502751"),
                    icon: FaIcon(
                      FontAwesomeIcons.phone,
                      color: kAccentColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//=============================================== Navigation ===================================================\\

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Track order",
        elevation: 10.0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: _loadingScreen
          ? SpinKitDoubleBounce(color: kAccentColor)
          : FutureBuilder(
              future: null,
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
                      title: "Track Order",
                      onPressed: _showModal,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
