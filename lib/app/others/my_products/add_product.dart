// ignore_for_file: unused_local_variable

import 'dart:io';

<<<<<<< HEAD:lib/app/others/my_products/add_product.dart
=======
import 'package:benji_aggregator/src/common_widgets/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:dotted_border/dotted_border.dart';
>>>>>>> main:lib/app/others/add_vendor.dart
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../src/providers/constants.dart';

import '../../../src/common_widgets/my_appbar.dart';
import '../../../theme/colors.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

<<<<<<< HEAD:lib/app/others/my_products/add_product.dart
class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Add New Product",
        elevation: 0.0,
        actions: const [],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
=======
class _AddVendorState extends State<AddVendor> {
  //=================================== ALL VARIABLES ====================================\\

  //===================== BOOL VALUES =======================\\
  late bool _loadingScreen;

  //=================================== CONTROLLERS ====================================\\
  final ScrollController _scrollController = ScrollController();

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

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _loadingScreen = false;
    });
  }

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
    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: kAccentColor,
      borderWidth: 5.0,
      backgroundColor: kPrimaryColor,
      height: 150,
      animSpeedFactor: 2,
      showChildOpacityTransition: false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: "Add New Vendor",
          elevation: 0.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        body: SafeArea(
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                SpinKitDoubleBounce(color: kAccentColor);
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
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
                          )
                        ],
                      ),
                    );
            },
          ),
        ),
>>>>>>> main:lib/app/others/add_vendor.dart
      ),
    );
  }
}
