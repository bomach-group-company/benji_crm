// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';
import '../responsive/responsive_constant.dart';
import 'my_elevatedButton.dart';
import 'my_floating_snackbar.dart';
import 'my_intl_phonefield.dart';
import 'name_textformfield.dart';

class PersonalInfoBody extends StatefulWidget {
  const PersonalInfoBody({Key? key}) : super(key: key);

  @override
  State<PersonalInfoBody> createState() => _PersonalInfoBodyState();
}

class _PersonalInfoBodyState extends State<PersonalInfoBody> {
  @override
  void initState() {
    userID = "NG233-434";
    super.initState();
  }

//======================================== ALL VARIABLES ==============================================\\
  final String countryDialCode = '234';

  //=========================== BOOL VALUES ====================================\\
  bool _isLoading = false;

  //======================================== GLOBAL KEYS ==============================================\\
  final _formKey = GlobalKey<FormState>();

  //=========================== CONTROLLERS ====================================\\
  final _scrollController = ScrollController();

  final TextEditingController _userFirstNameEC = TextEditingController();
  final TextEditingController _userLastNameEC = TextEditingController();
  TextEditingController phoneNumberEC = TextEditingController();

  //=========================== FOCUS NODES ====================================\\
  FocusNode userFirstNameFN = FocusNode();
  FocusNode userLastNameFN = FocusNode();
  FocusNode phoneNumberFN = FocusNode();

  //=========================== IMAGE PICKER ====================================\\

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  //=========================== WIDGETS ====================================\\
  Widget _profilePicBottomSheet() {
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
      selectedImage = File(image.path);
      setState(() {});
      // User? user = await getUser();
      // final url =
      //     Uri.parse('$baseURL/clients/changeClientProfileImage/${user!.id}');

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

  Future<bool> updateProfile({bool isCurrent = true}) async {
    return false;
  }

  Future<void> updateData() async {
    setState(() {
      _isLoading = true;
    });

    bool res = await updateProfile();

    if (res) {
      //Display snackBar
      mySnackBar(
        context,
        kSuccessColor,
        "Success!",
        "Your changes have been saved successfully".toUpperCase(),
        const Duration(seconds: 2),
      );

      Get.back();
    } else {
      mySnackBar(
        context,
        kAccentColor,
        "Failed!",
        "Something unexpected happened, please try again later".toUpperCase(),
        const Duration(seconds: 2),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  //===================== COPY TO CLIPBOARD =======================\\
  String? userID;

  void _copyToClipboard(BuildContext context, String userID) {
    Clipboard.setData(
      ClipboardData(text: userID),
    );

    //===================== SNACK BAR =======================\\

    mySnackBar(
      context,
      kSuccessColor,
      "Success!",
      "ID copied to clipboard",
      const Duration(
        seconds: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scrollbar(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(10),
          physics: const BouncingScrollPhysics(),
          children: [
            GetBuilder<UserController>(
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
                              selectedImage == null
                                  ? Container(
                                      height: deviceType(media.width) == 1
                                          ? 100
                                          : 150,
                                      width: deviceType(media.width) == 1
                                          ? 100
                                          : 150,
                                      decoration: ShapeDecoration(
                                        color: kPageSkeletonColor,
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            "assets/images/profile/avatar-image.jpg",
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                        shape: const OvalBorder(),
                                      ),
                                    )
                                  : Container(
                                      height: deviceType(media.width) == 1
                                          ? 100
                                          : 150,
                                      width: deviceType(media.width) == 1
                                          ? 100
                                          : 150,
                                      decoration: ShapeDecoration(
                                        color: kPageSkeletonColor,
                                        image: DecorationImage(
                                          image: FileImage(selectedImage!),
                                          fit: BoxFit.cover,
                                        ),
                                        shape: const OvalBorder(),
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
                                          _profilePicBottomSheet(),
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
                              controller.user.value.username ?? "Loading...",
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
                              controller.user.value.email ?? "Loading...",
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
                                    userID!,
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
                                    _copyToClipboard(context, userID!);
                                  },
                                  tooltip: "Copy ID",
                                  mouseCursor: SystemMouseCursors.click,
                                  icon: FaIcon(
                                    FontAwesomeIcons.copy,
                                    size: 14,
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
              child: Column(
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
                    controller: _userFirstNameEC,
                    validator: (value) {
                      RegExp userNamePattern = RegExp(
                        r'^.{3,}$', //Min. of 3 characters
                      );
                      if (value == null || value!.isEmpty) {
                        userFirstNameFN.requestFocus();
                        return "Enter your first name";
                      } else if (!userNamePattern.hasMatch(value)) {
                        userFirstNameFN.requestFocus();
                        return "Name must be at least 3 characters";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userFirstNameEC.text = value;
                    },
                    textInputAction: TextInputAction.next,
                    nameFocusNode: userFirstNameFN,
                    hintText: "Enter first name",
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
                    controller: _userLastNameEC,
                    hintText: "Enter last name",
                    validator: (value) {
                      RegExp userNamePattern = RegExp(
                        r'^.{3,}$', //Min. of 3 characters
                      );
                      if (value == null || value!.isEmpty) {
                        userLastNameFN.requestFocus();
                        return "Enter your last name";
                      } else if (!userNamePattern.hasMatch(value)) {
                        userLastNameFN.requestFocus();
                        return "Name must be at least 3 characters";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userLastNameEC.text = value;
                    },
                    textInputAction: TextInputAction.next,
                    nameFocusNode: userLastNameFN,
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
                    initialCountryCode: "NG",
                    invalidNumberMessage: "Invalid phone number",
                    dropdownIconPosition: IconPosition.trailing,
                    showCountryFlag: true,
                    showDropdownIcon: true,
                    dropdownIcon: Icon(
                      Icons.arrow_drop_down_rounded,
                      color: kAccentColor,
                    ),
                    controller: phoneNumberEC,
                    textInputAction: TextInputAction.next,
                    focusNode: phoneNumberFN,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        phoneNumberFN.requestFocus();
                        return "Enter your phone number";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phoneNumberEC.text = value;
                    },
                  ),
                  kSizedBox,
                ],
              ),
            ),
            kSizedBox,
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: kAccentColor,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: MyElevatedButton(
                      onPressed: (() async {
                        if (_formKey.currentState!.validate()) {
                          updateData();
                        }
                      }),
                      title: "Save",
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
