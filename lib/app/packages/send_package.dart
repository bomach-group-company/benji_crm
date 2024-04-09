// ignore_for_file: use_build_context_synchronously, invalid_use_of_protected_member

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../controller/api_processor_controller.dart';
import '../../controller/form_controller.dart';
import '../../controller/latlng_detail_controller.dart';
import '../../controller/push_notifications_controller.dart';
import '../../controller/send_package_controller.dart';
import '../../controller/user_controller.dart';
import '../../services/api_url.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/input/my_dropdown_menu.dart';
import '../../src/components/input/my_intl_phonefield.dart';
import '../../src/components/input/my_maps_textformfield.dart';
import '../../src/components/input/my_textformfield.dart';
import '../../src/components/input/number_textformfield.dart';
import '../../src/components/section/location_list_tile.dart';
import '../../src/googleMaps/autocomplete_prediction.dart';
import '../../src/googleMaps/places_autocomplete_response.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/keys.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../src/utils/network_utils.dart';
import '../../theme/colors.dart';
import '../google_maps/get_location_on_map.dart';
import 'pay_for_delivery.dart';

class SendPackage extends StatefulWidget {
  const SendPackage({super.key});

  @override
  State<SendPackage> createState() => _SendPackageState();
}

class _SendPackageState extends State<SendPackage> {
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  //===================== BOOL VALUES =======================\\
  bool isScrollToTopBtnVisible = false;

  //=============================== ALL VARIABLES ==================================\\
  int currentStep = 0;
  bool nextPage = false;
  bool continuePage = false;
  bool submittingForm = false;
  get media => MediaQuery.of(context).size;
  String? latitudePick;
  String? longitudePick;
  String? latitudeDrop;
  String? longitudeDrop;
  String itemCategory = "";
  String itemWeight = "";
  //=============================== CONTROLLERS ==================================\\

  final formKey = GlobalKey<FormState>();

  //=============================== CONTROLLERS ==================================\\
  final scrollController = ScrollController();
  final pickupEC = TextEditingController();
  final senderNameEC = TextEditingController();
  final senderPhoneEC = TextEditingController();
  final dropOffEC = TextEditingController();
  final receiverNameEC = TextEditingController();
  final receiverPhoneEC = TextEditingController();
  final itemNameEC = TextEditingController();
  final itemCategoryEC = TextEditingController();
  final itemWeightEC = TextEditingController();
  final itemQuantityEC = TextEditingController();

  final itemValueEC = TextEditingController();

  //=============================== FOCUS NODES ==================================\\
  final pickupFN = FocusNode();
  final senderNameFN = FocusNode();
  var senderPhoneFN = FocusNode();
  var dropOffFN = FocusNode();
  var receiverNameFN = FocusNode();
  var receiverPhoneFN = FocusNode();
  var itemNameFN = FocusNode();
  var itemQuantityFN = FocusNode();
  var itemValueFN = FocusNode();
  var isTyping = false;
  List<AutocompletePrediction> placePredictionsPick = [];
  List<AutocompletePrediction> placePredictionsDrop = [];
  final selectedLocationPick = ValueNotifier<String?>(null);
  final selectedLocationDrop = ValueNotifier<String?>(null);
  //=============================== FUNCTIONS ==================================\\
  void placeAutoCompletePick(String query) async {
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
        placePredictionsPick = result.predictions!;
      });
    }
  }

  void placeAutoCompleteDrop(String query) async {
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
        placePredictionsDrop = result.predictions!;
      });
    }
  }

  setLocationPick(index) async {
    final newLocation = placePredictionsPick[index].description!;
    selectedLocationPick.value = newLocation;

    setState(() {
      pickupEC.text = newLocation;
    });

    List<Location> location = await locationFromAddress(newLocation);
    latitudePick = location[0].latitude.toString();
    longitudePick = location[0].longitude.toString();
  }

  setLocationDrop(index) async {
    final newLocation = placePredictionsDrop[index].description!;
    selectedLocationDrop.value = newLocation;

    setState(() {
      dropOffEC.text = newLocation;
    });

    List<Location> location = await locationFromAddress(newLocation);
    latitudeDrop = location[0].latitude.toString();
    longitudeDrop = location[0].longitude.toString();
  }

  continueStep() {
    if (currentStep < 2) {
      setState(() {
        nextPage = true;
        currentStep = currentStep + 1;
      });
    }
    if (currentStep == 2) {
      setState(() {
        nextPage = true;
        continuePage = true;
      });
    }
  }

  cancelStep() {
    if (currentStep < 2) {
      setState(() {
        nextPage = false;
      });
    }

    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1;
        continuePage = false;
      });
    }
  }

  void toGetLocationOnMapPick() async {
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
      String latitude = latLngDetailController.latLngDetail.value[0];
      String longitude = latLngDetailController.latLngDetail.value[1];
      String pinnedLocation = latLngDetailController.latLngDetail.value[2];
      latLngDetailController.setEmpty();

      log(
        "Received Data - Maps Location: $pinnedLocation, Latitude: $latitude, Longitude: $longitude",
      );
      setState(() {
        pickupEC.text = pinnedLocation;
        latitudePick = latitude;
        longitudePick = longitude;
      });
    }

    log("LATLNG: $latitudePick,$longitudePick");
    log("pickup text : ${pickupEC.text}");
  }

  void toGetLocationOnMapDrop() async {
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
      String latitude = latLngDetailController.latLngDetail.value[0];
      String longitude = latLngDetailController.latLngDetail.value[1];
      String pinnedLocation = latLngDetailController.latLngDetail.value[2];
      latLngDetailController.setEmpty();

      setState(() {
        dropOffEC.text = pinnedLocation;
        latitudeDrop = latitude;
        longitudeDrop = longitude;
      });
    }

    log("LATLNG: $latitudeDrop,$longitudeDrop");
    log("dropOff text : ${dropOffEC.text}");
  }

  //===================== Scroll to Top ==========================\\
  Future<void> scrollToTop() async {
    await scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      isScrollToTopBtnVisible = false;
    });
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels >= 100 &&
        isScrollToTopBtnVisible != true) {
      setState(() {
        isScrollToTopBtnVisible = true;
      });
    }
    if (scrollController.position.pixels < 100 &&
        isScrollToTopBtnVisible == true) {
      setState(() {
        isScrollToTopBtnVisible = false;
      });
    }
  }

  submitForm() async {
    if (pickupEC.text.isEmpty) {
      ApiProcessorController.errorSnack("Please fill in a pickup address");
      return;
    }
    if (senderNameEC.text.isEmpty) {
      ApiProcessorController.errorSnack("Please fill in the sender's name");
      return;
    }
    if (senderPhoneEC.text.isEmpty) {
      ApiProcessorController.errorSnack(
          "Please fill in the sender's phone number");
      return;
    }
    if (dropOffEC.text.isEmpty) {
      ApiProcessorController.errorSnack("Please select a drop-off location");
      return;
    }
    if (receiverNameEC.text.isEmpty) {
      ApiProcessorController.errorSnack("Please fill in the receiver's name");
      return;
    }
    if (receiverPhoneEC.text.isEmpty) {
      ApiProcessorController.errorSnack(
          "Please fill in the receiver's phone number");
      return;
    }
    if (itemNameEC.text.isEmpty) {
      ApiProcessorController.errorSnack("Please fill in the item's name");
      return;
    }
    if (itemCategoryEC.text.isEmpty) {
      ApiProcessorController.errorSnack("Please select the item category");
      return;
    }
    if (itemWeightEC.text.isEmpty) {
      ApiProcessorController.errorSnack("Please select the item weight");
      return;
    }
    if (itemQuantityEC.text.isEmpty) {
      ApiProcessorController.errorSnack(
          "Please fill in the quantity of the item");
      return;
    }
    // if (selectedImage == null) {
    //   ApiProcessorController.errorSnack("Please select an image");
    //   return;
    // }
    Map data = {
      'client_id': UserController.instance.user.value.id.toString(),
      'pickUpAddress': pickupEC.text,
      'pickUpAddress_latitude': latitudePick,
      'pickUpAddress_longitude': longitudePick,
      'senderName': senderNameEC.text,
      'senderPhoneNumber': senderPhoneEC.text,
      'dropOffAddress': dropOffEC.text,
      'dropOffAddress_latitude': latitudeDrop,
      'dropOffAddress_longitude': longitudeDrop,
      'receiverName': receiverNameEC.text,
      'receiverPhoneNumber': receiverPhoneEC.text,
      'itemName': itemNameEC.text,
      'itemCategory_id': itemCategoryEC.text,
      'itemWeight_id': itemWeightEC.text,
      'itemQuantity': itemQuantityEC.text,
      'itemValue': itemValueEC.text,
    };
    consoleLog(data.toString());
    setState(() {
      submittingForm = true;
    });
    await FormController.instance
        .postAuth(Api.baseUrl + Api.createItemPackage, data, 'createPackage');
    setState(() {
      submittingForm = true;
    });
    if (FormController.instance.status.toString().startsWith('2')) {
      var packageId =
          FormController.instance.responseObject.containsKey('package_id')
              ? FormController.instance.responseObject['package_id']
              : null; // or provide a default value if needed
      consoleLog("This is the package ID: $packageId");
      await PushNotificationController.showNotification(
        title: "Success",
        body: "Your package form has been successfully submitted.",
        summary: "Package Delivery",
        largeIcon: "asset://assets/icons/package.png",
      );
      Get.to(
        () => PayForDelivery(
          packageId: packageId,
          senderName: senderNameEC.text,
          senderPhoneNumber: senderPhoneEC.text,
          receiverName: receiverNameEC.text,
          receiverPhoneNumber: receiverPhoneEC.text,
          receiverLocation: dropOffEC.text,
          itemName: itemNameEC.text,
          itemQuantity: itemQuantityEC.text,
          itemWeight: itemWeight,
          itemValue: itemValueEC.text,
          itemCategory: itemCategory,
        ),
        routeName: 'PayForDelivery',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
    }
  }

  //=============================== WIDGETS ==================================\\

  // Widget stepIconBuilder(context, details) {
  //   return Icon(
  //     Icons.check,
  //     color: kPrimaryColor,
  //     size: 15,
  //   );
  // }

  Widget controlsBuilder(context, details) {
    final media = MediaQuery.of(context);
    return nextPage == false
        ? ElevatedButton(
            onPressed: details.onStepContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccentColor,
              elevation: 20.0,
              fixedSize: Size(media.size.width, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Next",
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        : continuePage == true
            ? Row(
                children: [
                  GetBuilder<FormController>(
                    builder: (controller) {
                      submittingForm = controller.isLoad.value;
                      return ElevatedButton(
                        onPressed: controller.isLoad.value ? null : submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kAccentColor,
                          elevation: 20.0,
                          fixedSize: Size((media.size.width * 0.60) - 45, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: controller.isLoad.value
                            ? CircularProgressIndicator(color: kPrimaryColor)
                            : Text(
                                "Submit",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                      );
                    },
                  ),
                  kWidthSizedBox,
                  OutlinedButton(
                    onPressed: submittingForm ? null : details.onStepCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          submittingForm ? kLightGreyColor : kPrimaryColor,
                      elevation: 20.0,
                      side: submittingForm
                          ? BorderSide(color: kLightGreyColor, width: 1.2)
                          : BorderSide(color: kAccentColor, width: 1.2),
                      fixedSize: Size((media.size.width * 0.40) - 45, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Back",
                      style: TextStyle(
                        color: submittingForm ? kTextGreyColor : kAccentColor,
                      ),
                    ),
                  )
                ],
              )
            : Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentColor,
                      elevation: 20.0,
                      fixedSize: Size((media.size.width * 0.60) - 45, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  kWidthSizedBox,
                  OutlinedButton(
                    onPressed: details.onStepCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      elevation: 20.0,
                      side: BorderSide(color: kAccentColor, width: 1.2),
                      fixedSize: Size((media.size.width * 0.40) - 45, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Back",
                      style: TextStyle(color: kAccentColor),
                    ),
                  )
                ],
              );
  }

  List<Step> steps() => [
        Step(
          subtitle: const Text("details"),
          isActive: currentStep >= 0,
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          title: const Text(
            "Sender's",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pickup Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyMapsTextFormField(
                // readOnly: true,
                controller: pickupEC,
                validator: (value) {
                  RegExp pickupAddress = RegExp(r'^\d+\s+[a-zA-Z0-9\s.-]+$');
                  if (value!.isEmpty || value == null) {
                    pickupFN.requestFocus();
                    return "Enter pickup location";
                  } else if (!pickupAddress.hasMatch(value)) {
                    pickupFN.requestFocus();
                    return "Enter a valid address (must have a street number)";
                  }
                  return null;
                },
                onChanged: (value) {
                  placeAutoCompletePick(value);
                  setState(() {
                    selectedLocationPick.value = value;
                    isTyping = true;
                  });

                  log("ONCHANGED VALUE: ${selectedLocationPick.value}");
                },
                onSaved: (value) {
                  pickupEC.text = value;
                },
                textInputAction: TextInputAction.next,
                focusNode: pickupFN,
                hintText: "Pick location",
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
                onPressed: toGetLocationOnMapPick,
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
              kHalfSizedBox,
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
                    itemCount: placePredictionsPick.length,
                    itemBuilder: (context, index) => LocationListTile(
                      onTap: () => setLocationPick(index),
                      location: placePredictionsPick[index].description!,
                    ),
                  ),
                ),
              ),
              kHalfSizedBox,
              const Text(
                "Sender's Name",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyTextFormField(
                controller: senderNameEC,
                validator: (value) {
                  RegExp userNamePattern = RegExp(
                    r'^.{3,}$', //Min. of 3 characters
                  );
                  if (value == null || value!.isEmpty) {
                    senderNameFN.requestFocus();
                    return "Enter your name";
                  } else if (!userNamePattern.hasMatch(value)) {
                    senderNameFN.requestFocus();
                    return "Name must be at least 3 characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  senderNameEC.text = value;
                },
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                focusNode: senderNameFN,
                hintText: "Enter your name",
                textInputType: TextInputType.name,
              ),
              kHalfSizedBox,
              const Text(
                "Phone Number",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyIntlPhoneField(
                initialCountryCode: "NG",
                invalidNumberMessage: "Invalid phone number",
                dropdownIconPosition: IconPosition.trailing,
                showCountryFlag: true,
                showDropdownIcon: true,
                dropdownIcon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: kAccentColor,
                ),
                controller: senderPhoneEC,
                textInputAction: TextInputAction.done,
                focusNode: senderPhoneFN,
                validator: (value) {
                  if (value == null || value!.isEmpty) {
                    senderPhoneFN.requestFocus();
                    return "Enter your phone number";
                  }
                  return null;
                },
                onSaved: (value) {
                  senderPhoneEC.text = value;
                },
              ),
              kSizedBox,
            ],
          ),
        ),
        Step(
          subtitle: const Text("details"),
          isActive: currentStep >= 1,
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          title: const Text(
            "Receiver's",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          content: Column(
            // mainAxisAlignment: MainAxis,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Drop-off Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyMapsTextFormField(
                // readOnly: true,
                controller: dropOffEC,
                validator: (value) {
                  RegExp dropoffAddress = RegExp(r'^\d+\s+[a-zA-Z0-9\s.-]+$');
                  if (value!.isEmpty || value == null) {
                    dropOffFN.requestFocus();
                    return "Enter drop-off location";
                  } else if (!dropoffAddress.hasMatch(value)) {
                    dropOffFN.requestFocus();
                    return "Enter a valid address (must have a street number)";
                  }
                  return null;
                },
                onChanged: (value) {
                  placeAutoCompleteDrop(value);
                  setState(() {
                    selectedLocationDrop.value = value;
                    isTyping = true;
                  });
                  if (kDebugMode) {
                    print("ONCHANGED VALUE: ${selectedLocationDrop.value}");
                  }
                },
                onSaved: (value) {
                  dropOffEC.text = value;
                },
                textInputAction: TextInputAction.next,
                focusNode: dropOffFN,
                hintText: "Drop off location",
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
                onPressed: toGetLocationOnMapDrop,
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
              kHalfSizedBox,
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
                    itemCount: placePredictionsDrop.length,
                    itemBuilder: (context, index) => LocationListTile(
                      onTap: () => setLocationDrop(index),
                      location: placePredictionsDrop[index].description!,
                    ),
                  ),
                ),
              ),
              kHalfSizedBox,
              const Text(
                "Receiver's Name",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyTextFormField(
                controller: receiverNameEC,
                validator: (value) {
                  RegExp userNamePattern = RegExp(
                    r'^.{3,}$', //Min. of 3 characters
                  );
                  if (value == null || value!.isEmpty) {
                    receiverNameFN.requestFocus();
                    return "Enter receiver's name";
                  } else if (!userNamePattern.hasMatch(value)) {
                    receiverNameFN.requestFocus();
                    return "Name must be at least 3 characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  receiverNameEC.text = value;
                },
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                focusNode: receiverNameFN,
                hintText: "Enter receiver's name",
                textInputType: TextInputType.name,
              ),
              kHalfSizedBox,
              const Text(
                "Phone Number",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyIntlPhoneField(
                initialCountryCode: "NG",
                invalidNumberMessage: "Invalid phone number",
                dropdownIconPosition: IconPosition.trailing,
                showCountryFlag: true,
                showDropdownIcon: true,
                dropdownIcon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: kAccentColor,
                ),
                controller: receiverPhoneEC,
                textInputAction: TextInputAction.done,
                focusNode: receiverPhoneFN,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      receiverPhoneEC.text.isEmpty) {
                    receiverPhoneFN.requestFocus();
                    return "Enter receiver's phone number";
                  }
                  return null;
                },
                onSaved: (value) {
                  receiverPhoneEC.text = value;
                },
              ),
              kSizedBox,
            ],
          ),
        ),
        Step(
          subtitle: const Text("details"),
          isActive: currentStep >= 2,
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          title: const Text(
            "Item",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Item Name",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyTextFormField(
                controller: itemNameEC,
                validator: (value) {
                  RegExp userNamePattern = RegExp(
                    r'^.{3,}$', //Min. of 3 characters
                  );
                  if (value == null || value!.isEmpty) {
                    itemNameFN.requestFocus();
                    return "Enter the item's name";
                  } else if (!userNamePattern.hasMatch(value)) {
                    itemNameFN.requestFocus();
                    return "Name must be at least 3 characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  itemNameEC.text = value;
                },
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                focusNode: itemNameFN,
                hintText: "Enter the name of the item",
                textInputType: TextInputType.name,
              ),
              kHalfSizedBox,
              const Text(
                "Item Category",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              GetBuilder<SendPackageController>(
                init: SendPackageController(),
                initState: (controller) async {
                  await SendPackageController.instance.getPackageCategory();
                },
                builder: (controller) {
                  return controller.isLoad.value
                      ? Center(
                          child: CircularProgressIndicator(color: kAccentColor),
                        )
                      : MyDropDownMenu(
                          controller: itemCategoryEC,
                          width: media.width - 70,
                          hintText: "Choose category",
                          onSelected: (value) {
                            final selectedCategory =
                                controller.packageCategory.firstWhere(
                              (category) => category.id == value,
                            );
                            // Set the category id to itemWeightEC
                            itemCategoryEC.text = value.toString();
                            // Set the category title to itemWeight
                            itemCategory = selectedCategory.name;

                            consoleLog(
                              "This is the item category title: $itemCategory",
                            );
                            consoleLog(
                                "This is the item category ID: ${itemCategoryEC.text}");
                          },
                          dropdownMenuEntries: controller.packageCategory
                              .map((category) => DropdownMenuEntry(
                                    value: category.id,
                                    label: category.name,
                                  ))
                              .toList(),
                        );
                },
              ),

              kSizedBox,
              const Text(
                "Item Weight",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              GetBuilder<SendPackageController>(
                init: SendPackageController(),
                initState: (controller) async {
                  await SendPackageController.instance.getPackageWeight();
                },
                builder: (controller) {
                  return controller.isLoad.value
                      ? Center(
                          child: CircularProgressIndicator(color: kAccentColor),
                        )
                      : MyDropDownMenu(
                          controller: itemWeightEC,
                          width: media.width - 70,
                          hintText: "Choose weight",
                          onSelected: (value) {
                            final selectedWeight =
                                controller.packageWeight.firstWhere(
                              (category) => category.id == value,
                            );
                            // Set the weight id to itemWeightEC
                            itemWeightEC.text = value.toString();
                            // Set the weight title to itemWeight
                            itemWeight =
                                "${selectedWeight.start}KG - ${selectedWeight.end}KG";

                            consoleLog(
                              "This is the item weight title: $itemWeight",
                            );
                            consoleLog(
                              "This is the item weight ID: ${itemWeightEC.text}",
                            );
                          },
                          dropdownMenuEntries: controller.packageWeight
                              .map((category) => DropdownMenuEntry(
                                    value: category.id,
                                    label:
                                        "${category.start}KG - ${category.end}KG ",
                                  ))
                              .toList(),
                        );
                },
              ),
              kSizedBox,
              const Text(
                "Item Quantity",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              NumberTextFormField(
                controller: itemQuantityEC,
                validator: (value) {
                  if (value == null || value!.isEmpty) {
                    itemQuantityFN.requestFocus();
                    return "Enter the item's quantity";
                  }
                  return null;
                },
                onSaved: (value) {
                  itemQuantityEC.text = value;
                },
                textInputAction: TextInputAction.next,
                focusNode: itemQuantityFN,
                hintText: "Enter the quantity ",
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              kSizedBox,
              const Text(
                "Item Value",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyTextFormField(
                controller: itemValueEC,
                validator: (value) {
                  if (value == null || value!.isEmpty) {
                    itemValueFN.requestFocus();
                    return "Enter the item's value (in Naira)";
                  }
                  return null;
                },
                onSaved: (value) {
                  itemValueEC.text = value;
                },
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                focusNode: itemValueFN,
                hintText: "Enter the value (in Naira)",
                textInputType: TextInputType.number,
              ),
              kSizedBox,
              // DottedBorder(
              //   color: kLightGreyColor,
              //   borderPadding: const EdgeInsets.all(3),
              //   padding: const EdgeInsets.all(kDefaultPadding / 2),
              //   borderType: BorderType.RRect,
              //   radius: const Radius.circular(20),
              //   child: Column(
              //     children: [
              //       selectedImage == null
              //           ? Container(
              //               width: media.width,
              //               height: 144,
              //               decoration: ShapeDecoration(
              //                 image: const DecorationImage(
              //                     image: AssetImage(
              //                         "assets/icons/image-upload.png")),
              //                 shape: RoundedRectangleBorder(
              //                   side: const BorderSide(
              //                     width: 0.50,
              //                     color: Color(0xFFE6E6E6),
              //                   ),
              //                   borderRadius: BorderRadius.circular(20),
              //                 ),
              //               ),
              //             )
              //           : Container(
              //               width: media.width,
              //               height: deviceType(media.width) >= 2 ? 280 : 200,
              //               decoration: ShapeDecoration(
              //                 image: DecorationImage(
              //                   image: FileImage(selectedImage!),
              //                   fit: BoxFit.contain,
              //                 ),
              //                 shape: RoundedRectangleBorder(
              //                   side: const BorderSide(
              //                     width: 0.50,
              //                     color: Color(0xFFE6E6E6),
              //                   ),
              //                   borderRadius: BorderRadius.circular(20),
              //                 ),
              //               ),
              //             ),
              //       InkWell(
              //         onTap: () {
              //           showModalBottomSheet(
              //             context: context,
              //             elevation: 20,
              //             barrierColor: kBlackColor.withOpacity(0.8),
              //             showDragHandle: true,
              //             useSafeArea: true,
              //             isDismissible: true,
              //             isScrollControlled: true,
              //             shape: const RoundedRectangleBorder(
              //               borderRadius: BorderRadius.vertical(
              //                 top: Radius.circular(kDefaultPadding),
              //               ),
              //             ),
              //             enableDrag: true,
              //             builder: ((builder) => uploadCoverImage()),
              //           );
              //         },
              //         splashColor: kAccentColor.withOpacity(0.1),
              //         borderRadius: BorderRadius.circular(10),
              //         child: Container(
              //           padding: const EdgeInsets.all(10),
              //           child: Text(
              //             'Upload item image',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //               color: kAccentColor,
              //               fontSize: 16,
              //               fontWeight: FontWeight.w400,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // kSizedBox,
            ],
          ),
        ),
      ];

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
              "Upload Image",
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

  //=========================== IMAGE PICKER ====================================\\

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  // File? selectedLogoImage;
  //================================== function ====================================\\
  pickCoverImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
    );
    if (image != null) {
      selectedImage = File(image.path);
      Get.back();
      setState(() {});
    }
  }

  //Main App Widget

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          title: "Send Package",
          elevation: 0.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        floatingActionButton: isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: scrollToTop,
                mini: deviceType(media.width) > 2 ? false : true,
                backgroundColor: kAccentColor,
                foregroundColor: kPrimaryColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: const FaIcon(FontAwesomeIcons.chevronUp, size: 18),
              )
            : const SizedBox(),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: Form(
              key: formKey,
              child: Scrollbar(
                child: Stepper(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  currentStep: currentStep,
                  onStepContinue: continueStep,
                  onStepCancel: cancelStep,
                  onStepTapped: null,
                  controlsBuilder: controlsBuilder,
                  elevation: 0.0,
                  // stepIconBuilder: stepIconBuilder,
                  type: StepperType.horizontal,
                  steps: steps(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
