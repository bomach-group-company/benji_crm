// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/form_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/utils/web_map.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../controller/latlng_detail_controller.dart';
import '../../controller/shopping_location_controller.dart';
import '../../controller/vendor_controller.dart';
import '../../src/components/button/my_elevatedButton.dart';
import '../../src/components/input/my_blue_textformfield.dart';
import '../../src/components/input/my_intl_phonefield.dart';
import '../../src/components/input/my_item_drop_down_menu.dart';
import '../../src/components/input/my_maps_textformfield.dart';
import '../../src/components/input/number_textformfield.dart';
import '../../src/components/section/location_list_tile.dart';
import '../../src/googleMaps/autocomplete_prediction.dart';
import '../../src/googleMaps/places_autocomplete_response.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../src/utils/constants.dart';
import '../../src/utils/keys.dart';
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
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   vendorFirstNameEC.text = UserController.instance.user.value.firstName;
    //   vendorLastNameEC.text = UserController.instance.user.value.lastName;
    //   vendorPhoneNumberEC.text =
    //       UserController.instance.user.value.phone.replaceAll("+234", "");

    // });

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
  String initialVendorClassifier = "True";
  final List<String> vendorClassifierLabels = <String>['True', 'False'];

  //======================================== GLOBAL KEYS ==============================================\\
  final _formKey = GlobalKey<FormState>();

  //===================== BOOL VALUES =======================\\
  bool _isScrollToTopBtnVisible = false;
  bool _typing = false;
  bool vendorClassified = true;

  //============================================== CONTROLLERS =================================================\\
  final scrollController = ScrollController();
  final personalIdEC = TextEditingController();
  final vendorvendorIdEC = TextEditingController();
  final vendorNameEC = TextEditingController();
  final vendorEmailEC = TextEditingController();
  final vendorPhoneNumberEC = TextEditingController();
  final vendorvendorTypeEC = TextEditingController();
  final vendorvendorBioEC = TextEditingController();
  final vendorFirstNameEC = TextEditingController();
  final vendorLastNameEC = TextEditingController();

  final countryEC = TextEditingController();
  final stateEC = TextEditingController();
  final cityEC = TextEditingController();

  final vendorLGAEC = TextEditingController();
  // final vendorSunOpeningHoursEC = TextEditingController();
  // final vendorMonToFriClosingHoursEC = TextEditingController();
  // final vendorSatClosingHoursEC = TextEditingController();
  // final vendorSunClosingHoursEC = TextEditingController();
  final mapsLocationEC = TextEditingController();

  //=================================== FOCUS NODES ====================================\\
  final personalIdFN = FocusNode();
  final vendorvendorIdFN = FocusNode();
  final vendorNameFN = FocusNode();
  final vendorEmailFN = FocusNode();
  final vendorPhoneNumberFN = FocusNode();
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

    List location = await parseLatLng(newLocation);
    latitude = location[0];
    longitude = location[1];
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

//=========================== IMAGE PICKER ====================================\\

  final ImagePicker _picker = ImagePicker();
  final ImagePicker _pickerCover = ImagePicker();
  XFile? selectedCoverImage;
  XFile? selectedLogoImage;

  String? shopType;
  String? shopTypeHint;
  //================================== function ====================================\\
  pickCoverImage(ImageSource source) async {
    final XFile? image = await _pickerCover.pickImage(
      source: source,
    );
    if (image != null) {
      selectedCoverImage = image;
      // Get.back();
      setState(() {});
    }
  }

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

  //========================== Save data ==================================\\
  Future<void> saveChangesAsVendor() async {
    log("Saving as vendor");
    log(vendorClassified.toString());
    if (await checkXFileSize(selectedLogoImage)) {
      ApiProcessorController.errorSnack('Profile picture too large');
      return;
    }
    if (selectedLogoImage == null) {
      ApiProcessorController.errorSnack("Please add a profile picture");
      return;
    }

    if (await checkXFileSize(selectedCoverImage)) {
      ApiProcessorController.errorSnack('Cover picture too large');
      return;
    }
    if (selectedCoverImage == null) {
      ApiProcessorController.errorSnack("Please add a cover picture");
      return;
    }

    if (vendorPhoneNumberEC.text.isEmpty || vendorPhoneNumberEC.text == "") {
      ApiProcessorController.errorSnack("Please enter a phone number");
      return;
    }
    if (countryEC.text.isEmpty || countryEC.text == "") {
      ApiProcessorController.errorSnack("Please select a country");
      return;
    }
    if (stateEC.text.isEmpty || stateEC.text == "") {
      ApiProcessorController.errorSnack("Please select a state");
      return;
    }

    if (cityEC.text.isEmpty || cityEC.text == "") {
      ApiProcessorController.errorSnack("Please select a city");
      return;
    }
    if (vendorLGAEC.isBlank! || vendorLGAEC.text == "") {
      ApiProcessorController.errorSnack("Please select an LGA");
      return;
    }

// will use formcontroller to post
    Map data = {
      "phone": countryDialCode + vendorPhoneNumberEC.text,
      "address": mapsLocationEC.text,
      "email": vendorEmailEC.text,
      "personalId": personalIdEC.text,
      "country": countryEC.text,
      "state": stateEC.text,
      "city": cityEC.text,
      "latitude": latitude ?? "",
      "longitude": longitude ?? "",
      "first_name": vendorFirstNameEC.text,
      "last_name": vendorLastNameEC.text,
      "lga": vendorLGAEC.text,
      "vendorClassifier": vendorClassified,
    };
    print(data.toString());
    print(vendorClassified.toString());

    await FormController.instance.postAuthstream2(
        '$baseURL/agents/agentCreateVendor/${UserController.instance.user.value.id}',
        data,
        {
          "profileLogo": selectedLogoImage,
          "coverImage": selectedCoverImage,
        },
        'agentCreateVendor');
    if (FormController.instance.status.toString().startsWith('2')) {
      VendorController.instance.refreshData();
      Get.close(1);
    }
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

  Widget uploadBusinessCoverImage() => Column(
        mainAxisSize: MainAxisSize.min,
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
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Row(
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
                        pickCoverImage(ImageSource.gallery);
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
                    const Text("Gallery"),
                  ],
                ),
              ],
            ),
          ),
        ],
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
        appBar: MyAppBar(
          title: "Register a vendor",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        bottomNavigationBar: GetBuilder<FormController>(
          builder: (sending) {
            return Container(
              color: kPrimaryColor,
              padding: const EdgeInsets.all(kDefaultPadding),
              child: MyElevatedButton(
                onPressed: (() async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    saveChangesAsVendor();
                  }
                }),
                isLoading: sending.isLoad.value,
                title: "Save",
              ),
            );
          },
        ),
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
                child: Column(
                  children: [
                    selectedLogoImage == null
                        ? Container(
                            width: media.width,
                            height: 200,
                            decoration: const ShapeDecoration(
                              shape: CircleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  color: Color(0xFFE6E6E6),
                                ),
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
                        : Center(
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: kIsWeb
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
              ),
              DottedBorder(
                color: kLightGreyColor,
                borderPadding: const EdgeInsets.all(3),
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                borderType: BorderType.RRect,
                radius: const Radius.circular(20),
                child: Column(
                  children: [
                    selectedCoverImage == null
                        ? Container(
                            width: media.width,
                            height: 200,
                            decoration: const ShapeDecoration(
                              shape: CircleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  color: Color(0xFFE6E6E6),
                                ),
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
                        : Center(
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: kIsWeb
                                      ? Image.network(
                                          selectedCoverImage!.path,
                                          fit: BoxFit.fill,
                                          height: 120,
                                          width: 120,
                                        )
                                      : Image.file(
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.fill,
                                          File(
                                            selectedCoverImage!.path,
                                          ),
                                        ),
                                ),
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
                          builder: ((builder) => uploadBusinessCoverImage()),
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
              ),
              const Text(
                "Third party vendor account",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              kSizedBox,
              RadioGroup<String>.builder(
                groupValue: initialVendorClassifier,
                onChanged: (value) => setState(() {
                  initialVendorClassifier = value ?? "True";
                  log(initialVendorClassifier);

                  setState(() {
                    vendorClassified = !vendorClassified;
                  });
                  log("This is my vendor: $vendorClassified");
                }),
                items: vendorClassifierLabels,
                itemBuilder: (item) => RadioButtonBuilder(item),
                direction: Axis.horizontal,
                horizontalAlignment: MainAxisAlignment.start,
                activeColor: kAccentColor,
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
                              if (value == null || value == '') {
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
                              if (value == null || value == '') {
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
                              if (value == null || value == '') {
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
                              if (value == null || value == '') {
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
                            "Phone Number",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kSizedBox,
                          MyIntlPhoneField(
                            controller: vendorPhoneNumberEC,
                            // enabled: !vendorClassified,
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
                              if (value == null || value == '') {
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
                                // readOnly: vendorClassified,
                                validator: (value) {
                                  if (value == null || value == '') {
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
                            'Country',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          kSizedBox,
                          //  Address and location

                          GetBuilder<ShoppingLocationController>(
                            initState: (state) => ShoppingLocationController
                                .instance
                                .getShoppingLocationCountries(),
                            builder: (controller) => ItemDropDownMenu(
                              onSelected: (value) {
                                controller.getShoppingLocationState(value);
                                countryEC.text = value!.toString();
                                setState(() {});
                              },
                              itemEC: countryEC,
                              hintText: "Choose country",
                              dropdownMenuEntries:
                                  controller.isLoadCountry.value &&
                                          controller.country.isEmpty
                                      ? [
                                          const DropdownMenuEntry(
                                              value: 'Loading...',
                                              label: 'Loading...',
                                              enabled: false),
                                        ]
                                      : controller.country.isEmpty
                                          ? [
                                              const DropdownMenuEntry(
                                                  value: 'EMPTY',
                                                  label: 'EMPTY',
                                                  enabled: false),
                                            ]
                                          : controller.country
                                              .map(
                                                (item) => DropdownMenuEntry(
                                                  value: item.countryCode,
                                                  label: item.countryName,
                                                ),
                                              )
                                              .toList(),
                            ),
                          ),

                          kSizedBox,
                          const Text(
                            "Select state",
                            style: TextStyle(
                              fontSize: 17.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          kHalfSizedBox,
                          GetBuilder<ShoppingLocationController>(
                            builder: (controller) => ItemDropDownMenu(
                              onSelected: (value) {
                                stateEC.text = value!.toString();
                                controller.getShoppingLocationCity(value);
                                setState(() {});
                              },
                              itemEC: stateEC,
                              hintText: "Choose state",
                              dropdownMenuEntries: countryEC.text.isEmpty
                                  ? [
                                      const DropdownMenuEntry(
                                          value: 'Select Country',
                                          label: 'Select Country',
                                          enabled: false),
                                    ]
                                  : controller.isLoadState.value &&
                                          controller.state.isEmpty
                                      ? [
                                          const DropdownMenuEntry(
                                              value: 'Loading...',
                                              label: 'Loading...',
                                              enabled: false),
                                        ]
                                      : controller.state.isEmpty
                                          ? [
                                              const DropdownMenuEntry(
                                                  value: 'EMPTY',
                                                  label: 'EMPTY',
                                                  enabled: false),
                                            ]
                                          : controller.state
                                              .map(
                                                (item) => DropdownMenuEntry(
                                                  value: item.stateCode,
                                                  label: item.stateName,
                                                ),
                                              )
                                              .toList(),
                            ),
                          ),
                          kSizedBox,
                          const Text(
                            "Select city",
                            style: TextStyle(
                              fontSize: 17.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          kHalfSizedBox,
                          GetBuilder<ShoppingLocationController>(
                            builder: (controller) => ItemDropDownMenu(
                              onSelected: (value) {
                                cityEC.text = value!.toString();
                                setState(() {});
                              },
                              itemEC: cityEC,
                              hintText: "Choose city",
                              dropdownMenuEntries: stateEC.text.isEmpty
                                  ? [
                                      const DropdownMenuEntry(
                                          value: 'Select State',
                                          label: 'Select State',
                                          enabled: false),
                                    ]
                                  : controller.isLoadCity.value &&
                                          controller.city.isEmpty
                                      ? [
                                          const DropdownMenuEntry(
                                              value: 'Loading...',
                                              label: 'Loading...',
                                              enabled: false),
                                        ]
                                      : controller.city.isEmpty
                                          ? [
                                              const DropdownMenuEntry(
                                                  value: 'EMPTY',
                                                  label: 'EMPTY',
                                                  enabled: false),
                                            ]
                                          : controller.city
                                              .map(
                                                (item) => DropdownMenuEntry(
                                                  value: item.cityCode,
                                                  label: item.cityName,
                                                ),
                                              )
                                              .toList(),
                            ),
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
                              if (value == null || value == '') {
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
