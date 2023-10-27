// ignore_for_file: unused_field, library_prefixes

import 'dart:async';
import 'dart:ui' as ui; // Import the ui library with an alias

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controller/latlng_detail_controller.dart';
import '../../src/components/my_appbar.dart';
import '../../src/components/my_elevatedButton.dart';
import '../../src/components/my_textformfield.dart';
import '../../src/googleMaps/location_service.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class GetLocationOnMap extends StatefulWidget {
  const GetLocationOnMap({super.key});

  @override
  State<GetLocationOnMap> createState() => _GetLocationOnMapState();
}

class _GetLocationOnMapState extends State<GetLocationOnMap> {
  //============================================================== INITIAL STATE ====================================================================\\

  @override
  void initState() {
    super.initState();
    pinnedLocation = "";
    _markerTitle = <String>["Me"];
    _markerSnippet = <String>["My Location"];
    _loadMapData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //============================================================= ALL VARIABLES ======================================================================\\
  String? pinnedLocation;
  final latLngDetailController = Get.put(LatLngDetailController());
  //============================================================= BOOL VALUES ======================================================================\\
  bool locationPinIsVisible = true;

  //====================================== Setting Google Map Consts =========================================\\

  Position? _userPosition;
  CameraPosition? _cameraPosition;

  Uint8List? _markerImage;
  late LatLng draggedLatLng;
  final List<Marker> _markers = <Marker>[];
  final List<MarkerId> _markerId = <MarkerId>[
    const MarkerId("0"),
  ];
  List<String>? _markerTitle;
  List<String>? _markerSnippet;
  final List<String> _customMarkers = <String>[
    "assets/icons/person_location.png",
  ];

  //=================================== CONTROLLERS ======================================================\\
  final _searchEC = TextEditingController();
  final Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController? _newGoogleMapController;

  //=================================== FOCUS NODES ======================================================\\
  final _searchFN = FocusNode();

  //======================================= Google Maps ================================================\\

  /// When the location services are not enabled or permissions are denied the `Future` will return an error.
  Future<void> _loadMapData() async {
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
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    await _getAndGoToUserCurrentLocation();
    await _loadCustomMarkers();
  }

//============================================== Get Current Location ==================================================\\

  Future<Position> _getAndGoToUserCurrentLocation() async {
    Position userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then(
      (location) => _userPosition = location,
    );

    LatLng latLngPosition =
        LatLng(userLocation.latitude, userLocation.longitude);
    setState(() {
      draggedLatLng = latLngPosition;
    });
    _cameraPosition = CameraPosition(target: latLngPosition, zoom: 20);

    _newGoogleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(_cameraPosition!),
    );

    return userLocation;
  }

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
    Position userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then(
      (location) => _userPosition = location,
    );
    List<LatLng> latLng = <LatLng>[
      LatLng(userLocation.latitude, userLocation.longitude),
    ];
    for (int i = 0; i < _customMarkers.length; i++) {
      final Uint8List markerIcon =
          await _getBytesFromAssets(_customMarkers[i], 100);

      _markers.add(
        Marker(
          markerId: _markerId[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
          position: latLng[i],
          infoWindow: InfoWindow(
            title: _markerTitle![i],
            snippet: _markerSnippet![i],
          ),
        ),
      );
      setState(() {});
    }
  }

//========================================================== Locate a place =============================================================\\

  Future<void> _locatePlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    _goToSpecifiedLocation(LatLng(lat, lng), 20);
    if (kDebugMode) {
      print(LatLng(lat, lng));
    }
    // _markers.add(
    //   Marker(
    //     markerId: const MarkerId("1"),
    //     icon: BitmapDescriptor.defaultMarker,
    //     position: LatLng(lat, lng),
    //     infoWindow: InfoWindow(
    //       title: _searchEC.text,
    //       snippet: "Pinned Location",
    //     ),
    //   ),
    // );
  }

  void _searchPlaceFunc() async {
    setState(() {
      locationPinIsVisible = false;
    });
    var place = await LocationService().getPlace(_searchEC.text);
    _locatePlace(place);
  }

//============================================== Go to specified location by LatLng ==================================================\\
  Future _goToSpecifiedLocation(LatLng position, double zoom) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: position,
      zoom: zoom,
    )));
    await _getPlaceMark(position);
  }

//========================================================== Get PlaceMark Address and LatLng =============================================================\\

  Future _getPlaceMark(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark address = placemarks[0];
    String addressStr =
        "${address.name} ${address.street},${address.locality}, ${address.country}";
    if (kDebugMode) {
      print(LatLng(position.latitude, position.longitude));
    }
    setState(() {
      pinnedLocation = addressStr;
    });
  }

//==================== Select Location using ===============\\
  void _selectLocation() async {
    _getPlaceMark(draggedLatLng);
  }

//============================================== Create Google Maps ==================================================\\

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController.complete(controller);
    _newGoogleMapController = controller;
  }

//========================================================== Save Function =============================================================\\
  _saveFunc() async {
    _getPlaceMark(draggedLatLng);
    if (kDebugMode) {
      print("draggedLatLng: $draggedLatLng");
      print("PinnedLocation: $pinnedLocation");
    }
    String latitude = draggedLatLng.latitude.toString();
    String longitude = draggedLatLng.longitude.toString();
    latLngDetailController
        .setLatLngdetail([latitude, longitude, pinnedLocation]);

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        appBar: MyAppBar(
          title: "Locate on Map",
          elevation: 0.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: _selectLocation,
          backgroundColor: kAccentColor,
          tooltip: "Pin Location",
          mouseCursor: SystemMouseCursors.click,
          child: const FaIcon(
            FontAwesomeIcons.locationDot,
            size: 18,
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kPrimaryColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(TextSpan(children: [
                const TextSpan(
                  text: "Pinned Location: ",
                  style: TextStyle(
                    color: kTextBlackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: pinnedLocation!),
              ])),
              kHalfSizedBox,
              MyElevatedButton(title: "Save", onPressed: _saveFunc),
            ],
          ),
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: _userPosition == null
              ? Center(
                  child: CircularProgressIndicator(
                    color: kAccentColor,
                  ),
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: MyTextFormField(
                            controller: _searchEC,
                            focusNode: _searchFN,
                            hintText: "Enter your search",
                            textInputType: TextInputType.text,
                            validator: (value) {
                              return null;
                            },
                            textInputAction: TextInputAction.search,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (value) {
                              if (kDebugMode) {
                                print(value);
                              }
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: _searchPlaceFunc,
                          icon: FaIcon(
                            FontAwesomeIcons.magnifyingGlass,
                            size: 18,
                            color: kAccentColor,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          GoogleMap(
                            mapType: MapType.normal,
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                _userPosition!.latitude,
                                _userPosition!.longitude,
                              ),
                              zoom: 20,
                            ),
                            onCameraIdle: () {
                              setState(() {
                                locationPinIsVisible = true;
                              });
                              _getPlaceMark(draggedLatLng);
                            },
                            onCameraMove: (cameraPosition) {
                              setState(() {
                                locationPinIsVisible = true;
                                draggedLatLng = cameraPosition.target;
                              });
                            },
                            markers: Set.of(_markers),
                            compassEnabled: true,
                            mapToolbarEnabled: true,
                            minMaxZoomPreference:
                                MinMaxZoomPreference.unbounded,
                            tiltGesturesEnabled: true,
                            zoomControlsEnabled: false,
                            zoomGesturesEnabled: true,
                            fortyFiveDegreeImageryEnabled: true,
                            myLocationButtonEnabled: true,
                            liteModeEnabled: false,
                            myLocationEnabled: true,
                            cameraTargetBounds: CameraTargetBounds.unbounded,
                            rotateGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                          ),
                          locationPinIsVisible == false
                              ? const SizedBox()
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 50),
                                    child: Image.asset(
                                      "assets/icons/location_pin.png",
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
