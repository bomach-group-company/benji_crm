// ignore_for_file: use_build_context_synchronously, invalid_use_of_protected_member

import 'dart:async';
import 'dart:io';

import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/google_maps/get_location_on_map.dart';
import '../../controller/latlng_detail_controller.dart';
import '../../services/keys.dart';
import '../../theme/colors.dart';
import '../googleMaps/autocomplete_prediction.dart';
import '../googleMaps/places_autocomplete_response.dart';
import '../providers/constants.dart';
import '../responsive/responsive_constant.dart';
import '../utils/network_utils.dart';
import 'location_list_tile.dart';
import 'my_elevatedButton.dart';
import 'my_floating_snackbar.dart';
import 'my_maps_textformfield.dart';
import 'name_textformfield.dart';

class PersonalInfoBody extends StatefulWidget {
  const PersonalInfoBody({Key? key}) : super(key: key);

  @override
  State<PersonalInfoBody> createState() => _PersonalInfoBodyState();
}

class _PersonalInfoBodyState extends State<PersonalInfoBody> {
  //==========================================================================================\\
  @override
  void initState() {
    userCode = UserController.instance.user.value.code;
    usernameEC.text = UserController.instance.user.value.username;
    super.initState();

    _loadingScreen = true;
    _timer = Timer(
      const Duration(milliseconds: 1000),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    selectedLocation.dispose();
    _scrollController.dispose();
  }

//==========================================================================================\\

//======================================== ALL VARIABLES ==============================================\\
  late Timer _timer;
  final String countryDialCode = '234';
  String? userCode;
  String? latitude;
  String? longitude;

  List<AutocompletePrediction> placePredictions = [];
  final selectedLocation = ValueNotifier<String?>(null);

  //=========================== BOOL VALUES ====================================\\
  late bool _loadingScreen;
  bool _isLoading = false;
  bool _typing = false;

  //======================================== GLOBAL KEYS ==============================================\\
  final _formKey = GlobalKey<FormState>();

  //=========================== CONTROLLERS ====================================\\
  final _scrollController = ScrollController();
  final usernameEC = TextEditingController();
  final mapsLocationEC = TextEditingController();
  final LatLngDetailController latLngDetailController =
      Get.put(LatLngDetailController());

  //=========================== FOCUS NODES ====================================\\
  final usernameFN = FocusNode();
  final mapsLocationFN = FocusNode();

  //=========================== IMAGE PICKER ====================================\\

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  //=========================== WIDGETS ====================================\\
  Widget _profilePicBottomSheet() {
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(
        left: kDefaultPadding,
        right: kDefaultPadding,
        bottom: kDefaultPadding,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Profile photo",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          kSizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      uploadProfilePic(ImageSource.camera);
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: const BorderSide(
                            width: 0.5,
                            color: kGreyColor1,
                          ),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.camera,
                          color: kAccentColor,
                        ),
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  const Text("Camera"),
                ],
              ),
              kWidthSizedBox,
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      uploadProfilePic(ImageSource.gallery);
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: const BorderSide(
                            width: 0.5,
                            color: kGreyColor1,
                          ),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.image,
                          color: kAccentColor,
                        ),
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  const Text(
                    "Gallery",
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  //===================== Profile Picture ==========================\\

  uploadProfilePic(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
      // User? user = await getUser();
      // final url =
      //     Uri.parse('$baseURL/clients/changeClientProfileImage/${user!.id}');

      // Create a multipart request
      // final request = http.MultipartRequest('PUT', url);

      // Set headers
      // request.headers.addAll(await authHeader());

      // Add the image file to the request
      // request.files.add(http.MultipartFile(
      //   'image',
      //   selectedImage!.readAsBytes().asStream(),
      //   selectedImage!.lengthSync(),
      //   filename: 'image.jpg',
      //   contentType:
      //       MediaType('image', 'jpeg'), // Adjust content type as needed
      // ));

      // Send the request and await the response
      // final http.StreamedResponse response = await request.send();

      // Check if the request was successful (status code 200)
      // if (response.statusCode == 200) {
      //   // Image successfully uploaded
      //   if (kDebugMode) {
      //     print(await response.stream.bytesToString());
      //     print('Image uploaded successfully');
      //   }
      // } else {
      //   // Handle the error (e.g., server error)
      //   if (kDebugMode) {
      //     print('Error uploading image: ${response.reasonPhrase}');
      //   }
      // }
    }
  }

  //========================================================================\\
  //=========================== FUNCTIONS ====================================\\
  //Google Maps
  _setLocation(index) async {
    final newLocation = placePredictions[index].description!;
    selectedLocation.value = newLocation;

    setState(() {
      mapsLocationEC.text = newLocation;
    });

    List<Location> location = await locationFromAddress(newLocation);
    latitude = location[0].latitude.toString();
    longitude = location[0].longitude.toString();
  }

  void placeAutoComplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        '/maps/api/place/autocomplete/json', //unencoder path
        {
          "input": query, //query params
          "key": googlePlacesApiKey, //google places api key
        });

    String? response = await NetworkUtility.fetchUrl(uri);
    PlaceAutocompleteResponse result =
        PlaceAutocompleteResponse.parseAutoCompleteResult(response!);
    if (result.predictions != null) {
      setState(() {
        placePredictions = result.predictions!;
      });
    }
  }

  void _toGetLocationOnMap() async {
    await Get.to(
      () => const GetLocationOnMap(),
      routeName: 'GetLocationOnMap',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    latitude = latLngDetailController.latLngDetail.value[0];
    longitude = latLngDetailController.latLngDetail.value[1];
    mapsLocationEC.text = latLngDetailController.latLngDetail.value[2];
    latLngDetailController.setEmpty();
    if (kDebugMode) {
      print("LATLNG: $latitude,$longitude");
      print(mapsLocationEC.text);
    }
  }

  Future<void> updateData() async {
    setState(() {
      _isLoading = true;
    });

    await UserController.instance.updateProfile(
      userName: usernameEC.text,
      address: mapsLocationEC.text,
      isCurrent: true,
    );

    // if (res) {
    //   //Display snackBar
    //   mySnackBar(
    //     context,
    //     kSuccessColor,
    //     "Success!",
    //     "Your changes have been saved successfully".toUpperCase(),
    //     const Duration(seconds: 2),
    //   );

    //   // Get.back();
    // } else {
    //   mySnackBar(
    //     context,
    //     kAccentColor,
    //     "Failed!",
    //     "Something unexpected happened, please try again later".toUpperCase(),
    //     const Duration(seconds: 2),
    //   );
    // }

    setState(() {
      _isLoading = false;
    });
  }

  //===================== COPY TO CLIPBOARD =======================\\
  void _copyToClipboard(BuildContext context, String userCode) {
    Clipboard.setData(
      ClipboardData(text: userCode),
    );

    //===================== SNACK BAR =======================\\

    mySnackBar(
      context,
      kSuccessColor,
      "Success!",
      "ID copied to clipboard",
      const Duration(
        seconds: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scrollbar(
        controller: _scrollController,
        child: _loadingScreen
            ? Center(child: CircularProgressIndicator(color: kAccentColor))
            : ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                physics: const BouncingScrollPhysics(),
                children: [
                  GetBuilder<UserController>(
                    builder: (controller) {
                      return Container(
                        width: media.width,
                        padding: const EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    selectedImage == null
                                        ? Container(
                                            height: deviceType(media.width) == 1
                                                ? 100
                                                : 150,
                                            width: deviceType(media.width) == 1
                                                ? 100
                                                : 150,
                                            decoration: ShapeDecoration(
                                              color: kPageSkeletonColor,
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/profile/avatar-image.jpg",
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: deviceType(media.width) == 1
                                                ? 100
                                                : 150,
                                            width: deviceType(media.width) == 1
                                                ? 100
                                                : 150,
                                            decoration: ShapeDecoration(
                                              color: kPageSkeletonColor,
                                              image: DecorationImage(
                                                image:
                                                    FileImage(selectedImage!),
                                                fit: BoxFit.cover,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                          ),
                                    Positioned(
                                      bottom: 0,
                                      right: 5,
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            elevation: 20,
                                            barrierColor:
                                                kBlackColor.withOpacity(0.8),
                                            showDragHandle: true,
                                            useSafeArea: true,
                                            isDismissible: true,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(
                                                  kDefaultPadding,
                                                ),
                                              ),
                                            ),
                                            enableDrag: true,
                                            builder: (builder) =>
                                                _profilePicBottomSheet(),
                                          );
                                        },
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          height: deviceType(media.width) == 1
                                              ? 35
                                              : 50,
                                          width: deviceType(media.width) == 1
                                              ? 35
                                              : 50,
                                          decoration: ShapeDecoration(
                                            color: kAccentColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                          child: Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.pencil,
                                              size: 18,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            kWidthSizedBox,
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.user.value.username,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    controller.user.value.email,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Wrap(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 11),
                                        child: Text(
                                          userCode!,
                                          softWrap: true,
                                          style: const TextStyle(
                                            color: kTextBlackColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _copyToClipboard(context, userCode!);
                                        },
                                        tooltip: "Copy ID",
                                        mouseCursor: SystemMouseCursors.click,
                                        icon: FaIcon(
                                          FontAwesomeIcons.copy,
                                          size: 14,
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  kSizedBox,
                  Text(
                    "Edit your profile".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: kTextBlackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  kSizedBox,
                  Form(
                    key: _formKey,
                    child: ValueListenableBuilder(
                        valueListenable: selectedLocation,
                        builder: (context, selectedLocationValue, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Username".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              kHalfSizedBox,
                              NameTextFormField(
                                controller: usernameEC,
                                hintText: "Enter a username",
                                validator: (value) {
                                  RegExp userNamePattern = RegExp(
                                    r'^.{3,}$', //Min. of 3 characters
                                  );
                                  if (value == null || value!.isEmpty) {
                                    usernameFN.requestFocus();
                                    return "Enter a username";
                                  } else if (!userNamePattern.hasMatch(value)) {
                                    usernameFN.requestFocus();
                                    return "Username must be at least 3 characters";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  usernameEC.text = value;
                                },
                                textInputAction: TextInputAction.next,
                                nameFocusNode: usernameFN,
                              ),
                              kSizedBox,
                              Text(
                                "Address".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              kHalfSizedBox,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Location on Google maps',
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  kHalfSizedBox,
                                  MyMapsTextFormField(
                                    controller: mapsLocationEC,
                                    validator: (value) {
                                      if (value == null) {
                                        mapsLocationFN.requestFocus();
                                        "Enter a location";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      placeAutoComplete(value);
                                      setState(() {
                                        selectedLocation.value = value;
                                        _typing = true;
                                      });
                                      if (kDebugMode) {
                                        print(
                                            "ONCHANGED VALUE: ${selectedLocation.value}");
                                      }
                                    },
                                    textInputAction: TextInputAction.done,
                                    focusNode: mapsLocationFN,
                                    hintText: "Search a location",
                                    textInputType: TextInputType.text,
                                    prefixIcon: Padding(
                                      padding:
                                          const EdgeInsets.all(kDefaultPadding),
                                      child: FaIcon(
                                        FontAwesomeIcons.locationDot,
                                        color: kAccentColor,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  kSizedBox,
                                  Divider(
                                    height: 10,
                                    thickness: 2,
                                    color: kLightGreyColor,
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: _toGetLocationOnMap,
                                    icon: FaIcon(
                                      FontAwesomeIcons.locationArrow,
                                      color: kAccentColor,
                                      size: 18,
                                    ),
                                    label: const Text("Locate on map"),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: kLightGreyColor,
                                      foregroundColor: kTextBlackColor,
                                      fixedSize: Size(media.width, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 10,
                                    thickness: 2,
                                    color: kLightGreyColor,
                                  ),
                                  const Text(
                                    "Suggestions:",
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  kHalfSizedBox,
                                  SizedBox(
                                    height: () {
                                      if (_typing == false) {
                                        return 0.0;
                                      }
                                      if (_typing == true) {
                                        return 150.0;
                                      }
                                    }(),
                                    child: Scrollbar(
                                      controller: _scrollController,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: placePredictions.length,
                                        itemBuilder: (context, index) =>
                                            LocationListTile(
                                          onTap: () => _setLocation(index),
                                          location: placePredictions[index]
                                              .description!,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              kSizedBox,
                            ],
                          );
                        }),
                  ),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: kAccentColor),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: MyElevatedButton(
                            onPressed: (() async {
                              if (_formKey.currentState!.validate()) {
                                updateData();
                              }
                            }),
                            title: "Save",
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
