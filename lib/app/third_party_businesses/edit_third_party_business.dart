// ignore_for_file: unused_local_variable, use_build_context_synchronously, unused_field, invalid_use_of_protected_member

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/app/google_maps/get_location_on_map.dart';
import 'package:benji_aggregator/app/withdrawal/select_bank.dart';
import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/business_controller.dart';
import 'package:benji_aggregator/controller/category_controller.dart';
import 'package:benji_aggregator/controller/form_controller.dart';
import 'package:benji_aggregator/controller/latlng_detail_controller.dart';
import 'package:benji_aggregator/controller/push_notifications_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/model/business_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/button/my_elevatedButton.dart';
import 'package:benji_aggregator/src/components/image/my_image.dart';
import 'package:benji_aggregator/src/components/input/message_textformfield.dart';
import 'package:benji_aggregator/src/components/input/my_blue_textformfield.dart';
import 'package:benji_aggregator/src/components/input/my_item_drop_down_menu.dart';
import 'package:benji_aggregator/src/googleMaps/autocomplete_prediction.dart';
import 'package:benji_aggregator/src/googleMaps/places_autocomplete_response.dart';
import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:benji_aggregator/src/utils/keys.dart';
import 'package:benji_aggregator/src/utils/network_utils.dart';
import 'package:benji_aggregator/src/utils/web_map.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditThirdPartyBusiness extends StatefulWidget {
  const EditThirdPartyBusiness({super.key, required this.business});
  final BusinessModel business;

  @override
  State<EditThirdPartyBusiness> createState() => _EditThirdPartyBusinessState();
}

class _EditThirdPartyBusinessState extends State<EditThirdPartyBusiness> {
  //==========================================================================================\\
  @override
  void initState() {
    super.initState();
    CategoryController.instance.getCategory();
    scrollController.addListener(_scrollListener);
    mapsLocationEC.text = widget.business.address;
    latitude = widget.business.latitude;
    longitude = widget.business.longitude;
    accountBankEC.text = widget.business.accountBank;
    accountNameEC.text = widget.business.accountName;
    accountNumberEC.text = widget.business.accountNumber;
    accountTypeEC.text = widget.business.accountType;
    countryValue = widget.business.country.name;
    stateValue = widget.business.state;
    cityValue = widget.business.city;
    businessIdEC.text = widget.business.businessId;
    businessLogo = widget.business.shopImage;
    businessCoverImage = widget.business.coverImage;
    shopNameEC.text = widget.business.shopName;
    businessBioEC.text = widget.business.businessBio;
    vendorBusinessTypeEC.text = widget.business.shopType.name;

    sundayOpeningTime = widget.business.sunWeekOpeningHours;
    sundayClosingTime = widget.business.sunWeekClosingHours;
    mondayOpeningTime = widget.business.monOpeningHours;
    mondayClosingTime = widget.business.monClosingHours;
    tuesdayOpeningTime = widget.business.tueOpeningHours;
    tuesdayClosingTime = widget.business.tueClosingHours;
    wednesdayOpeningTime = widget.business.wedOpeningHours;
    wednesdayClosingTime = widget.business.wedClosingHours;
    thursdayOpeningTime = widget.business.thursOpeningHours;
    thursdayClosingTime = widget.business.thursClosingHours;
    fridayOpeningTime = widget.business.friOpeningHours;
    fridayClosingTime = widget.business.friClosingHours;
    saturdayOpeningTime = widget.business.satOpeningHours;
    saturdayClosingTime = widget.business.satClosingHours;
    shopType = widget.business.shopType.id;
    log("This is the shop image: $businessLogo");

    //Set business work hours
    isOpenOnSunday = sundayOpeningTime == "CLOSED" ? false : true;
    isOpenOnMonday = mondayOpeningTime == "CLOSED" ? false : true;
    isOpenOnTuesday = tuesdayOpeningTime == "CLOSED" ? false : true;
    isOpenOnWednesday = wednesdayOpeningTime == "CLOSED" ? false : true;
    isOpenOnThursday = thursdayOpeningTime == "CLOSED" ? false : true;
    isOpenOnFriday = fridayOpeningTime == "CLOSED" ? false : true;
    isOpenOnSaturday = saturdayOpeningTime == "CLOSED" ? false : true;
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
  String sundayOpeningTime = "8:00 AM";
  String sundayClosingTime = "5:00 PM";
  String mondayOpeningTime = "8:00 AM";
  String mondayClosingTime = "5:00 PM";
  String tuesdayOpeningTime = "8:00 AM";
  String tuesdayClosingTime = "5:00 PM";
  String wednesdayOpeningTime = "8:00 AM";
  String wednesdayClosingTime = "5:00 PM";
  String thursdayOpeningTime = "8:00 AM";
  String thursdayClosingTime = "5:00 PM";
  String fridayOpeningTime = "8:00 AM";
  String fridayClosingTime = "5:00 PM";
  String saturdayOpeningTime = "8:00 AM";
  String saturdayClosingTime = "5:00 PM";

  //======================================== GLOBAL KEYS ==============================================\\
  final _formKey = GlobalKey<FormState>();

  //===================== BOOL VALUES =======================\\
  bool isScrollToTopBtnVisible = false;
  late bool isOpenOnSunday;
  late bool isOpenOnMonday;
  late bool isOpenOnTuesday;
  late bool isOpenOnWednesday;
  late bool isOpenOnThursday;
  late bool isOpenOnFriday;
  late bool isOpenOnSaturday;

  //============================================== CONTROLLERS =================================================\\
  final scrollController = ScrollController();
  final shopNameEC = TextEditingController();
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
  XFile? selectedLogoImage;
  XFile? selectedCoverImage;
  //================================== function ====================================\\
  pickLogoImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
    );
    if (image != null) {
      selectedLogoImage = image;
      Get.back();
      setState(() {});
    }
  }

  pickCoverImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
    );
    if (image != null) {
      selectedCoverImage = image;
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
    List location = await parseLatLng(newLocation);
    latitude = location[0];
    longitude = location[1];
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
    if (await checkXFileSize(selectedLogoImage)) {
      ApiProcessorController.errorSnack('Business logo image too large');
      return;
    }
    if (await checkXFileSize(selectedCoverImage)) {
      ApiProcessorController.errorSnack('Business cover image too large');
      return;
    }
    if (selectedCoverImage != null) {
      await FormController.instance.uploadImage2(
        '${Api.baseUrl}/vendors/changeVendorbusinessimages/${widget.business.vendorOwner.id}/${widget.business.id}?type=cover',
        {'image': selectedCoverImage},
        'editBusinessImageCover',
      );
    }
    if (selectedLogoImage != null) {
      await FormController.instance.uploadImage2(
        '${Api.baseUrl}/vendors/changeVendorbusinessimages/${widget.business.vendorOwner.id}/${widget.business.id}?type=shop',
        {'image': selectedLogoImage},
        'editBusinessImageLogo',
      );
    }
    if (shopType == null &&
        vendorBusinessTypeEC.text.isEmpty &&
        shopType!.isEmpty) {
      ApiProcessorController.errorSnack("Please select a type of business");
      return;
    }
    dynamic data = jsonEncode({
      "shop_name": shopNameEC.text,
      "shop_type": shopType,
      "businessBio": businessBioEC.text,
      "monOpeningHours":
          isOpenOnMonday ? mondayOpeningTimeOfDay.format(context) : "CLOSED",
      "monClosingHours":
          isOpenOnMonday ? mondayClosingTimeOfDay.format(context) : "CLOSED",
      "tueOpeningHours":
          isOpenOnTuesday ? tuesdayOpeningTimeOfDay.format(context) : "CLOSED",
      "tueClosingHours":
          isOpenOnTuesday ? tuesdayClosingTimeOfDay.format(context) : "CLOSED",
      "wedOpeningHours": isOpenOnWednesday
          ? "CLOSED"
          : wednesdayOpeningTimeOfDay.format(context),
      "wedClosingHours": isOpenOnWednesday
          ? wednesdayClosingTimeOfDay.format(context)
          : "CLOSED",
      "thursOpeningHours": isOpenOnThursday
          ? thursdayOpeningTimeOfDay.format(context)
          : "CLOSED",
      "thursClosingHours": isOpenOnThursday
          ? thursdayClosingTimeOfDay.format(context)
          : "CLOSED",
      "friOpeningHours":
          isOpenOnFriday ? fridayOpeningTimeOfDay.format(context) : "CLOSED",
      "friClosingHours":
          isOpenOnFriday ? fridayClosingTimeOfDay.format(context) : "CLOSED",
      "satOpeningHours": isOpenOnSaturday
          ? saturdayOpeningTimeOfDay.format(context)
          : "CLOSED",
      "satClosingHours": isOpenOnSaturday
          ? saturdayClosingTimeOfDay.format(context)
          : "CLOSED",
      "sunWeekOpeningHours":
          isOpenOnSunday ? sundayOpeningTimeOfDay.format(context) : "CLOSED",
      "sunWeekClosingHours":
          isOpenOnSunday ? sundayClosingTimeOfDay.format(context) : "CLOSED",
    });

    consoleLog("This is the data: $data");

    consoleLog("shop_image: ${selectedLogoImage?.path}");
    log('${Api.baseUrl}/vendors/changeVendorbusinessprofile/${widget.business.vendorOwner.id}/${widget.business.id}');

    final response = await http.post(
      Uri.parse(
          '${Api.baseUrl}/vendors/changeVendorbusinessprofile/${widget.business.vendorOwner.id}/${widget.business.id}'),
      headers: authHeader(),
      body: data,
    );

    if (response.statusCode.toString().startsWith('2')) {
      await PushNotificationController.showNotification(
        title: "Success.",
        body: "Your business profile has been successfully updated.",
      );
      // reload
      BusinessController.instance.getBusinesses(
          widget.business.vendorOwner.id.toString(),
          UserController.instance.user.value.id);
      Get.close(2);
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
                        Get.close(0);
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
                        Get.close(0);
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
                        Get.close(0);
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
                        Get.close(0);
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

  //Time of Day variables
  //Opening Time
  TimeOfDay sundayOpeningTimeOfDay = const TimeOfDay(hour: 08, minute: 00);
  TimeOfDay mondayOpeningTimeOfDay = const TimeOfDay(hour: 08, minute: 00);
  TimeOfDay tuesdayOpeningTimeOfDay = const TimeOfDay(hour: 08, minute: 00);
  TimeOfDay wednesdayOpeningTimeOfDay = const TimeOfDay(hour: 08, minute: 00);
  TimeOfDay thursdayOpeningTimeOfDay = const TimeOfDay(hour: 08, minute: 00);
  TimeOfDay fridayOpeningTimeOfDay = const TimeOfDay(hour: 08, minute: 00);
  TimeOfDay saturdayOpeningTimeOfDay = const TimeOfDay(hour: 08, minute: 00);

  //Closing time
  TimeOfDay sundayClosingTimeOfDay = const TimeOfDay(hour: 17, minute: 00);
  TimeOfDay mondayClosingTimeOfDay = const TimeOfDay(hour: 17, minute: 00);
  TimeOfDay tuesdayClosingTimeOfDay = const TimeOfDay(hour: 17, minute: 00);
  TimeOfDay wednesdayClosingTimeOfDay = const TimeOfDay(hour: 17, minute: 00);
  TimeOfDay thursdayClosingTimeOfDay = const TimeOfDay(hour: 17, minute: 00);
  TimeOfDay fridayClosingTimeOfDay = const TimeOfDay(hour: 17, minute: 00);
  TimeOfDay saturdayClosingTimeOfDay = const TimeOfDay(hour: 17, minute: 00);

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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        decoration: const ShapeDecoration(
                          shape: CircleBorder(
                            side: BorderSide(
                              width: 0.50,
                              color: kGreyColor1,
                            ),
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          child: ClipOval(
                            child: Center(
                              child: selectedLogoImage == null
                                  ? MyImage(
                                      height: 120,
                                      width: 120,
                                      url: businessLogo,
                                      fit: BoxFit.fill,
                                    )
                                  : kIsWeb
                                      ? Image.network(
                                          selectedLogoImage!.path,
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
                      Container(
                        height: 200,
                        width: media.width - 100,
                        padding: const EdgeInsets.all(20),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 0.50,
                              color: Color(0xFFE6E6E6),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: selectedCoverImage == null
                              ? MyImage(
                                  height: 120,
                                  width: 120,
                                  url: businessCoverImage,
                                  fit: BoxFit.fill,
                                )
                              : kIsWeb
                                  ? Image.network(
                                      selectedCoverImage!.path,
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
              ),
              kSizedBox,
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Business Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    kSizedBox,
                    MyBlueTextFormField(
                      controller: shopNameEC,
                      validator: (value) {
                        if (value == null || value == '') {
                          shopNameFN.requestFocus();
                          return "Field cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.next,
                      focusNode: shopNameFN,
                      hintText: "Name of business",
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
                        return ItemDropDownMenu(
                          onSelected: (value) {
                            setState(() {
                              shopType = value;
                            });
                          },
                          itemEC: vendorBusinessTypeEC,
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

                        const Text(
                          "Sunday",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              isOpenOnSunday
                                  ? "Open".toUpperCase()
                                  : "Closed".toUpperCase(),
                              style: const TextStyle(
                                color: kTextBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            kHalfWidthSizedBox,
                            Switch(
                              value: isOpenOnSunday,
                              activeColor: kSuccessColor,
                              onChanged: (value) {
                                setState(() {
                                  isOpenOnSunday = !isOpenOnSunday;
                                });
                              },
                            ),
                          ],
                        ),
                        isOpenOnSunday ? kHalfSizedBox : const SizedBox(),
                        isOpenOnSunday
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sundayOpeningTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 08,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                sundayOpeningTimeOfDay = value;
                                              });
                                              sundayOpeningTime =
                                                  sundayOpeningTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  kHalfWidthSizedBox,
                                  const Text(
                                    "to",
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  kHalfWidthSizedBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sundayClosingTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 17,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                sundayClosingTimeOfDay = value;
                                              });
                                              sundayClosingTime =
                                                  sundayClosingTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(),

                        const Text(
                          "Monday",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              isOpenOnMonday
                                  ? "Open".toUpperCase()
                                  : "Closed".toUpperCase(),
                              style: const TextStyle(
                                color: kTextBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            kHalfWidthSizedBox,
                            Switch(
                              value: isOpenOnMonday,
                              activeColor: kSuccessColor,
                              onChanged: (value) {
                                setState(() {
                                  isOpenOnMonday = !isOpenOnMonday;
                                });
                              },
                            ),
                          ],
                        ),
                        isOpenOnMonday ? kHalfSizedBox : const SizedBox(),
                        isOpenOnMonday
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mondayOpeningTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 08,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                mondayOpeningTimeOfDay = value;
                                              });
                                              mondayOpeningTime =
                                                  mondayOpeningTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  kHalfWidthSizedBox,
                                  const Text(
                                    "to",
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  kHalfWidthSizedBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mondayClosingTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 17,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                mondayClosingTimeOfDay = value;
                                              });
                                              mondayClosingTime =
                                                  mondayClosingTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const Text(
                          "Tuesday",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              isOpenOnTuesday
                                  ? "Open".toUpperCase()
                                  : "Closed".toUpperCase(),
                              style: const TextStyle(
                                color: kTextBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            kHalfWidthSizedBox,
                            Switch(
                              value: isOpenOnTuesday,
                              activeColor: kSuccessColor,
                              onChanged: (value) {
                                setState(() {
                                  isOpenOnTuesday = !isOpenOnTuesday;
                                });
                              },
                            ),
                          ],
                        ),
                        isOpenOnTuesday ? kHalfSizedBox : const SizedBox(),
                        isOpenOnTuesday
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tuesdayOpeningTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 08,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                tuesdayOpeningTimeOfDay = value;
                                              });
                                              tuesdayOpeningTime =
                                                  tuesdayOpeningTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  kHalfWidthSizedBox,
                                  const Text(
                                    "to",
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  kHalfWidthSizedBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tuesdayClosingTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 17,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                tuesdayClosingTimeOfDay = value;
                                              });
                                              tuesdayClosingTime =
                                                  tuesdayClosingTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const Text(
                          "Wednesday",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              isOpenOnWednesday
                                  ? "Open".toUpperCase()
                                  : "Closed".toUpperCase(),
                              style: const TextStyle(
                                color: kTextBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            kHalfWidthSizedBox,
                            Switch(
                              value: isOpenOnWednesday,
                              activeColor: kSuccessColor,
                              onChanged: (value) {
                                setState(() {
                                  isOpenOnWednesday = !isOpenOnWednesday;
                                });
                              },
                            ),
                          ],
                        ),
                        isOpenOnWednesday ? kHalfSizedBox : const SizedBox(),
                        isOpenOnWednesday
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        wednesdayOpeningTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 08,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                wednesdayOpeningTimeOfDay =
                                                    value;
                                              });
                                              wednesdayOpeningTime =
                                                  wednesdayOpeningTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  kHalfWidthSizedBox,
                                  const Text(
                                    "to",
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  kHalfWidthSizedBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        wednesdayClosingTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 17,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                wednesdayClosingTimeOfDay =
                                                    value;
                                              });
                                              wednesdayClosingTime =
                                                  wednesdayClosingTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const Text(
                          "Thursday",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              isOpenOnThursday
                                  ? "Open".toUpperCase()
                                  : "Closed".toUpperCase(),
                              style: const TextStyle(
                                color: kTextBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            kHalfWidthSizedBox,
                            Switch(
                              value: isOpenOnThursday,
                              activeColor: kSuccessColor,
                              onChanged: (value) {
                                setState(() {
                                  isOpenOnThursday = !isOpenOnThursday;
                                });
                              },
                            ),
                          ],
                        ),
                        isOpenOnThursday ? kHalfSizedBox : const SizedBox(),
                        isOpenOnThursday
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        thursdayOpeningTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 08,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                thursdayOpeningTimeOfDay =
                                                    value;
                                              });
                                              thursdayOpeningTime =
                                                  thursdayOpeningTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  kHalfWidthSizedBox,
                                  const Text(
                                    "to",
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  kHalfWidthSizedBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        thursdayClosingTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 17,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                thursdayClosingTimeOfDay =
                                                    value;
                                              });
                                              thursdayClosingTime =
                                                  thursdayClosingTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const Text(
                          "Friday",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              isOpenOnFriday
                                  ? "Open".toUpperCase()
                                  : "Closed".toUpperCase(),
                              style: const TextStyle(
                                color: kTextBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            kHalfWidthSizedBox,
                            Switch(
                              value: isOpenOnFriday,
                              activeColor: kSuccessColor,
                              onChanged: (value) {
                                setState(() {
                                  isOpenOnFriday = !isOpenOnFriday;
                                });
                              },
                            ),
                          ],
                        ),
                        isOpenOnFriday ? kHalfSizedBox : const SizedBox(),
                        isOpenOnFriday
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fridayOpeningTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 08,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                fridayOpeningTimeOfDay = value;
                                              });
                                              fridayOpeningTime =
                                                  fridayOpeningTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  kHalfWidthSizedBox,
                                  const Text(
                                    "to",
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  kHalfWidthSizedBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fridayClosingTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 17,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                fridayClosingTimeOfDay = value;
                                              });
                                              fridayClosingTime =
                                                  fridayClosingTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const Text(
                          "Saturday",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              isOpenOnSaturday
                                  ? "Open".toUpperCase()
                                  : "Closed".toUpperCase(),
                              style: const TextStyle(
                                color: kTextBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            kHalfWidthSizedBox,
                            Switch(
                              value: isOpenOnSaturday,
                              activeColor: kSuccessColor,
                              onChanged: (value) {
                                setState(() {
                                  isOpenOnSaturday = !isOpenOnSaturday;
                                });
                              },
                            ),
                          ],
                        ),
                        isOpenOnSaturday ? kHalfSizedBox : const SizedBox(),
                        isOpenOnSaturday
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        saturdayOpeningTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 08,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                saturdayOpeningTimeOfDay =
                                                    value;
                                              });
                                              saturdayOpeningTime =
                                                  saturdayOpeningTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  kHalfWidthSizedBox,
                                  const Text(
                                    "to",
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  kHalfWidthSizedBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        saturdayClosingTime,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                              hour: 17,
                                              minute: 00,
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                saturdayClosingTimeOfDay =
                                                    value;
                                              });
                                              saturdayClosingTime =
                                                  saturdayClosingTimeOfDay
                                                      .format(context);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(),

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
                            if (value == null || value == '') {
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
