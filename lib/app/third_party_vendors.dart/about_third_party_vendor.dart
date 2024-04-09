import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controller/user_controller.dart';
import '../../model/third_party_vendor_model.dart';
import '../../src/components/image/my_image.dart';
import '../../src/components/input/my_blue_textformfield.dart';
import '../../src/components/section/my_liquid_refresh.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../src/utils/constants.dart';

class AboutThirdPartyVendor extends StatefulWidget {
  final ThirdPartyVendorModel vendor;
  const AboutThirdPartyVendor({
    super.key,
    required this.vendor,
  });

  @override
  State<AboutThirdPartyVendor> createState() => _AboutThirdPartyVendorState();
}

class _AboutThirdPartyVendorState extends State<AboutThirdPartyVendor> {
  @override
  void initState() {
    super.initState();
    vendorFirstNameEC.text = widget.vendor.firstName;
    vendorLastNameEC.text = widget.vendor.lastName;
    vendorEmailEC.text = widget.vendor.email;
    vendorAddressEC.text = widget.vendor.address;
    vendorCountryEC.text = widget.vendor.country.name;
    vendorStateEC.text = widget.vendor.state;
    vendorCityEC.text = widget.vendor.city;
    vendorLGAEC.text = widget.vendor.lga;
    vendorIDEC.text = widget.vendor.id.toString();

    scrollController.addListener(_scrollListener);
  }

  //=================================== CONTROLLERS ====================================\\
  final scrollController = ScrollController();

  final vendorFirstNameEC = TextEditingController();
  final vendorLastNameEC = TextEditingController();
  final vendorEmailEC = TextEditingController();
  final vendorAddressEC = TextEditingController();
  final vendorCountryEC = TextEditingController();
  final vendorStateEC = TextEditingController();
  final vendorCityEC = TextEditingController();
  final vendorLGAEC = TextEditingController();
  final vendorIDEC = TextEditingController();

  //=================================== FOCUS NODES ====================================\\
  final vendorFirstNameFN = FocusNode();
  final vendorLastNameFN = FocusNode();
  final vendorEmailFN = FocusNode();
  final vendorAddressFN = FocusNode();
  final vendorCountryFN = FocusNode();
  final vendorStateFN = FocusNode();
  final vendorCityFN = FocusNode();
  final vendorLGAFN = FocusNode();
  final vendorIDFN = FocusNode();

//============================================= ALL VARIABLES  ===================================================\\
  bool isScrollToTopBtnVisible = false;
  bool refreshing = false;

//============================================= FUNCTIONS  ===================================================\\

  Future<void> handleRefresh() async {
    setState(() {
      refreshing = true;
    });
    await UserController.instance.getUser();
    setState(() {
      refreshing = false;
    });
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
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
    return MyLiquidRefresh(
      onRefresh: handleRefresh,
      child: Scaffold(
        appBar: MyAppBar(
          title: "About Vendor",
          elevation: 0,
          backgroundColor: kPrimaryColor,
          actions: const [],
        ),
        floatingActionButton: isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: scrollToTop,
                mini: true,
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
        body: Scrollbar(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(kDefaultPadding),
            controller: scrollController,
            children: [
              SizedBox(
                height:
                    deviceType(media.width) > 2 && deviceType(media.width) < 4
                        ? 540
                        : deviceType(media.width) > 2
                            ? 470
                            : 320,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: deviceType(media.width) > 3 &&
                                deviceType(media.width) < 5
                            ? media.height * 0.3
                            : deviceType(media.width) > 2
                                ? media.height * 0.2
                                : media.height * 0.15,
                        decoration:
                            const BoxDecoration(color: kTransparentColor),
                        child: Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: Opacity(
                            opacity: 0.6,
                            child: Image.asset(
                              "assets/images/logo/benji_full_logo.png",
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: deviceType(media.width) > 2
                          ? media.height * 0.25
                          : media.height * 0.1,
                      left: kDefaultPadding,
                      right: kDefaultPadding,
                      child: Container(
                        // width: 200,
                        padding: const EdgeInsets.all(kDefaultPadding / 2),
                        decoration: ShapeDecoration(
                          shadows: [
                            BoxShadow(
                              color: kBlackColor.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 2,
                              blurStyle: BlurStyle.normal,
                            ),
                          ],
                          color: const Color(0xFFFEF8F8),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 0.50,
                              color: Color(0xFFFDEDED),
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: kDefaultPadding * 2.6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: media.width - 150,
                                child: Text(
                                  "${widget.vendor.firstName} ${widget.vendor.lastName}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              kHalfSizedBox,
                              SizedBox(
                                width: media.width - 150,
                                child: Text(
                                  "ID: ${widget.vendor.code}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              kHalfSizedBox,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: media.width - 250,
                                    padding:
                                        const EdgeInsets.all(kDefaultPadding),
                                    decoration: ShapeDecoration(
                                      color: kPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(19),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Online",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: kSuccessColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -0.36,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        FaIcon(
                                          Icons.info,
                                          color: kAccentColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: deviceType(media.width) > 3 &&
                              deviceType(media.width) < 5
                          ? media.height * 0.15
                          : deviceType(media.width) > 2
                              ? media.height * 0.15
                              : media.height * 0.04,
                      left: deviceType(media.width) > 2
                          ? (media.width / 2) - (126 / 2)
                          : (media.width / 2) - (100 / 2),
                      child: Container(
                        width: deviceType(media.width) > 2 ? 126 : 100,
                        height: deviceType(media.width) > 2 ? 126 : 100,
                        decoration: ShapeDecoration(
                          color: kPageSkeletonColor,
                          shape: const OvalBorder(),
                        ),
                        child: MyImage(url: widget.vendor.profileLogo),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                "First Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              kSizedBox,
              MyBlueTextFormField(
                isEnabled: false,
                controller: vendorFirstNameEC,
                validator: (value) {
                  return null;
                },
                onSaved: (value) {},
                textInputAction: TextInputAction.done,
                focusNode: vendorFirstNameFN,
                hintText: "",
                textInputType: TextInputType.text,
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
                isEnabled: false,
                controller: vendorLastNameEC,
                validator: (value) {
                  return null;
                },
                onSaved: (value) {},
                textInputAction: TextInputAction.done,
                focusNode: vendorLastNameFN,
                hintText: "",
                textInputType: TextInputType.text,
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
                isEnabled: false,
                readOnly: true,
                controller: vendorEmailEC,
                validator: (value) {
                  return null;
                },
                onSaved: (value) {},
                textInputAction: TextInputAction.done,
                focusNode: vendorEmailFN,
                hintText: "",
                textInputType: TextInputType.text,
              ),
              kSizedBox,
              const Text(
                "Address",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              kSizedBox,
              MyBlueTextFormField(
                isEnabled: false,
                readOnly: true,
                controller: vendorAddressEC,
                validator: (value) {
                  return null;
                },
                onSaved: (value) {},
                textInputAction: TextInputAction.done,
                focusNode: vendorAddressFN,
                hintText: "",
                textInputType: TextInputType.text,
              ),
              kSizedBox,
              // const Text(
              //   "Country",
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w700,
              //   ),
              // ),
              // kSizedBox,
              // MyBlueTextFormField(
              //   isEnabled: false,
              //   readOnly: true,
              //   controller: vendorCountryEC,
              //   validator: (value) {
              //     return null;
              //   },
              //   onSaved: (value) {},
              //   textInputAction: TextInputAction.done,
              //   focusNode: vendorCountryFN,
              //   hintText: "",
              //   textInputType: TextInputType.text,
              // ),
              // kSizedBox,
              // const Text(
              //   "State",
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w700,
              //   ),
              // ),
              // kSizedBox,
              // MyBlueTextFormField(
              //   isEnabled: false,
              //   readOnly: true,
              //   controller: vendorStateEC,
              //   validator: (value) {
              //     return null;
              //   },
              //   onSaved: (value) {},
              //   textInputAction: TextInputAction.done,
              //   focusNode: vendorStateFN,
              //   hintText: "",
              //   textInputType: TextInputType.text,
              // ),
              // kSizedBox,
              // const Text(
              //   "LGA",
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w700,
              //   ),
              // ),
              // kSizedBox,
              // MyBlueTextFormField(
              //   isEnabled: false,
              //   readOnly: true,
              //   controller: vendorLGAEC,
              //   validator: (value) {
              //     return null;
              //   },
              //   onSaved: (value) {},
              //   textInputAction: TextInputAction.done,
              //   focusNode: vendorLGAFN,
              //   hintText: "",
              //   textInputType: TextInputType.text,
              // ),
              // kSizedBox,
              // const Text(
              //   "City",
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w700,
              //   ),
              // ),
              // kSizedBox,
              // MyBlueTextFormField(
              //   isEnabled: false,
              //   readOnly: true,
              //   controller: vendorCityEC,
              //   validator: (value) {
              //     return null;
              //   },
              //   onSaved: (value) {},
              //   textInputAction: TextInputAction.done,
              //   focusNode: vendorCityFN,
              //   hintText: "",
              //   textInputType: TextInputType.text,
              // ),
              kSizedBox,
            ],
          ),
        ),
      ),
    );
  }
}
