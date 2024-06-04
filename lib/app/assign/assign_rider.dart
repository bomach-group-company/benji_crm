// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui; // Import the ui library with an alias

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/rider_assign_controller.dart';
import 'package:benji_aggregator/controller/rider_controller.dart';
import 'package:benji_aggregator/model/rider.dart';
import 'package:benji_aggregator/src/components/button/my_elevatedButton.dart';
import 'package:benji_aggregator/src/components/card/empty.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:benji_aggregator/src/utils/keys.dart';
import 'package:benji_aggregator/src/utils/network_utils.dart';
import 'package:benji_aggregator/src/utils/points.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../src/components/appbar/my_appbar.dart';
import '../../theme/colors.dart';

class AssignRiderMap extends StatefulWidget {
  final String itemId;
  final String itemType;
  const AssignRiderMap({
    super.key,
    required this.itemId,
    required this.itemType,
  });

  @override
  State<AssignRiderMap> createState() => _AssignRiderMapState();
}

class _AssignRiderMapState extends State<AssignRiderMap> {
  //============================================================== INITIAL STATE ====================================================================\\
  @override
  void initState() {
    super.initState();

    _loadMapData();
  }

  //============================================================= ALL VARIABLES ======================================================================\\

  //====================================== Setting Google Map Consts =========================================\\
  List<Rider>? riders;
  bool noRiderAvailable = false;
  final List<LatLng> _polylineCoordinates = [];
  final List<Marker> _markers = <Marker>[];

  bool loadingMap = true;
  int? selectedRider;
  final String _markerTitle = "Rider";
  final String _markerSnippet = "Rider location";

  final String _customMarkers = "assets/icons/delivery_bike.png";
  final String _selectedMarker = "assets/icons/package.png";
  //============================================================= BOOL VALUES ======================================================================\\

  //========================================================== GlobalKeys ============================================================\\

  //=================================== CONTROLLERS ======================================================\\
  final Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController? _newGoogleMapController;

  //============================================================== FUNCTIONS ===================================================================\\

  //======================================= Google Maps ================================================\\

  /// When the location services are not enabled or permissions are denied the `Future` will return an error.
  Future<void> _loadMapData() async {
    riders = await getAvailableRiders();
    print(riders);
    if (riders!.isEmpty) {
      setState(() {
        noRiderAvailable = true;
      });
      return;
    }
    setState(() {});
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Get.back();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    await _loadCustomMarkers();
    // getPolyPoints();
    setState(() {
      loadingMap = false;
    });
  }

//============================================== Get Current Location ==================================================\\

  //====================================== Get bytes from assets =========================================\\

  Future<Uint8List> _getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  //====================================== Get Location Markers =========================================\\

  _loadCustomMarkers() async {
    print("selectedRider _loadCustomMarkers");
    print(selectedRider);
    for (int i = 0; i < riders!.length; i++) {
      Uint8List markerIcon = await _getBytesFromAssets(_customMarkers, 100);
      Uint8List markerIcon2 = await _getBytesFromAssets(_selectedMarker, 100);

      _markers.add(
        Marker(
          onTap: () {
            setState(() {
              selectedRider = i;
            });
          },
          markerId: MarkerId("Rider$i"),
          icon: BitmapDescriptor.fromBytes(
              selectedRider == i ? markerIcon2 : markerIcon),
          position: LatLng(double.parse(riders![i].latitude),
              double.parse(riders![i].longitude)),
          infoWindow: InfoWindow(
            title: _markerTitle,
            snippet: _markerSnippet,
          ),
        ),
      );
      setState(() {});
    }
  }

  //============================================== Adding polypoints ==================================================\\
  void getPolyPoints(LatLng from, LatLng to) async {
    if (kIsWeb) {
      String routeStr =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}&mode=driving&avoidHighways=false&avoidFerries=true&avoidTolls=false&alternatives=false&key=$googleMapsApiKey';
      String? response = await NetworkUtility.fetchUrl(Uri.parse(routeStr));
      // var resp = await http.get(Uri.parse(routeStr));
      if (response == null) {
        return;
      }
      Map data = jsonDecode(response);
      if (data['routes'].isEmpty) {
        return;
      }

      var overviewPolyline = MyNetworkUtil().decodeEncodedPolyline(
          data['routes'][0]['overview_polyline']['points']);
      if (overviewPolyline.isNotEmpty) {
        for (var point in overviewPolyline) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        setState(() {});
      }
      return;
    }
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
      PointLatLng(from.latitude, from.longitude),
      PointLatLng(to.latitude, to.longitude),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {});
    }
  }

//============================================== Create Google Maps ==================================================\\

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController.complete(controller);
    _newGoogleMapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: MyAppBar(
        title: "Assign Rider",
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        actions: const [],
      ),
      body: noRiderAvailable
          ? const EmptyCard(
              onPressed: null,
              emptyCardMessage: "No available rider",
            )
          : Stack(
              children: [
                loadingMap
                    ? Center(
                        child: CircularProgressIndicator(
                          color: kAccentColor,
                        ),
                      )
                    : GoogleMap(
                        mapType: MapType.normal,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(double.parse(riders![0].latitude),
                              double.parse(riders![0].longitude)),
                          zoom: 18,
                        ),
                        markers: Set.of(_markers),
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId("Available Riders"),
                            points: _polylineCoordinates,
                            color: kAccentColor,
                            width: 4,
                          ),
                        },
                        padding: EdgeInsets.only(
                          bottom: selectedRider == null ? 50 : 250,
                        ),
                        compassEnabled: true,
                        mapToolbarEnabled: true,
                        minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                        tiltGesturesEnabled: true,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        fortyFiveDegreeImageryEnabled: true,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: false,
                        cameraTargetBounds: CameraTargetBounds.unbounded,
                        rotateGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                      ),
                loadingMap
                    ? const SizedBox()
                    : AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        left: 0,
                        right: 0,
                        bottom: selectedRider == null ? -200 : 0,
                        child: Container(
                          // width: 200,
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding,
                              vertical: kDefaultPadding),
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
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.50,
                                color: Color(0xFFFDEDED),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedRider = null;
                                    });
                                  },
                                  child: Text(
                                    selectedRider != null ? "Hide" : "",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: kAccentColor,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                width: media.width,
                                child: Text(
                                  "${riders![selectedRider ?? 0].firstName} ${riders![selectedRider ?? 0].lastName}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              kHalfSizedBox,
                              Container(
                                width: media.width,
                                alignment: Alignment.topLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.locationDot,
                                      color: kAccentColor,
                                      size: 15,
                                    ),
                                    kHalfWidthSizedBox,
                                    SizedBox(
                                      width: media.width - 200,
                                      child: Text(
                                        riders![selectedRider ?? 0].address,
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
                              kSizedBox,
                              GetBuilder<RiderAssignController>(
                                  builder: (controller) {
                                return MyElevatedButton(
                                  isLoading: controller.isLoad.value,
                                  title: "Assign task",
                                  onPressed: () async {
                                    final res =
                                        await controller.assignTaskToRider(
                                            widget.itemType,
                                            widget.itemId,
                                            riders![selectedRider ?? 0]
                                                .id
                                                .toString());
                                    if (res.statusCode == 200) {
                                      // nav to new page
                                      ApiProcessorController.successSnack(
                                          "Task assigned to rider");
                                      Get.close(1);
                                      return;
                                    }
                                    ApiProcessorController.errorSnack(
                                        jsonDecode(res.body)['detail']);
                                  },
                                );
                              }),
                              kHalfSizedBox
                            ],
                          ),
                        ),
                      ),
              ],
            ),
    );
  }
}
