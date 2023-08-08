// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'dart:io';

import 'package:benji_aggregator/src/common_widgets/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../src/common_widgets/message_textformfield.dart';
import '../../../src/common_widgets/my_blue_textformfield.dart';
import '../../../src/common_widgets/my_elevatedButton.dart';
import '../../../src/common_widgets/my_fixed_snackBar.dart';
import '../../../src/common_widgets/my_intl_phonefield.dart';
import '../../../src/providers/constants.dart';
import '../../../src/skeletons/vendors_list_skeleton.dart';

class AddThirdPartyVendor extends StatefulWidget {
  const AddThirdPartyVendor({super.key});

  @override
  State<AddThirdPartyVendor> createState() => _AddThirdPartyVendorState();
}

class _AddThirdPartyVendorState extends State<AddThirdPartyVendor> {
  //=================================== ALL VARIABLES ====================================\\

  //======================================== GLOBAL KEYS ==============================================\\
  final _formKey = GlobalKey<FormState>();
  final _cscPickerKey = GlobalKey<CSCPickerState>();

  //===================== BOOL VALUES =======================\\
  late bool _loadingScreen;
  bool isLoading = false;

  //=================================== CONTROLLERS ====================================\\
  final ScrollController _scrollController = ScrollController();
  TextEditingController vendorNameEC = TextEditingController();
  TextEditingController vendorEmailEC = TextEditingController();
  TextEditingController vendorPhoneNumberEC = TextEditingController();
  TextEditingController vendorAddressEC = TextEditingController();
  TextEditingController vendorBusinessTypeEC = TextEditingController();
  TextEditingController vendorBusinessBioEC = TextEditingController();
  TextEditingController vendorMonToFriOpeningHoursEC = TextEditingController();
  TextEditingController vendorSatOpeningHoursEC = TextEditingController();
  TextEditingController vendorSunOpeningHoursEC = TextEditingController();
  TextEditingController vendorMonToFriClosingHoursEC = TextEditingController();
  TextEditingController vendorSatClosingHoursEC = TextEditingController();
  TextEditingController vendorSunClosingHoursEC = TextEditingController();

  //=================================== FOCUS NODES ====================================\\
  FocusNode vendorNameFN = FocusNode();
  FocusNode vendorEmailFN = FocusNode();
  FocusNode vendorPhoneNumberFN = FocusNode();
  FocusNode vendorAddressFN = FocusNode();
  FocusNode vendorBusinessTypeFN = FocusNode();
  FocusNode vendorBusinessBioFN = FocusNode();
  FocusNode vendorMonToFriOpeningHoursFN = FocusNode();
  FocusNode vendorSatOpeningHoursFN = FocusNode();
  FocusNode vendorSunOpeningHoursFN = FocusNode();
  FocusNode vendorMonToFriClosingHoursFN = FocusNode();
  FocusNode vendorSatClosingHoursFN = FocusNode();
  FocusNode vendorSunClosingHoursFN = FocusNode();

//==========================================================================================\\
  @override
  void initState() {
    _loadingScreen = true;
    Future.delayed(
      const Duration(seconds: 2),
      () => setState(
        () => _loadingScreen = false,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
//==========================================================================================\\

  //============================================= FUNCTIONS ===============================================\\

//=========================== IMAGE PICKER ====================================\\

  final ImagePicker _picker = ImagePicker();
  File? selectedCoverImage;
  File? selectedLogoImage;

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
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    // Simulating a delay of 3 seconds
    await Future.delayed(const Duration(seconds: 2));

    //Display snackBar
    myFixedSnackBar(
      context,
      "Your changes have been saved successfully".toUpperCase(),
      kAccentColor,
      const Duration(seconds: 2),
    );

    Future.delayed(
        const Duration(
          seconds: 2,
        ), () {
      // Navigate to the new page
      Navigator.of(context).pop(context);
    });

    setState(() {
      isLoading = false;
    });
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Upload Cover Image",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: Icon(
                    Icons.delete_rounded,
                    color: kAccentColor,
                  ),
                ),
              ],
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
                            side: const BorderSide(
                              width: 0.5,
                              color: kGreyColor1,
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: kAccentColor,
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
                        child: Icon(
                          Icons.image,
                          color: kAccentColor,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Upload Logo Image",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: Icon(
                    Icons.delete_rounded,
                    color: kAccentColor,
                  ),
                ),
              ],
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
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: kAccentColor,
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
                        child: Icon(
                          Icons.image,
                          color: kAccentColor,
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
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: "Add third party vendor",
          elevation: 0.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        bottomNavigationBar: isLoading
            ? Center(
                child: SpinKitDoubleBounce(
                  color: kAccentColor,
                ),
              )
            : Container(
                color: kPrimaryColor,
                padding: const EdgeInsets.only(
                  top: kDefaultPadding,
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  bottom: kDefaultPadding,
                ),
                child: MyElevatedButton(
                  onPressed: (() async {
                    if (_formKey.currentState!.validate()) {
                      loadData();
                    }
                  }),
                  buttonTitle: "Save",
                  circularBorderRadius: 16,
                  minimumSizeWidth: 60,
                  minimumSizeHeight: 60,
                  maximumSizeWidth: 60,
                  maximumSizeHeight: 60,
                  titleFontSize: 16,
                  elevation: 10.0,
                ),
              ),
        body: SafeArea(
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const VendorsListSkeleton();
              }
              if (snapshot.connectionState == ConnectionState.none) {
                const Center(
                  child: Text("Please connect to the internet"),
                );
              }
              // if (snapshot.connectionState == snapshot.requireData) {
              //   SpinKitDoubleBounce(color: kAccentColor);
              // }
              if (snapshot.connectionState == snapshot.error) {
                const Center(
                  child: Text("Error, Please try again later"),
                );
              }
              return _loadingScreen
                  ? Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: Center(
                        child: SpinKitDoubleBounce(color: kAccentColor),
                      ),
                    )
                  : Scrollbar(
                      controller: _scrollController,
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView(
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
                            color: kGreyColor1,
                            borderPadding: const EdgeInsets.all(3),
                            padding: const EdgeInsets.all(kDefaultPadding / 2),
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(20),
                            child: Column(
                              children: [
                                InkWell(
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
                                          top: Radius.circular(kDefaultPadding),
                                        ),
                                      ),
                                      enableDrag: true,
                                      builder: ((builder) =>
                                          uploadCoverImage()),
                                    );
                                  },
                                  splashColor: kAccentColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  child: selectedCoverImage == null
                                      ? Container(
                                          width: mediaWidth,
                                          height: 144,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                width: 0.50,
                                                color: Color(0xFFE6E6E6),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/images/icons/image-upload.png"),
                                                kHalfSizedBox,
                                                Text(
                                                  'Upload cover image',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: kTextGreyColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: mediaWidth,
                                          height: 144,
                                          decoration: ShapeDecoration(
                                            image: DecorationImage(
                                              image: FileImage(
                                                  selectedCoverImage!),
                                              fit: BoxFit.cover,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                width: 0.50,
                                                color: Color(0xFFE6E6E6),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                ),
                                kSizedBox,
                                selectedLogoImage == null
                                    ? InkWell(
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
                                                    kDefaultPadding),
                                              ),
                                            ),
                                            enableDrag: true,
                                            builder: ((builder) =>
                                                uploadLogoImage()),
                                          );
                                        },
                                        splashColor:
                                            kAccentColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 144,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                width: 0.50,
                                                color: Color(0xFFE6E6E6),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      kTransparentColor,
                                                  minRadius: 40,
                                                  maxRadius: 50,
                                                  child: Icon(
                                                    Icons.image,
                                                    color: kAccentColor,
                                                  ),
                                                ),
                                                kHalfSizedBox,
                                                Text(
                                                  'Upload your profile logo',
                                                  style: TextStyle(
                                                    color: kTextGreyColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Container(
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
                                        ],
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
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  focusNode: vendorNameFN,
                                  hintText: "Enter the name of your business",
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
                                MyBlueTextFormField(
                                  controller: vendorBusinessTypeEC,
                                  validator: (value) {
                                    return null;
                                  },
                                  onSaved: (value) {},
                                  textInputAction: TextInputAction.next,
                                  focusNode: vendorBusinessTypeFN,
                                  hintText: "E.g Restaurant, Auto Dealer, etc",
                                  textInputType: TextInputType.name,
                                ),
                                kSizedBox,
                                const Text(
                                  "Business Email",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                kSizedBox,
                                MyBlueTextFormField(
                                  controller: vendorEmailEC,
                                  validator: (value) {
                                    return null;
                                  },
                                  onSaved: (value) {},
                                  textInputAction: TextInputAction.next,
                                  focusNode: vendorEmailFN,
                                  hintText: "Enter your bussiness email",
                                  textInputType: TextInputType.emailAddress,
                                ),
                                kSizedBox,
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
                                  validator: (value) {},
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
                                MyBlueTextFormField(
                                  controller: vendorEmailEC,
                                  validator: (value) {
                                    return null;
                                  },
                                  onSaved: (value) {},
                                  textInputAction: TextInputAction.next,
                                  focusNode: vendorEmailFN,
                                  hintText: "Enter your business address",
                                  textInputType: TextInputType.emailAddress,
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
                                  countryDropdownLabel: "Select country",
                                  stateDropdownLabel: "Select state",
                                  cityDropdownLabel: "Select city",
                                  onCountryChanged: (country) {
                                    country = country;
                                  },
                                  onStateChanged: (state) {
                                    state = state;
                                  },
                                  onCityChanged: (city) {
                                    city = city;
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
                                    return null;
                                  },
                                  onSaved: (value) {},
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
                                    return null;
                                  },
                                  onSaved: (value) {},
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
                                    return null;
                                  },
                                  onSaved: (value) {},
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
                                    return null;
                                  },
                                  onSaved: (value) {},
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
                                    return null;
                                  },
                                  onSaved: (value) {},
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
                                    return null;
                                  },
                                  onSaved: (value) {},
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
                                  hintText:
                                      "Tell us a little about your business...",
                                  maxLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  validator: (value) {
                                    // if (value == null || value!.isEmpty) {
                                    //   vendorBusinessBioFN.requestFocus();
                                    //   return "Enter your Business bio";
                                    // }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    vendorBusinessBioEC.text = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
