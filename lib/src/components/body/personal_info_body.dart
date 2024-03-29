// ignore_for_file: use_build_context_synchronously, invalid_use_of_protected_member

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/form_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/src/components/image/my_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../app/google_maps/get_location_on_map.dart';
import '../../../controller/latlng_detail_controller.dart';
import '../../../theme/colors.dart';
import '../../googleMaps/autocomplete_prediction.dart';
import '../../googleMaps/places_autocomplete_response.dart';
import '../../providers/constants.dart';
import '../../providers/keys.dart';
import '../../responsive/responsive_constant.dart';
import '../../utils/network_utils.dart';
import '../button/my_elevatedbutton.dart';
import '../input/my_blue_textformfield.dart';
import '../input/my_intl_phonefield.dart';
import '../input/my_maps_textformfield.dart';
import '../input/name_textformfield.dart';
import '../section/location_list_tile.dart';
import '../snackbar/my_floating_snackbar.dart';

class PersonalInfoBody extends StatefulWidget {
  const PersonalInfoBody({super.key});

  @override
  State<PersonalInfoBody> createState() => _PersonalInfoBodyState();
}

class _PersonalInfoBodyState extends State<PersonalInfoBody> {
  //==========================================================================================\\

  @override
  void initState() {
    super.initState();
    userCode = UserController.instance.user.value.code;
    userNameEC.text = UserController.instance.user.value.username;
    firstNameEC.text = UserController.instance.user.value.firstName;
    lastNameEC.text = UserController.instance.user.value.lastName;
    genderEC.text = UserController.instance.user.value.gender;
    phoneNumberEC.text =
        UserController.instance.user.value.phone.replaceFirst("+234", '');
    mapsLocationEC.text = UserController.instance.user.value.address;
  }

  @override
  void dispose() {
    super.dispose();
    selectedLocation.dispose();
    scrollController.dispose();
  }

//==========================================================================================\\

//======================================== ALL VARIABLES ==============================================\\
  final String countryDialCode = '+234';
  String? userCode;
  String? latitude;
  String? longitude;
  List<AutocompletePrediction> placePredictions = [];
  final selectedLocation = ValueNotifier<String?>(null);

  //=========================== BOOL VALUES ====================================\\

  bool _isLoading = false;
  bool _typing = false;

  //======================================== GLOBAL KEYS ==============================================\\
  final _formKey = GlobalKey<FormState>();

  //=========================== CONTROLLERS ====================================\\
  final scrollController = ScrollController();
  final userNameEC = TextEditingController();
  final firstNameEC = TextEditingController();
  final lastNameEC = TextEditingController();
  final genderEC = TextEditingController();
  final phoneNumberEC = TextEditingController();
  final mapsLocationEC = TextEditingController();

  //=========================== FOCUS NODES ====================================\\
  final userNameFN = FocusNode();
  final firstNameFN = FocusNode();
  final lastNameFN = FocusNode();
  final genderFN = FocusNode();
  final phoneNumberFN = FocusNode();
  final mapsLocationFN = FocusNode();

  //=========================== IMAGE PICKER ====================================\\

  final ImagePicker _picker = ImagePicker();
  XFile? selectedLogoImage;

  pickLogoImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
    );
    if (image != null) {
      selectedLogoImage = image;
      // Get.back();
      setState(() {});
    }
  }

  //=========================== WIDGETS ====================================\\
  Widget profilePicBottomSheet() {
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
      selectedLogoImage = image;
      setState(() {});
      // User? user = await getUser();
      // final url =
      //     Uri.parse('$baseURL/clients/changeClientbusinessLogo/${user!.id}');

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
    var result = await Get.to(
      () => const GetLocationOnMap(),
      routeName: 'GetLocationOnMap',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    final LatLngDetailController latLngDetailController =
        LatLngDetailController.instance;

    if (latLngDetailController.isNotEmpty()) {
      setState(() {
        latitude = latLngDetailController.latLngDetail.value[0];
        longitude = latLngDetailController.latLngDetail.value[1];
        mapsLocationEC.text = latLngDetailController.latLngDetail.value[2];
        latLngDetailController.setEmpty();
      });
    }
    log(
      "Received Data - Maps Location: ${mapsLocationEC.text}, Latitude: $latitude, Longitude: $longitude",
    );
  }

  Future<void> updateData() async {
    if (await checkXFileSize(selectedLogoImage)) {
      ApiProcessorController.errorSnack('Profile picture too large');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    // await ProfileController.instance.updateProfile(
    //   firstName: firstNameEC.text,
    //   lastName: lastNameEC.text,
    //   address: mapsLocationEC.text,
    //   latitude: latitude,
    //   longitude: longitude,
    //   phoneNumber: phoneNumberEC.text,

    // );
    int uuid = UserController.instance.user.value.id;

    var url = "${Api.baseUrl}/agents/changeAgent/$uuid";

    Map data = {
      "first_name": firstNameEC.text,
      "last_name": lastNameEC.text,
      "address": mapsLocationEC.text,
      "latitude": latitude,
      "longitude": longitude,
      "phone": countryDialCode + phoneNumberEC.text
    };
    await FormController.instance.postAuthstream2(
        url, data, {'image': selectedLogoImage}, 'editProfile');
    UserController.instance.getUser();
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
      const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SafeArea(
      child: Scrollbar(
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(10),
          physics: const BouncingScrollPhysics(),
          children: [
            GetBuilder<UserController>(
              init: UserController(),
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
                              CircleAvatar(
                                radius: 60,
                                child: ClipOval(
                                  child: Center(
                                    child: selectedLogoImage == null
                                        ? MyImage(
                                            height: 120,
                                            width: 120,
                                            url: UserController
                                                .instance.user.value.image,
                                            fit: BoxFit.fill,
                                          )
                                        : kIsWeb
                                            ? Image.network(
                                                selectedLogoImage!.path,
                                                fit: BoxFit.fill,
                                                height: 120,
                                                width: 120,
                                              )
                                            : Image.file(
                                                height: 120,
                                                width: 120,
                                                fit: BoxFit.fill,
                                                File(
                                                  selectedLogoImage!.path,
                                                ),
                                              ),
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
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(
                                            kDefaultPadding,
                                          ),
                                        ),
                                      ),
                                      enableDrag: true,
                                      builder: (builder) =>
                                          profilePicBottomSheet(),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    height:
                                        deviceType(media.width) == 1 ? 35 : 50,
                                    width:
                                        deviceType(media.width) == 1 ? 35 : 50,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${controller.user.value.firstName} ${controller.user.value.lastName}",
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
                                    controller.user.value.code,
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
                                    _copyToClipboard(
                                        context, controller.user.value.code);
                                  },
                                  tooltip: "Copy ID",
                                  mouseCursor: SystemMouseCursors.click,
                                  icon: FaIcon(
                                    FontAwesomeIcons.solidCopy,
                                    size: 16,
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
                          "First Name".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        kHalfSizedBox,
                        NameTextFormField(
                          controller: firstNameEC,
                          hintText: "Enter your first name",
                          nameFocusNode: firstNameFN,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            RegExp namePattern =
                                RegExp(r'^.{3,}$'); //Min. of 3 characters
                            if (value == null || value!.isEmpty) {
                              firstNameFN.requestFocus();
                              return "Enter your first name";
                            } else if (!namePattern.hasMatch(value)) {
                              firstNameFN.requestFocus();
                              return "Name must be at least 3 characters";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            firstNameEC.text = value;
                          },
                        ),
                        kSizedBox,
                        Text(
                          "Last Name".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        kHalfSizedBox,
                        NameTextFormField(
                          controller: lastNameEC,
                          hintText: "Enter your last name",
                          nameFocusNode: lastNameFN,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            RegExp namePattern =
                                RegExp(r'^.{3,}$'); //Min. of 3 characters
                            if (value == null || value!.isEmpty) {
                              lastNameFN.requestFocus();
                              return "Enter your last name";
                            } else if (!namePattern.hasMatch(value)) {
                              lastNameFN.requestFocus();
                              return "Name must be at least 3 characters";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            lastNameEC.text = value;
                          },
                        ),
                        kSizedBox,
                        Text(
                          "Gender".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        kHalfSizedBox,
                        MyBlueTextFormField(
                          controller: genderEC,
                          isEnabled: false,
                          validator: (value) {
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          focusNode: genderFN,
                          hintText: genderEC.text,
                          textInputType: TextInputType.text,
                        ),
                        kHalfSizedBox,
                        Text(
                          "Phone Number".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        kHalfSizedBox,
                        MyIntlPhoneField(
                          controller: phoneNumberEC,
                          initialCountryCode: "NG",
                          invalidNumberMessage: "Invalid phone number",
                          dropdownIconPosition: IconPosition.trailing,
                          showCountryFlag: true,
                          showDropdownIcon: true,
                          dropdownIcon: Icon(Icons.arrow_drop_down_rounded,
                              color: kAccentColor),
                          textInputAction: TextInputAction.next,
                          focusNode: phoneNumberFN,
                          validator: (value) {
                            if (value == null || phoneNumberEC.text.isEmpty) {
                              return "Field cannot be empty";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            phoneNumberEC.text = value!;
                          },
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
                                padding: const EdgeInsets.all(kDefaultPadding),
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
                                controller: scrollController,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: placePredictions.length,
                                  itemBuilder: (context, index) =>
                                      LocationListTile(
                                    onTap: () => _setLocation(index),
                                    location:
                                        placePredictions[index].description!,
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
            // _isLoading
            //     ? Center(
            //         child: CircularProgressIndicator(color: kAccentColor),
            //       )
            //     :
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: MyElevatedButton(
                onPressed: (() async {
                  if (_formKey.currentState!.validate()) {
                    updateData();
                  }
                }),
                isLoading: _isLoading,
                title: "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
