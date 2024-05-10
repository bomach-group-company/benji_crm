// ignore_for_file: use_build_context_synchronously, invalid_use_of_protected_member

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/app/google_maps/get_location_on_map.dart';
import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/latlng_detail_controller.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/model/third_party_vendor_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/button/my_elevatedButton.dart';
import 'package:benji_aggregator/src/components/image/my_image.dart';
import 'package:benji_aggregator/src/components/input/my_intl_phonefield.dart';
import 'package:benji_aggregator/src/components/input/my_maps_textformfield.dart';
import 'package:benji_aggregator/src/components/input/name_textformfield.dart';
import 'package:benji_aggregator/src/components/section/location_list_tile.dart';
import 'package:benji_aggregator/src/googleMaps/autocomplete_prediction.dart';
import 'package:benji_aggregator/src/googleMaps/places_autocomplete_response.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:benji_aggregator/src/utils/keys.dart';
import 'package:benji_aggregator/src/utils/network_utils.dart';
import 'package:benji_aggregator/src/utils/web_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../theme/colors.dart';
import '../../controller/form_controller.dart';
import '../../controller/push_notifications_controller.dart';

class EditThirdPartyVendor extends StatefulWidget {
  final ThirdPartyVendorModel vendor;
  const EditThirdPartyVendor({super.key, required this.vendor});

  @override
  State<EditThirdPartyVendor> createState() => _EditThirdPartyVendorState();
}

class _EditThirdPartyVendorState extends State<EditThirdPartyVendor> {
  //==========================================================================================\\
  @override
  void initState() {
    super.initState();
    firstNameEC.text = widget.vendor.firstName;
    lastNameEC.text = widget.vendor.lastName;
    mapsLocationEC.text = widget.vendor.address;
    userPhoneNumberEC.text = widget.vendor.phone.replaceFirst("+234", '');
    latitude = widget.vendor.latitude;
    longitude = widget.vendor.longitude;
    horizontalGroupValue = widget.vendor.gender;
    profileLogo = widget.vendor.profileLogo;
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

  String? latitude;
  String? longitude;
  List<AutocompletePrediction> placePredictions = [];
  final selectedLocation = ValueNotifier<String?>(null);
  final genders = ["male", "female"];
  String? horizontalGroupValue;
  String? profileLogo;

  //=========================== BOOL VALUES ====================================\\

  bool isTyping = false;

  //======================================== GLOBAL KEYS ==============================================\\
  final formKey = GlobalKey<FormState>();

  //=========================== CONTROLLERS ====================================\\
  final scrollController = ScrollController();
  final userNameEC = TextEditingController();
  final firstNameEC = TextEditingController();
  final lastNameEC = TextEditingController();
  final mapsLocationEC = TextEditingController();

  final userPhoneNumberEC = TextEditingController();

  //=========================== FOCUS NODES ====================================\\
  final userPhoneNumberFN = FocusNode();
  final userNameFN = FocusNode();
  final firstNameFN = FocusNode();
  final lastNameFN = FocusNode();
  final mapsLocationFN = FocusNode();

//=========================== IMAGE PICKER ====================================\\

  final ImagePicker _picker = ImagePicker();
  XFile? selectedLogoImage;
  //================================== function ====================================\\

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

  //========================================================================\\
  //=========================== FUNCTIONS ====================================\\
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
    print('in the placeAutoComplete 1');
    Uri uri = Uri.https(
        "maps.googleapis.com",
        '/maps/api/place/autocomplete/json', //unencoder path
        {
          "input": query, //query params
          "key": googlePlacesApiKey, //google places api key
        });
    print('in the placeAutoComplete 2');

    String? response = await NetworkUtility.fetchUrl(uri);
    print(response);
    PlaceAutocompleteResponse result =
        PlaceAutocompleteResponse.parseAutoCompleteResult(response!);
    if (result.predictions != null) {
      setState(() {
        placePredictions = result.predictions!;
      });
    }
    print('in the placeAutoComplete 3');
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

  Future<void> updateData() async {
    if (await checkXFileSize(selectedLogoImage)) {
      ApiProcessorController.errorSnack('Profile image too large');
      return;
    }
    Map data = {
      'first_name': firstNameEC.text,
      'last_name': lastNameEC.text,
      'address': mapsLocationEC.text,
      'gender': horizontalGroupValue,
      'phone': countryDialCode + userPhoneNumberEC.text,
      'latitude': latitude,
      'longitude': longitude,
    };
    print(data);
    log("This is the data: $data");
    var url = Api.baseUrl +
        Api.changeVendorPersonalProfile +
        widget.vendor.id.toString();
    log(url);
    log("profile logo: $selectedLogoImage");
    await FormController.instance.postAuthstream2(
        url,
        data,
        {'profileLogo': selectedLogoImage},
        "changeVendorPersonalProfile",
        true);
    if (FormController.instance.status.toString().startsWith('2')) {}
    await PushNotificationController.showNotification(
      title: "Success.",
      body: "Your personal profile has been successfully updated.",
    );
    Get.close(2);
    VendorController.instance.refreshData();
  }

  Widget uploadLogoImage() => Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "Upload Profile picture",
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
                            FontAwesomeIcons.images,
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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        appBar: MyAppBar(
          title: "Edit third party vendor",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: ListView(
            shrinkWrap: true,
            controller: scrollController,
            padding: const EdgeInsets.all(kDefaultPadding),
            physics: const BouncingScrollPhysics(),
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: ClipOval(
                      child: Center(
                        child: selectedLogoImage == null
                            ? MyImage(
                                height: 120,
                                width: 120,
                                url: profileLogo!,
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
                  kHalfSizedBox,
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
                    onLongPress: null,
                    splashColor: kAccentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Upload your profile picture',
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
              kSizedBox,
              Form(
                key: formKey,
                child: ValueListenableBuilder(
                    valueListenable: selectedLocation,
                    builder: (context, selectedLocationValue, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          kSizedBox,
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
                              if (value == null || value == '') {
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
                              if (value == null || value == '') {
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
                          RadioGroup<String>.builder(
                            groupValue: horizontalGroupValue!.toLowerCase(),
                            direction: Axis.horizontal,
                            activeColor: kAccentColor,
                            onChanged: (value) => setState(() {
                              horizontalGroupValue = value!;
                            }),
                            items: genders,
                            itemBuilder: (item) => RadioButtonBuilder(item),
                          ),
                          kSizedBox,
                          Text(
                            "Phone Number".toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          kHalfSizedBox,
                          MyIntlPhoneField(
                            controller: userPhoneNumberEC,
                            initialCountryCode: "NG",
                            invalidNumberMessage: "Invalid phone number",
                            dropdownIconPosition: IconPosition.trailing,
                            showCountryFlag: true,
                            showDropdownIcon: true,
                            dropdownIcon: Icon(Icons.arrow_drop_down_rounded,
                                color: kAccentColor),
                            textInputAction: TextInputAction.next,
                            focusNode: userPhoneNumberFN,
                            validator: (value) {
                              if (value == null ||
                                  userPhoneNumberEC.text.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              userPhoneNumberEC.text = value!;
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
                                  if (value == null || value == "") {
                                    mapsLocationFN.requestFocus();
                                    return "Enter a location";
                                  }
                                  if (latitude == null || longitude == null) {
                                    mapsLocationFN.requestFocus();
                                    return "Please select a location so we can get the coordinates";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  placeAutoComplete(value);
                                  setState(() {
                                    selectedLocation.value = value;
                                    isTyping = true;
                                  });
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
                                  if (isTyping == false) {
                                    return 0.0;
                                  }
                                  if (isTyping == true) {
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
                        ],
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: GetBuilder<FormController>(
                  init: FormController(),
                  builder: (saving) {
                    return MyElevatedButton(
                      onPressed: (() async {
                        if (formKey.currentState!.validate()) {
                          updateData();
                        }
                      }),
                      isLoading: saving.isLoad.value,
                      title: "Save",
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
