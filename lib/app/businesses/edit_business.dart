// ignore_for_file: unused_local_variable, use_build_context_synchronously, unused_field, invalid_use_of_protected_member

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/src/components/input/my_dropdown_menu.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../src/providers/constants.dart';
import '../../controller/api_processor_controller.dart';
import '../../controller/category_controller.dart';
import '../../controller/form_controller.dart';
import '../../controller/latlng_detail_controller.dart';
import '../../controller/withdraw_controller.dart';
import '../../model/vendor_business_model.dart';
import '../../services/api_url.dart';
import '../../services/helper.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/button/my_elevatedButton.dart';
import '../../src/components/image/my_image.dart';
import '../../src/components/input/message_textformfield.dart';
import '../../src/components/input/my_blue_textformfield.dart';
import '../../src/components/input/my_textformfield.dart';
import '../../src/googleMaps/autocomplete_prediction.dart';
import '../../src/googleMaps/places_autocomplete_response.dart';
import '../../src/providers/keys.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../src/utils/network_utils.dart';
import '../../theme/colors.dart';
import '../google_maps/get_location_on_map.dart';
import '../withdrawal/select_bank.dart';

class EditBusiness extends StatefulWidget {
  const EditBusiness({super.key, this.business});
  final BusinessModel? business;

  @override
  State<EditBusiness> createState() => _EditBusinessState();
}

class _EditBusinessState extends State<EditBusiness> {
  //==========================================================================================\\
  @override
  void initState() {
    super.initState();
    CategoryController.instance.getCategory();
    scrollController.addListener(_scrollListener);
    if (widget.business != null) {
      mapsLocationEC.text = widget.business!.address;
      latitude = widget.business!.latitude;
      longitude = widget.business!.longitude;
      accountBankEC.text = widget.business!.accountBank;
      accountNameEC.text = widget.business!.accountName;
      accountNumberEC.text = widget.business!.accountNumber;
      accountTypeEC.text = widget.business!.accountType;
      countryValue = widget.business!.country.name;
      stateValue = widget.business!.state;
      cityValue = widget.business!.city;

      businessIdEC.text = widget.business!.businessId;
      businessLogo = widget.business!.shopImage;
      businessCoverImage = widget.business!.coverImage;
      shopNameEC.text = widget.business!.shopName;
      vendorMonToFriOpeningHoursEC.text = widget.business!.weekOpeningHours;
      vendorMonToFriClosingHoursEC.text = widget.business!.weekClosingHours;
      vendorSatOpeningHoursEC.text = widget.business!.satOpeningHours;
      vendorSatClosingHoursEC.text = widget.business!.satClosingHours;
      vendorSunOpeningHoursEC.text = widget.business!.sunWeekOpeningHours;
      vendorSunClosingHoursEC.text = widget.business!.sunWeekClosingHours;
      businessBioEC.text = widget.business!.businessBio;
      vendorBusinessTypeEC.text = widget.business!.shopType.name;

      log("This is the shop image: $businessLogo");
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

//==========================================================================================\\

  //===================== ALL VARIABLES =======================\\
  String? businessLogo;
  String? businessCoverImage;
  String? shopType;
  String bankCode = "";
  List<AutocompletePrediction> placePredictions = [];
  final selectedLocation = ValueNotifier<String?>(null);
  final LatLngDetailController latLngDetailController =
      LatLngDetailController.instance;
  String? latitude;
  String? longitude;
  bool isTyping = false;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  //======================================== GLOBAL KEYS ==============================================\\
  final _formKey = GlobalKey<FormState>();

  //===================== BOOL VALUES =======================\\
  bool isScrollToTopBtnVisible = false;

  //============================================== CONTROLLERS =================================================\\
  final scrollController = ScrollController();
  final shopNameEC = TextEditingController();
  final vendorMonToFriOpeningHoursEC = TextEditingController();
  final vendorSatOpeningHoursEC = TextEditingController();
  final vendorSunOpeningHoursEC = TextEditingController();
  final vendorMonToFriClosingHoursEC = TextEditingController();
  final vendorSatClosingHoursEC = TextEditingController();
  final vendorSunClosingHoursEC = TextEditingController();
  final businessBioEC = TextEditingController();
  final vendorBusinessTypeEC = TextEditingController();
  final mapsLocationEC = TextEditingController();
  final vendorLGAEC = TextEditingController();

  final accountNameEC = TextEditingController();
  final accountNumberEC = TextEditingController();
  final accountTypeEC = TextEditingController();
  final accountBankEC = TextEditingController();

  final businessIdEC = TextEditingController();

  //=================================== FOCUS NODES ====================================\\
  final shopNameFN = FocusNode();
  final vendorMonToFriOpeningHoursFN = FocusNode();
  final vendorSatOpeningHoursFN = FocusNode();
  final vendorSunOpeningHoursFN = FocusNode();
  final vendorMonToFriClosingHoursFN = FocusNode();
  final vendorSatClosingHoursFN = FocusNode();
  final vendorSunClosingHoursFN = FocusNode();
  final businessBioFN = FocusNode();
  final vendorBusinessTypeFN = FocusNode();
  final vendorLGAFN = FocusNode();

  final addressFN = FocusNode();
  final accountNameFN = FocusNode();
  final accountNumberFN = FocusNode();
  final accountTypeFN = FocusNode();
  final accountBankFN = FocusNode();

  final businessIdFN = FocusNode();

  //============================================= FUNCTIONS ===============================================\\

//=========================== IMAGE PICKER ====================================\\

  final ImagePicker _picker = ImagePicker();
  File? selectedLogoImage;
  File? selectedCoverImage;
  //================================== function ====================================\\
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

// select bank
  selectBank() async {
    final result = await Get.to(
      () => const SelectBank(),
      routeName: 'SelectBank',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.downToUp,
    );
    if (result != null) {
      final newBankName = result['name'];
      final newBankCode = result['code'];

      setState(() {
        accountBankEC.text = newBankName;
        bankCode = newBankCode;
      });
    }
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
      mapsLocationEC.text = result["pinnedLocation"];
      latitude = result["latitude"];
      longitude = result["longitude"];
    }
    log(
      "Received Data - Maps Location: ${mapsLocationEC.text}, Latitude: $latitude, Longitude: $longitude",
    );
  }

  //========================== Save data ==================================\\
  Future<void> saveChanges() async {
    if (selectedCoverImage == null && businessCoverImage!.isEmpty) {
      ApiProcessorController.errorSnack("Please select a shop image");
      return;
    }
    if (selectedLogoImage == null && businessLogo!.isEmpty) {
      ApiProcessorController.errorSnack("Please select a shop image");
      return;
    }
    if (shopType == null &&
        vendorBusinessTypeEC.text.isEmpty &&
        shopType!.isEmpty) {
      ApiProcessorController.errorSnack("Please select a type of business");
      return;
    }
    Map data = {
      "address": mapsLocationEC.text,
      "latitude": latitude,
      "longitude": longitude,
      "accountBank": accountBankEC.text,
      "accountName": accountNameEC.text,
      "accountNumber": accountNumberEC.text,
      "accountType": accountTypeEC.text,
      // "country": countryValue,
      // "state": stateValue,
      // "city": cityValue,
      "businessId": businessIdEC.text,
      "shop_name": shopNameEC.text,
      "weekOpeningHours": vendorMonToFriOpeningHoursEC.text,
      "weekClosingHours": vendorMonToFriClosingHoursEC.text,
      "satOpeningHours": vendorSatOpeningHoursEC.text,
      "satClosingHours": vendorSatClosingHoursEC.text,
      "sunWeekOpeningHours": vendorSunOpeningHoursEC.text,
      "sunWeekClosingHours": vendorSunClosingHoursEC.text,
      "businessBio": businessBioEC.text,
      "shop_type": vendorBusinessTypeEC.text,
    };
    log("This is the data: $data");

    log("shop_image: ${selectedLogoImage?.path}");
    await FormController.instance.postAuthstream(
      '${Api.baseUrl}/vendors/createVendorBusiness/${widget.business!.id.toString()}',
      data,
      {'shop_image': selectedLogoImage},
      'changeVendorBusinessProfile',
    );
    if (FormController.instance.status.toString().startsWith('2')) {
      // await PushNotificationController.showNotification(
      //   title: "Success.",
      //   body: "Your business profile has been successfully updated.",
      // );
      Get.close(1);
    }
  }

  //=========================== WIDGETS ====================================\\
  Widget uploadBusinessLogo() => Column(
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
  Future<void> _scrollToTop() async {
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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        appBar: MyAppBar(
          title: "Edit your business",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        bottomNavigationBar: GetBuilder<FormController>(
            init: FormController(),
            builder: (saving) {
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
                  isLoading: saving.isLoad.value,
                  title: "Save",
                ),
              );
            }),
        floatingActionButton: isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: _scrollToTop,
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
            child: Scrollbar(
          controller: scrollController,
          child: ListView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(kDefaultPadding),
            children: [
              const Text(
                "Business content",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "This is visible to users",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kAccentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
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
                    selectedLogoImage == null
                        ? Container(
                            padding: const EdgeInsets.all(kDefaultPadding),
                            decoration: const ShapeDecoration(
                              shape: CircleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  color: kGreyColor1,
                                ),
                              ),
                            ),
                            child: Center(
                              child: MyImage(url: businessLogo),
                            ),
                          )
                        : Container(
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: FileImage(selectedLogoImage!),
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
                          builder: ((builder) => uploadBusinessLogo()),
                        );
                      },
                      splashColor: kAccentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Upload business logo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kAccentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    kSizedBox,
                    selectedCoverImage == null
                        ? Container(
                            padding: const EdgeInsets.all(20),
                            height: deviceType(media.width) > 2 ? 200 : 120,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 0.50,
                                  color: Color(0xFFE6E6E6),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: MyImage(
                                url: businessCoverImage,
                              ),
                            ),
                          )
                        : Container(
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
                          builder: ((builder) => uploadBusinessLogo()),
                        );
                      },
                      splashColor: kAccentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Upload business logo',
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
              kSizedBox,
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Shop Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    kSizedBox,
                    MyBlueTextFormField(
                      controller: shopNameEC,
                      validator: (value) {
                        if (value == null || value!.isEmpty) {
                          shopNameFN.requestFocus();
                          return "Field cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.next,
                      focusNode: shopNameFN,
                      hintText: "Name of shop",
                      textInputType: TextInputType.text,
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
                    GetBuilder<CategoryController>(
                      init: CategoryController(),
                      initState: (state) {
                        CategoryController.instance.getCategory();
                      },
                      builder: (controller) {
                        return MyDropDownMenu(
                          controller: vendorBusinessTypeEC,
                          hintText: vendorBusinessTypeEC.text.isEmpty
                              ? "E.g Restaurant, Auto Dealer, etc"
                              : vendorBusinessTypeEC.text,
                          dropdownMenuEntries:
                              controller.category.value.isEmpty &&
                                      controller.isLoad.value
                                  ? [
                                      const DropdownMenuEntry(
                                        value: 'Loading...',
                                        label: 'Loading...',
                                        enabled: false,
                                      )
                                    ]
                                  : controller.category
                                      .map((item) => DropdownMenuEntry(
                                          value: item.id, label: item.name))
                                      .toList(),
                        );
                      },
                    ),
                    kSizedBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            UppercaseTextInputFormatter(),
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
                            UppercaseTextInputFormatter(),
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
                            UppercaseTextInputFormatter(),
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
                            UppercaseTextInputFormatter(),
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
                            UppercaseTextInputFormatter(),
                          ],
                          textInputAction: TextInputAction.next,
                          focusNode: vendorSunClosingHoursFN,
                          hintText: "00:00 AM",
                          textInputType: TextInputType.text,
                        ),
                        kSizedBox,
                        // account section
                        const Text(
                          'Bank Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        kHalfSizedBox,
                        GetBuilder<WithdrawController>(
                          builder: (controller) {
                            return InkWell(
                              onTap: controller.listOfBanks.isEmpty &&
                                      controller.isLoad.value
                                  ? null
                                  : selectBank,
                              child: MyBlueTextFormField(
                                controller: accountBankEC,
                                isEnabled: false,
                                textInputAction: TextInputAction.next,
                                focusNode: accountBankFN,
                                hintText: controller.listOfBanks.isEmpty &&
                                        controller.isLoad.value
                                    ? "Loading..."
                                    : "Select a bank",
                                suffixIcon: FaIcon(
                                  FontAwesomeIcons.caretDown,
                                  size: 20,
                                  color: kAccentColor,
                                ),
                                textInputType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value!.isEmpty) {
                                    return "Select a bank";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  setState(() {
                                    accountBankEC.text = value!;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        kSizedBox,
                        const Text(
                          'Account Number',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        kHalfSizedBox,
                        MyTextFormField(
                          textCapitalization: TextCapitalization.none,
                          controller: accountNumberEC,
                          focusNode: accountNumberFN,
                          hintText: "Enter the account number here",
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.name,
                          onChanged: (value) {
                            if (value.length >= 10) {
                              WithdrawController.instance.validateBankNumbers(
                                  accountNumberEC.text, bankCode);
                            }
                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null || value!.isEmpty) {
                              accountNumberFN.requestFocus();
                              return "Enter the account number";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            accountNumberEC.text = value!;
                          },
                        ),
                        kSizedBox,
                        GetBuilder<WithdrawController>(
                          builder: (controller) {
                            if (controller.isLoadValidateAccount.value) {
                              return Text(
                                'Loading...',
                                style: TextStyle(
                                  color: kAccentColor.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }
                            if (accountNumberEC.text.length < 10) {
                              return const Text('');
                            }
                            return Text(
                              controller.validateAccount.value.requestSuccessful
                                  ? controller.validateAccount.value
                                      .responseBody.accountName
                                  : 'Bank details not found',
                              style: TextStyle(
                                color: kAccentColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                        kSizedBox,
                        // const Text(
                        //   'Country',
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                        // kSizedBox,
                        // CSCPicker(
                        //   layout: Layout.vertical,
                        //   countryFilter: const [CscCountry.Nigeria],
                        //   countryDropdownLabel: "Select a Country",
                        //   stateDropdownLabel: "Select a State",
                        //   cityDropdownLabel: "Select a City",
                        //   onCountryChanged: (value) {
                        //     setState(() {
                        //       countryValue = value;
                        //     });
                        //   },
                        //   onStateChanged: (value) {
                        //     setState(() {
                        //       stateValue = value ?? "";
                        //     });
                        //   },
                        //   onCityChanged: (value) {
                        //     setState(() {
                        //       cityValue = value ?? "";
                        //     });
                        //   },
                        // ),
                        // kSizedBox,
                        // const Text(
                        //   "Local Government Area",
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                        // kSizedBox,
                        // MyBlueTextFormField(
                        //   controller: vendorLGAEC,
                        //   validator: (value) {
                        //     if (value == null || value!.isEmpty) {
                        //       return "Field cannot be empty";
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        //   onSaved: (value) {},
                        //   textInputAction: TextInputAction.done,
                        //   focusNode: vendorLGAFN,
                        //   hintText: "Enter the LGA",
                        //   textInputType: TextInputType.text,
                        // ),
                        // kSizedBox,
                        // const Text(
                        //   "Address",
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                        // kHalfSizedBox,
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        // const Text(
                        //   'Address',
                        //   style: TextStyle(
                        //     color: kTextBlackColor,
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        // kHalfSizedBox,
                        // MyMapsTextFormField(
                        //   controller: mapsLocationEC,
                        //   validator: (value) {
                        //     if (value == null) {
                        //       addressFN.requestFocus();
                        //       "Enter a location";
                        //     }
                        //     return null;
                        //   },
                        //   onChanged: (value) {
                        //     placeAutoComplete(value);
                        //     setState(() {
                        //       selectedLocation.value = value;
                        //       isTyping = true;
                        //     });
                        //   },
                        //   textInputAction: TextInputAction.done,
                        //   focusNode: addressFN,
                        //   hintText: "Search a location",
                        //   textInputType: TextInputType.text,
                        //   prefixIcon: Padding(
                        //     padding: const EdgeInsets.all(kDefaultPadding),
                        //     child: FaIcon(
                        //       FontAwesomeIcons.locationDot,
                        //       color: kAccentColor,
                        //       size: 18,
                        //     ),
                        //   ),
                        // ),
                        // kSizedBox,
                        // Divider(
                        //   height: 10,
                        //   thickness: 2,
                        //   color: kLightGreyColor,
                        // ),
                        // ElevatedButton.icon(
                        //   onPressed: getLocationOnMap,
                        //   icon: FaIcon(
                        //     FontAwesomeIcons.locationArrow,
                        //     color: kAccentColor,
                        //     size: 18,
                        //   ),
                        //   label: const Text("Locate on map"),
                        //   style: ElevatedButton.styleFrom(
                        //     elevation: 0,
                        //     backgroundColor: kLightGreyColor,
                        //     foregroundColor: kTextBlackColor,
                        //     fixedSize: Size(media.width, 40),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        // ),
                        // Divider(
                        //   height: 10,
                        //   thickness: 2,
                        //   color: kLightGreyColor,
                        // ),
                        // const Text(
                        //   "Suggestions:",
                        //   style: TextStyle(
                        //     color: kTextBlackColor,
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                        // kHalfSizedBox,
                        // SizedBox(
                        //   height: () {
                        //     if (isTyping == false) {
                        //       return 0.0;
                        //     }
                        //     if (isTyping == true) {
                        //       return 150.0;
                        //     }
                        //   }(),
                        //   child: Scrollbar(
                        //     controller: scrollController,
                        //     child: ListView.builder(
                        //       physics: const BouncingScrollPhysics(),
                        //       shrinkWrap: true,
                        //       itemCount: placePredictions.length,
                        //       itemBuilder: (context, index) =>
                        //           LocationListTile(
                        //         onTap: () => setLocation(index),
                        //         location:
                        //             placePredictions[index].description ??
                        //                 '',
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // ],
                        // ),
                        kSizedBox,

                        // business bio
                        const Text(
                          "Business description",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        kSizedBox,
                        MyMessageTextFormField(
                          controller: businessBioEC,
                          validator: (value) {
                            if (value == null || value!.isEmpty) {
                              businessBioFN.requestFocus();
                              return "Field cannot be empty";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {},
                          textInputAction: TextInputAction.go,
                          focusNode: businessBioFN,
                          hintText: "Business description",
                          maxLines: 10,
                          keyboardType: TextInputType.text,
                          maxLength: 1000,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
