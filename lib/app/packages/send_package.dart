// ignore_for_file: use_build_context_synchronously, invalid_use_of_protected_member

import 'dart:io';

import 'package:benji_aggregator/app/google_maps/get_location_on_map.dart';
import 'package:benji_aggregator/app/packages/packages.dart';
import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/form_controller.dart';
import 'package:benji_aggregator/controller/latlng_detail_controller.dart';
import 'package:benji_aggregator/controller/package_controller.dart';
import 'package:benji_aggregator/controller/payment_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/input/item_category_dropdown_menu.dart';
import 'package:benji_aggregator/src/components/input/my_intl_phonefield.dart';
import 'package:benji_aggregator/src/components/input/my_maps_textformfield.dart';
import 'package:benji_aggregator/src/components/input/my_textformfield.dart';
import 'package:benji_aggregator/src/components/input/number_textformfield.dart';
import 'package:benji_aggregator/src/components/section/location_list_tile.dart';
import 'package:benji_aggregator/src/googleMaps/autocomplete_prediction.dart';
import 'package:benji_aggregator/src/googleMaps/places_autocomplete_response.dart';
import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:benji_aggregator/src/utils/keys.dart';
import 'package:benji_aggregator/src/utils/network_utils.dart';
import 'package:benji_aggregator/src/utils/web_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../theme/colors.dart';
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

  final latLngDetailController = LatLngDetailController.instance;
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

    List location = await parseLatLng(newLocation);
    latitudePick = location[0];
    longitudePick = location[1];
  }

  setLocationDrop(index) async {
    final newLocation = placePredictionsDrop[index].description!;
    selectedLocationDrop.value = newLocation;

    setState(() {
      dropOffEC.text = newLocation;
    });

    List location = await parseLatLng(newLocation);
    latitudeDrop = location[0];
    longitudeDrop = location[1];
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
    String pinnedLocation =
        LatLngDetailController.instance.latLngDetail.value[2];
    String latitude = LatLngDetailController.instance.latLngDetail.value[0];
    String longitude = LatLngDetailController.instance.latLngDetail.value[1];

    double latitudeValue = double.parse(latitude);
    double longitudeValue = double.parse(longitude);

    setState(() {
      pickupEC.text = pinnedLocation;
      latitudePick = latitudeValue.toString();
      longitudePick = longitudeValue.toString();
    });
    if (kDebugMode) {
      print("LATLNG: $latitudePick,$longitudePick");
      print("pickup text : ${pickupEC.text}");
    }
  }

  void toGetLocationOnMapDrop() async {
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

    String pinnedLocation =
        LatLngDetailController.instance.latLngDetail.value[2];
    String latitude = LatLngDetailController.instance.latLngDetail.value[0];
    String longitude = LatLngDetailController.instance.latLngDetail.value[1];

    double latitudeValue = double.parse(latitude);
    double longitudeValue = double.parse(longitude);

    setState(() {
      dropOffEC.text = pinnedLocation;
      latitudeDrop = latitudeValue.toString();
      longitudeDrop = longitudeValue.toString();
    });

    // latitudeDrop = latLngDetailController.latLngDetail.value[0];
    // longitudeDrop = latLngDetailController.latLngDetail.value[1];
    // dropOffEC.text = latLngDetailController.latLngDetail.value[2];
    // latLngDetailController.setEmpty();
    if (kDebugMode) {
      print("LATLNG: $latitudeDrop,$longitudeDrop");
      print("dropOff text : ${dropOffEC.text}");
    }
  }

  _toPackageScreen() {
    Get.to(
      () => const Packages(),
      routeName: 'Packages',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
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
      ApiProcessorController.errorSnack("Please fill in your name");
      return;
    }
    if (senderPhoneEC.text.isEmpty) {
      ApiProcessorController.errorSnack("Please fill in your phone number");
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
    await FormController.instance.postAuth(Api.baseUrl + Api.createItemPackage,
        data, 'createPackage', "Error occurred", '');
    setState(() {
      submittingForm = true;
    });
    if (FormController.instance.status.toString().startsWith('2')) {
      var packageId =
          FormController.instance.responseObject.containsKey('package_id')
              ? FormController.instance.responseObject['package_id']
              : null; // or provide a default value if needed
      consoleLog("This is the package ID: $packageId");
      await PaymentController.instance.getDeliveryFee(packageId);
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

  Widget controlsBuilder(context, details) {
    final media = MediaQuery.of(context);
    return nextPage == false
        ? ElevatedButton(
            onPressed: details.onStepContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccentColor,
              foregroundColor: kTextWhiteColor,
              elevation: 20.0,
              fixedSize: Size(media.size.width, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Next"),
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
                          foregroundColor: kTextWhiteColor,
                          backgroundColor: kAccentColor,
                          elevation: 20.0,
                          fixedSize: Size((media.size.width * 0.60) - 45, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: controller.isLoad.value
                            ? CircularProgressIndicator(color: kPrimaryColor)
                            : const Text("Submit"),
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
                          color:
                              submittingForm ? kTextGreyColor : kAccentColor),
                    ),
                  )
                ],
              )
            : Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: kTextWhiteColor,
                      backgroundColor: kAccentColor,
                      elevation: 20.0,
                      fixedSize: Size((media.size.width * 0.60) - 45, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Next"),
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
            // mainAxisAlignment: MainAxis,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter pickup address",
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
                  if (value == null || value == "") {
                    pickupFN.requestFocus();
                    return "Enter a location";
                  }
                  if (latitudePick == null || longitudePick == null) {
                    pickupFN.requestFocus();
                    return "Please select a location so we can get the coordinates";
                  }
                  return null;
                },
                onChanged: (value) {
                  placeAutoCompletePick(value);
                  setState(() {
                    selectedLocationPick.value = value;
                    isTyping = true;
                  });
                  if (kDebugMode) {
                    print("ONCHANGED VALUE: ${selectedLocationPick.value}");
                  }
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
              kHalfSizedBox,
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
                    itemCount: placePredictionsPick.length,
                    itemBuilder: (context, index) => LocationListTile(
                      onTap: () => setLocationPick(index),
                      location: placePredictionsPick[index].description!,
                    ),
                  ),
                ),
              ),
              kSizedBox,
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
                  if (value == null || value == "") {
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
                  if (value == null || value == "") {
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
                "Enter drop-off address",
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
                  if (value == null || value == "") {
                    dropOffFN.requestFocus();
                    return "Enter a location";
                  }
                  if (latitudeDrop == null || longitudeDrop == null) {
                    dropOffFN.requestFocus();
                    return "Please select a location so we can get the coordinates";
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
              kHalfSizedBox,
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
                    itemCount: placePredictionsDrop.length,
                    itemBuilder: (context, index) => LocationListTile(
                      onTap: () => setLocationDrop(index),
                      location: placePredictionsDrop[index].description!,
                    ),
                  ),
                ),
              ),
              kSizedBox,
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
                  if (value == null || value == "") {
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
                      value == "" ||
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
                  if (value == null || value == "") {
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
              GetBuilder<MyPackageController>(
                init: MyPackageController(),
                initState: (controller) async {
                  await MyPackageController.instance.getPackageCategory();
                },
                builder: (controller) {
                  return ItemDropDownMenu(
                    itemEC: itemCategoryEC,
                    mediaWidth: media.width - 70,
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
                    dropdownMenuEntries2: controller.isLoad.value &&
                            controller.packageCategory.isEmpty
                        ? [
                            const DropdownMenuEntry(
                              value: 'Loading...',
                              label: 'Loading...',
                              enabled: false,
                            )
                          ]
                        : controller.packageCategory
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
              GetBuilder<MyPackageController>(
                init: MyPackageController(),
                initState: (controller) async {
                  await MyPackageController.instance.getPackageWeight();
                },
                builder: (controller) {
                  return ItemDropDownMenu(
                    itemEC: itemWeightEC,
                    mediaWidth: media.width - 70,
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
                    dropdownMenuEntries2: controller.isLoad.value &&
                            controller.packageWeight.isEmpty
                        ? [
                            const DropdownMenuEntry(
                              value: 'Loading...',
                              label: 'Loading...',
                              enabled: false,
                            )
                          ]
                        : controller.packageWeight
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
                  if (value == null || value == "") {
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
                inputFormatter: [FilteringTextInputFormatter.digitsOnly],
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
                  if (value == null || value == "") {
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
          actions: [
            Container(
              padding: const EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: _toPackageScreen,
                style: OutlinedButton.styleFrom(
                  // padding: const EdgeInsets.all(10),
                  disabledForegroundColor: kGreyColor,
                  disabledBackgroundColor: kLightGreyColor,
                  enabledMouseCursor: SystemMouseCursors.click,
                  disabledMouseCursor: SystemMouseCursors.forbidden,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: kAccentColor),
                ),
                child: const Text(
                  "My Packages",
                  style: TextStyle(
                    color: kTextBlackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
          backgroundColor: kPrimaryColor,
        ),
        floatingActionButton: isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: scrollToTop,
                mini: deviceType(media.width) > 2 ? false : true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: FaIcon(FontAwesomeIcons.chevronUp,
                    size: 18, color: kPrimaryColor),
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
