// ignore_for_file: unused_local_variable, use_build_context_synchronously, unused_field, invalid_use_of_protected_member

import 'dart:async';
import 'dart:io';

import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/services/api_url.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../src/providers/constants.dart';
import '../../controller/category_controller.dart';
import '../../controller/latlng_detail_controller.dart';
import '../../model/create_vendor_model.dart';
import '../../services/helper.dart';
import '../../services/keys.dart';
import '../../src/components/button/my_elevatedButton.dart';
import '../../src/components/input/message_textformfield.dart';
import '../../src/components/input/my_blue_textformfield.dart';
import '../../src/components/input/my_intl_phonefield.dart';
import '../../src/components/input/my_maps_textformfield.dart';
import '../../src/components/section/location_list_tile.dart';
import '../../src/components/snackbar/my_fixed_snackBar.dart';
import '../../src/googleMaps/autocomplete_prediction.dart';
import '../../src/googleMaps/places_autocomplete_response.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../src/utils/network_utils.dart';
import '../add_vendor/business_category_modal.dart';
import '../google_maps/get_location_on_map.dart';
import 'register_business_modal.dart';

class AddToAVendor extends StatefulWidget {
  const AddToAVendor({super.key});

  @override
  State<AddToAVendor> createState() => _AddToAVendorState();
}

class _AddToAVendorState extends State<AddToAVendor> {
  //==========================================================================================\\
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      CategoryController.instance.category;
      CategoryController.instance.getCategory();
    });
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    selectedLocation.dispose();
    scrollController.dispose();
  }

//==========================================================================================\\

  //===================== ALL VARIABLES =======================\\
  late Timer _timer;
  String? latitude;
  String? longitude;
  String countryDialCode = '234';
  List<AutocompletePrediction> placePredictions = [];
  final selectedLocation = ValueNotifier<String?>(null);

  //======================================== GLOBAL KEYS ==============================================\\
  final _formKey = GlobalKey<FormState>();
  final _cscPickerKey = GlobalKey<CSCPickerState>();

  //===================== BOOL VALUES =======================\\
  bool _isScrollToTopBtnVisible = false;
  final bool _savingChanges = false;
  bool _typing = false;

  //============================================== CONTROLLERS =================================================\\
  final scrollController = ScrollController();
  final registeredVendorEC = TextEditingController();
  final vendorNameEC = TextEditingController();
  final vendorEmailEC = TextEditingController();
  final vendorPhoneNumberEC = TextEditingController();
  final vendorAddressEC = TextEditingController();
  final vendorBusinessTypeEC = TextEditingController();
  final vendorBusinessBioEC = TextEditingController();
  final vendorMonToFriOpeningHoursEC = TextEditingController();
  final vendorSatOpeningHoursEC = TextEditingController();
  final vendorSunOpeningHoursEC = TextEditingController();
  final vendorMonToFriClosingHoursEC = TextEditingController();
  final vendorSatClosingHoursEC = TextEditingController();
  final vendorSunClosingHoursEC = TextEditingController();
  final mapsLocationEC = TextEditingController();
  final LatLngDetailController latLngDetailController =
      LatLngDetailController.instance;

  //=================================== FOCUS NODES ====================================\\
  final registeredVendorFN = FocusNode();
  final vendorNameFN = FocusNode();
  final vendorEmailFN = FocusNode();
  final vendorPhoneNumberFN = FocusNode();
  final vendorAddressFN = FocusNode();
  final vendorBusinessTypeFN = FocusNode();
  final vendorBusinessBioFN = FocusNode();
  final vendorMonToFriOpeningHoursFN = FocusNode();
  final vendorSatOpeningHoursFN = FocusNode();
  final vendorSunOpeningHoursFN = FocusNode();
  final vendorMonToFriClosingHoursFN = FocusNode();
  final vendorSatClosingHoursFN = FocusNode();
  final vendorSunClosingHoursFN = FocusNode();
  final mapsLocationFN = FocusNode();

  //============================================= FUNCTIONS ===============================================\\

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

  void getLocationOnMap() async {
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

//=========================== IMAGE PICKER ====================================\\

  final ImagePicker _picker = ImagePicker();
  File? selectedCoverImage;
  File? selectedLogoImage;
  String? country;
  String? state;
  String? city;
  String? shopType;
  String? shopTypeHint;
  String? registeredVendor;
  int? vendorId;
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
    if (country == null) {
      myFixedSnackBar(
        context,
        "please select country".toUpperCase(),
        kErrorColor,
        const Duration(seconds: 1),
      );
      return;
    }
    if (state == null) {
      myFixedSnackBar(
        context,
        "please select state".toUpperCase(),
        kErrorColor,
        const Duration(seconds: 1),
      );
      return;
    }
    if (city == null) {
      myFixedSnackBar(
        context,
        "please select city".toUpperCase(),
        kErrorColor,
        const Duration(seconds: 1),
      );
      return;
    }
    if (shopType == null) {
      myFixedSnackBar(
        context,
        "please select type of business".toUpperCase(),
        kErrorColor,
        const Duration(seconds: 1),
      );
      return;
    }
    SendCreateModel data = SendCreateModel(
      personaId: "",
      businessId: "",
      businessName: vendorNameEC.text,
      businessType: shopType,
      businessPhone: vendorPhoneNumberEC.text,
      bussinessAddress: mapsLocationEC.text,
      businessEmail: "",
      country: country ?? "NG",
      state: state ?? "",
      city: city ?? "",
      latitude: latitude ?? "",
      longitude: longitude ?? "",
      openHours: vendorMonToFriOpeningHoursEC.text,
      closeHours: vendorMonToFriClosingHoursEC.text,
      satOpenHours: vendorSatOpeningHoursEC.text,
      satCloseHours: vendorSatClosingHoursEC.text,
      sunOpenHours: vendorSunOpeningHoursEC.text,
      sunCloseHours: vendorSunClosingHoursEC.text,
      businessBio: vendorBusinessBioEC.text,
      coverImage: selectedCoverImage,
      profileImage: selectedLogoImage,
    );
    VendorController.instance.addToAVendor(data, vendorId!);
  }

  //=========================== WIDGETS ====================================\\
  Widget uploadCoverImage() => Container(
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
              "Upload Cover Image",
              textAlign: TextAlign.left,
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
                        pickCoverImage(ImageSource.camera);
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(
                              width: 0.5,
                              color: kLightGreyColor,
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
                        pickCoverImage(ImageSource.gallery);
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(
                              width: 0.5,
                              color: kLightGreyColor,
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

  Widget uploadLogoImage() => Container(
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
              "Upload Logo Image",
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
                        pickLogoImage(ImageSource.camera);
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(
                              width: 0.5,
                              color: kLightGreyColor,
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
                        height: 60,
                        width: 60,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(
                              width: 0.5,
                              color: kLightGreyColor,
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
  Future<void> _scrollToTop() async {
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
          title: "Add to a vendor",
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
                onPressed: _scrollToTop,
                mini: deviceType(media.width) > 2 ? false : true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: const FaIcon(FontAwesomeIcons.chevronUp, size: 18),
              )
            : const SizedBox(),
        body: SafeArea(
            child: Scrollbar(
          controller: scrollController,
          child: ListView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(kDefaultPadding),
            children: [
              const Text(
                "Header content",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              kSizedBox,
              DottedBorder(
                color: kLightGreyColor,
                borderPadding: const EdgeInsets.all(3),
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                borderType: BorderType.RRect,
                radius: const Radius.circular(20),
                child: Column(
                  children: [
                    Column(
                      children: [
                        selectedCoverImage == null
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
                                  child: Image.asset(
                                      "assets/icons/image-upload.png"),
                                ),
                              )
                            : Container(
                                width: media.width,
                                height: 144,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: FileImage(selectedCoverImage!),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 0.50,
                                      color: Color(0xFFE6E6E6),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
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
                              builder: ((builder) => uploadCoverImage()),
                            );
                          },
                          splashColor: kAccentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Upload cover image',
                              textAlign: TextAlign.center,
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
                            : Container(
                                height: 200,
                                width: 200,
                                decoration: ShapeDecoration(
                                  shape: const OvalBorder(),
                                  image: DecorationImage(
                                    image: FileImage(
                                      selectedLogoImage!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
                              'Upload business logo',
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
                            "Select a registered business",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          GetBuilder<VendorController>(builder: (type) {
                            return InkWell(
                              onTap: () async {
                                var data = await registeredBusinessesModal(
                                    context, type.vendorList);
                                if (data != null) {
                                  setState(() {
                                    vendorId = data.id;
                                    registeredVendor = data.shopName;
                                    registeredVendorEC.text = data.shopName;
                                  });
                                  consoleLog("This is the vendor: $vendorId");
                                }
                              },
                              child: MyBlueTextFormField(
                                controller: registeredVendorEC,
                                isEnabled: false,
                                validator: (value) {
                                  if (value.isEmpty || value == null) {
                                    "Field cannot be empty";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  registeredVendorEC.text = value!;
                                },
                                textInputAction: TextInputAction.next,
                                focusNode: registeredVendorFN,
                                hintText: registeredVendor ??
                                    "Select an already registered business",
                                textInputType: TextInputType.text,
                              ),
                            );
                          }),
                          kSizedBox,
                          const Text(
                            "Business Name",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyBlueTextFormField(
                            controller: vendorNameEC,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            textInputAction: TextInputAction.next,
                            focusNode: vendorNameFN,
                            hintText: "Enter the name of the business",
                            textInputType: TextInputType.name,
                          ),
                          kSizedBox,
                          const Text(
                            "Type of Business",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          GetBuilder<CategoryController>(builder: (type) {
                            return InkWell(
                              onTap: () async {
                                var data =
                                    await shopTypeModal(context, type.category);
                                if (data != null) {
                                  setState(() {
                                    shopType = data.id;
                                    shopTypeHint = data.name;
                                    vendorBusinessTypeEC.text = data.name;
                                  });
                                  consoleLog("$shopType");
                                }
                              },
                              child: MyBlueTextFormField(
                                controller: vendorBusinessTypeEC,
                                isEnabled: false,
                                validator: (value) {
                                  if (value.isEmpty || value == null) {
                                    "Field cannot be empty";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  vendorBusinessTypeEC.text = value!;
                                },
                                textInputAction: TextInputAction.next,
                                focusNode: vendorBusinessTypeFN,
                                hintText: shopTypeHint ??
                                    "E.g Restaurant, Auto Dealer, etc",
                                textInputType: TextInputType.text,
                              ),
                            );
                          }),
                          kSizedBox,
                          // const Text(
                          //   "Business Email",
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.w700,
                          //   ),
                          // ),
                          // kSizedBox,
                          // MyBlueTextFormField(
                          //   controller: vendorEmailEC,
                          //   validator: (value) {
                          //     if (value == null || value!.isEmpty) {
                          //       return "Field cannot be empty";
                          //     } else {
                          //       return null;
                          //     }
                          //   },
                          //   onSaved: (value) {},
                          //   textInputAction: TextInputAction.next,
                          //   focusNode: vendorEmailFN,
                          //   hintText: "Enter the bussiness email",
                          //   textInputType: TextInputType.emailAddress,
                          // ),
                          // kSizedBox,
                          const Text(
                            "Business Phone Number",
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
                              Icons.arrow_drop_down_rounded,
                              color: kAccentColor,
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
                            "Business Address",
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
                          Center(
                            child: Text(
                              "Business hours".toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          kSizedBox,
                          const Center(
                            child: Text(
                              "Mondays to Fridays",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          kSizedBox,
                          const Text(
                            "Opening hours",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyBlueTextFormField(
                            controller: vendorMonToFriOpeningHoursEC,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {},
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter,
                              UppercaseTextInputFormatter(), // Custom formatter to make text uppercase
                            ],
                            textInputAction: TextInputAction.next,
                            focusNode: vendorMonToFriOpeningHoursFN,
                            hintText: "00:00 AM",
                            textInputType: TextInputType.text,
                          ),
                          kSizedBox,
                          const Text(
                            "Closing hours",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyBlueTextFormField(
                            controller: vendorMonToFriClosingHoursEC,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {},
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter,
                              UppercaseTextInputFormatter(), // Custom formatter to make text uppercase
                            ],
                            textInputAction: TextInputAction.next,
                            focusNode: vendorMonToFriClosingHoursFN,
                            hintText: "00:00 PM",
                            textInputType: TextInputType.text,
                          ),
                          kSizedBox,
                          const Center(
                            child: Text(
                              "Saturdays",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          kSizedBox,
                          const Text(
                            "Opening hours",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyBlueTextFormField(
                            controller: vendorSatOpeningHoursEC,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {},
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter,
                              UppercaseTextInputFormatter(), // Custom formatter to make text uppercase
                            ],
                            textInputAction: TextInputAction.next,
                            focusNode: vendorSatOpeningHoursFN,
                            hintText: "00:00 AM",
                            textInputType: TextInputType.text,
                          ),
                          kSizedBox,
                          const Text(
                            "Closing hours",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyBlueTextFormField(
                            controller: vendorSatClosingHoursEC,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {},
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter,
                              UppercaseTextInputFormatter(), // Custom formatter to make text uppercase
                            ],
                            textInputAction: TextInputAction.next,
                            focusNode: vendorSatClosingHoursFN,
                            hintText: "00:00 PM",
                            textInputType: TextInputType.text,
                          ),
                          kSizedBox,
                          const Center(
                            child: Text(
                              "Sundays",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          kSizedBox,
                          const Text(
                            "Opening hours",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyBlueTextFormField(
                            controller: vendorSunOpeningHoursEC,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {},
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter,
                              UppercaseTextInputFormatter(), // Custom formatter to make text uppercase
                            ],
                            textInputAction: TextInputAction.next,
                            focusNode: vendorSunOpeningHoursFN,
                            hintText: "00:00 AM",
                            textInputType: TextInputType.text,
                          ),
                          kSizedBox,
                          const Text(
                            "Closing hours",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyBlueTextFormField(
                            controller: vendorSunClosingHoursEC,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {},
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter,
                              UppercaseTextInputFormatter(), // Custom formatter to make text uppercase
                            ],
                            textInputAction: TextInputAction.next,
                            focusNode: vendorSunClosingHoursFN,
                            hintText: "00:00 PM",
                            textInputType: TextInputType.text,
                          ),
                          kSizedBox,
                          const Text(
                            "Business Bio",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyMessageTextFormField(
                            controller: vendorBusinessBioEC,
                            textInputAction: TextInputAction.newline,
                            focusNode: vendorBusinessBioFN,
                            hintText: "About the business...",
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
                            maxLength: 1000,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              vendorBusinessBioEC.text = value;
                            },
                          ),
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
