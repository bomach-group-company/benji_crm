// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../src/providers/constants.dart';
import '../../controller/latlng_detail_controller.dart';
import '../../controller/vendor_controller.dart';
import '../../model/create_vendor_model.dart';
import '../../src/components/button/my_elevatedButton.dart';
import '../../src/components/input/my_blue_textformfield.dart';
import '../../src/components/input/my_intl_phonefield.dart';
import '../../src/components/input/my_maps_textformfield.dart';
import '../../src/components/input/number_textformfield.dart';
import '../../src/components/section/location_list_tile.dart';
import '../../src/googleMaps/autocomplete_prediction.dart';
import '../../src/googleMaps/places_autocomplete_response.dart';
import '../../src/providers/keys.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../src/utils/network_utils.dart';
import '../google_maps/get_location_on_map.dart';

class RegisterVendor extends StatefulWidget {
  const RegisterVendor({super.key});

  @override
  State<RegisterVendor> createState() => _RegisterVendorState();
}

class _RegisterVendorState extends State<RegisterVendor> {
  //==========================================================================================\\
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   CategoryController.instance.category;
    //   CategoryController.instance.getCategory();
    // });
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    selectedLocation.dispose();
    scrollController.dispose();
  }

//==========================================================================================\\

  //===================== ALL VARIABLES =======================\\
  String? latitude;
  String? longitude;
  String countryDialCode = '+234';
  List<AutocompletePrediction> placePredictions = [];
  final selectedLocation = ValueNotifier<String?>(null);
  String defaultGender = "Male";
  final List<String> genders = <String>["Male", "Female"];

  //======================================== GLOBAL KEYS ==============================================\\
  final _formKey = GlobalKey<FormState>();
  final _cscPickerKey = GlobalKey<CSCPickerState>();

  //===================== BOOL VALUES =======================\\
  bool _isScrollToTopBtnVisible = false;
  bool _typing = false;

  //============================================== CONTROLLERS =================================================\\
  final scrollController = ScrollController();
  final personalIdEC = TextEditingController();
  final vendorvendorIdEC = TextEditingController();
  final vendorNameEC = TextEditingController();
  final vendorEmailEC = TextEditingController();
  final vendorPhoneNumberEC = TextEditingController();
  final vendorAddressEC = TextEditingController();
  final vendorvendorTypeEC = TextEditingController();
  final vendorvendorBioEC = TextEditingController();
  final vendorFirstNameEC = TextEditingController();
  final vendorLastNameEC = TextEditingController();

  final vendorLGAEC = TextEditingController();
  // final vendorSunOpeningHoursEC = TextEditingController();
  // final vendorMonToFriClosingHoursEC = TextEditingController();
  // final vendorSatClosingHoursEC = TextEditingController();
  // final vendorSunClosingHoursEC = TextEditingController();
  final mapsLocationEC = TextEditingController();
  final latLngDetailController = LatLngDetailController.instance;

  //=================================== FOCUS NODES ====================================\\
  final personalIdFN = FocusNode();
  final vendorvendorIdFN = FocusNode();
  final vendorNameFN = FocusNode();
  final vendorEmailFN = FocusNode();
  final vendorPhoneNumberFN = FocusNode();
  final vendorAddressFN = FocusNode();
  final vendorvendorTypeFN = FocusNode();
  final vendorvendorBioFN = FocusNode();
  final vendorFirstnameFN = FocusNode();
  final vendorLastnameFN = FocusNode();
  final vendorLGAFN = FocusNode();
  // final vendorSunOpeningHoursFN = FocusNode();
  // final vendorMonToFriClosingHoursFN = FocusNode();
  // final vendorSatClosingHoursFN = FocusNode();
  // final vendorSunClosingHoursFN = FocusNode();
  final mapsLocationFN = FocusNode();

  //============================================= FUNCTIONS ===============================================\\

//Google Maps
  setLocation(index) async {
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

  void getLocationOnMap() async {
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
    if (result != null) {
      mapsLocationEC.text = result["mapsLocation"];
      latitude = result["latitude"];
      longitude = result["longitude"];
    }
    log(
      "Received Data - Maps Location: ${mapsLocationEC.text}, Latitude: $latitude, Longitude: $longitude",
    );
  }

//=========================== IMAGE PICKER ====================================\\

  final ImagePicker _picker = ImagePicker();
  File? selectedCoverImage;
  File? selectedLogoImage;
  String? country;
  String? state;
  String? city;
  String? shopType;
  String? shopTypeHint;
  //================================== function ====================================\\
  pickCoverImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
    );
    if (image != null) {
      selectedCoverImage = File(image.path);
      Get.back();
      setState(() {});
    }
  }

  pickLogoImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
    );
    if (image != null) {
      selectedLogoImage = File(image.path);
      Get.back();
      setState(() {});
    }
  }

  //========================== Save data ==================================\\
  Future<void> saveChanges() async {
    if (selectedLogoImage == null) {
      ApiProcessorController.errorSnack("Please add a profile picture");
      return;
    }
    if (defaultGender.isEmpty || defaultGender == "") {
      ApiProcessorController.errorSnack("Please choose a gender");
    }
    if (country == null || country!.isEmpty || country == "") {
      ApiProcessorController.errorSnack("Please select a country");
      return;
    }
    if (state == null || state!.isEmpty || state == "") {
      ApiProcessorController.errorSnack("Please select a state");
      return;
    }
    if (!state!.contains("Enugu")) {
      ApiProcessorController.errorSnack("We are only available in Enugu state");
      return;
    }
    if (city == null || city!.isEmpty || city == "") {
      ApiProcessorController.errorSnack("Please select a city");
      return;
    }
    if (vendorLGAEC.isBlank! || vendorLGAEC.text == "") {
      ApiProcessorController.errorSnack("Please select an LGA");
      return;
    }

    SendCreateModel data = SendCreateModel(
      phoneNumber: countryDialCode + vendorPhoneNumberEC.text,
      address: mapsLocationEC.text,
      email: vendorEmailEC.text,
      personalID: personalIdEC.text,
      country: country!.contains("Nigeria") ? "NG" : "",
      state: state ?? "",
      gender: defaultGender.contains("Male") ? "M" : "F",
      city: city ?? "",
      latitude: latitude ?? "",
      longitude: longitude ?? "",
      firstName: vendorFirstNameEC.text,
      lastName: vendorLastNameEC.text,
      lga: vendorLGAEC.text,
      // sunOpenHours: vendorSunOpeningHoursEC.text,
      // sunCloseHours: vendorSunClosingHoursEC.text,
      profileImage: selectedLogoImage,
    );

    VendorController.instance.createVendor(data, true);
  }

  //=========================== WIDGETS ====================================\\

  Widget uploadLogoImage() => Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "Upload Logo Image",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            kSizedBox,
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        pickLogoImage(ImageSource.camera);
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.all(10),
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
                        pickLogoImage(ImageSource.gallery);
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.all(10),
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
                    const Text("Gallery"),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

  //===================== Scroll to Top ==========================\\
  Future<void> scrollToTop() async {
    await scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _isScrollToTopBtnVisible = false;
    });
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels >= 100 &&
        _isScrollToTopBtnVisible != true) {
      setState(() {
        _isScrollToTopBtnVisible = true;
      });
    }
    if (scrollController.position.pixels < 100 &&
        _isScrollToTopBtnVisible == true) {
      setState(() {
        _isScrollToTopBtnVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: "Register a vendor",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        bottomNavigationBar: GetBuilder<VendorController>(builder: (sending) {
          return Container(
            color: kPrimaryColor,
            padding: const EdgeInsets.all(kDefaultPadding),
            child: MyElevatedButton(
              onPressed: (() async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  saveChanges();
                }
              }),
              isLoading: sending.isLoadCreate.value,
              title: "Save",
            ),
          );
        }),
        floatingActionButton: _isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: scrollToTop,
                mini: deviceType(media.width) > 2 ? false : true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: FaIcon(
                  FontAwesomeIcons.chevronUp,
                  size: 18,
                  color: kPrimaryColor,
                ),
              )
            : const SizedBox(),
        body: SafeArea(
            child: Scrollbar(
          child: ListView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(kDefaultPadding),
            children: [
              DottedBorder(
                color: kLightGreyColor,
                borderPadding: const EdgeInsets.all(3),
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                borderType: BorderType.RRect,
                radius: const Radius.circular(20),
                child: Center(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          selectedLogoImage == null
                              ? Container(
                                  width: media.width,
                                  height: 144,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 0.50,
                                        color: Color(0xFFE6E6E6),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.solidCircleUser,
                                      color: kAccentColor,
                                      size: 40,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Image.file(selectedLogoImage!),
                                    ),
                                  ),
                                  // decoration: ShapeDecoration(
                                  //   shape: const OvalBorder(),
                                  //   image: DecorationImage(
                                  //     image: FileImage(
                                  //       selectedLogoImage!,
                                  //     ),
                                  //     fit: BoxFit.cover,
                                  //   ),
                                  // ),
                                ),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                elevation: 20,
                                barrierColor: kBlackColor.withOpacity(0.8),
                                showDragHandle: true,
                                useSafeArea: true,
                                isDismissible: true,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(kDefaultPadding),
                                  ),
                                ),
                                enableDrag: true,
                                builder: ((builder) => uploadLogoImage()),
                              );
                            },
                            splashColor: kAccentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Upload profile picture',
                                style: TextStyle(
                                  color: kAccentColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              kSizedBox,
              Form(
                key: _formKey,
                child: ValueListenableBuilder(
                    valueListenable: selectedLocation,
                    builder: (context, selectedLocationValue, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "First Name",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyBlueTextFormField(
                            controller: vendorFirstNameEC,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {},
                            textInputAction: TextInputAction.next,
                            focusNode: vendorFirstnameFN,
                            hintText: "Enter the first name",
                            textInputType: TextInputType.name,
                          ),
                          kSizedBox,
                          const Text(
                            "Last Name",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyBlueTextFormField(
                            controller: vendorLastNameEC,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {},
                            textInputAction: TextInputAction.next,
                            focusNode: vendorLastnameFN,
                            hintText: "Enter the last name",
                            textInputType: TextInputType.name,
                          ),
                          kSizedBox,
                          const Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyBlueTextFormField(
                            controller: vendorEmailEC,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {},
                            textInputAction: TextInputAction.next,
                            focusNode: vendorEmailFN,
                            hintText: "Enter email",
                            textInputType: TextInputType.emailAddress,
                          ),
                          kSizedBox,
                          const Text(
                            "National Identification Number (NIN)",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          NumberTextFormField(
                            controller: personalIdEC,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else if (value.toString().length > 16) {
                                return "Enter a valid value";
                              }
                              return null;
                            },
                            maxlength: 11,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (value) {},
                            textInputAction: TextInputAction.next,
                            focusNode: personalIdFN,
                            hintText:
                                "Enter National Identification Number (NIN)",
                          ),
                          kSizedBox,
                          const Text(
                            "Gender",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          RadioGroup<String>.builder(
                            groupValue: defaultGender,
                            onChanged: (value) => setState(() {
                              defaultGender = value ?? "Male";
                              log(defaultGender);

                              // setState(() {
                              //   selectedGender = value!;
                              // });
                            }),
                            items: genders,
                            itemBuilder: (item) => RadioButtonBuilder(item),
                            direction: Axis.horizontal,
                            horizontalAlignment: MainAxisAlignment.start,
                            activeColor: kAccentColor,
                          ),
                          kSizedBox,

                          const Text(
                            "Phone Number",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyIntlPhoneField(
                            controller: vendorPhoneNumberEC,
                            initialCountryCode: "NG",
                            invalidNumberMessage: "Invalid phone number",
                            dropdownIconPosition: IconPosition.trailing,
                            showCountryFlag: true,
                            showDropdownIcon: true,
                            dropdownIcon: Icon(
                              FontAwesomeIcons.caretDown,
                              color: kAccentColor,
                              size: 14,
                            ),
                            textInputAction: TextInputAction.next,
                            focusNode: vendorPhoneNumberFN,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {},
                          ),
                          kSizedBox,
                          const Text(
                            "House Address",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
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
                                  if (value == null || value!.isEmpty) {
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
                                onPressed: getLocationOnMap,
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
                                    return deviceType(media.width) >= 2
                                        ? 300.0
                                        : 150.0;
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
                                      onTap: () => setLocation(index),
                                      location:
                                          placePredictions[index].description!,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          kSizedBox,
                          const Text(
                            "Localization",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          CSCPicker(
                            key: _cscPickerKey,
                            layout: Layout.vertical,
                            countryFilter: const [CscCountry.Nigeria],
                            countryDropdownLabel: "Select country",
                            stateDropdownLabel: "Select state",
                            cityDropdownLabel: "Select city",
                            onCountryChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  country = value;
                                });
                              }
                            },
                            onStateChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  state = value;
                                });
                              }
                            },
                            onCityChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  city = value;
                                });
                              }
                            },
                          ),
                          kSizedBox,
                          const Text(
                            "Local Government Area",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyBlueTextFormField(
                            controller: vendorLGAEC,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {},
                            textInputAction: TextInputAction.done,
                            focusNode: vendorLGAFN,
                            hintText: "Enter the LGA",
                            textInputType: TextInputType.text,
                          ),
                          kSizedBox,

                          // MyDropDownMenu(
                          //   controller: vendorLGAEC,
                          //   hintText: "Select your LGA",
                          //   dropdownMenuEntries: const [
                          //     DropdownMenuEntry(
                          //       value: "1",
                          //       label: "Enugu North",
                          //     ),
                          //   ],
                          // ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
