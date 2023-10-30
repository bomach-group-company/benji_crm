import 'package:benji_aggregator/app/my_vendors/add_third_party_vendor.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../src/providers/constants.dart';
import '../vendors/register_vendor.dart';

class AddVendor extends StatefulWidget {
  const AddVendor({super.key});

  @override
  State<AddVendor> createState() => _AddVendorState();
}

class _AddVendorState extends State<AddVendor> {
  //============================================ INITIAL STATE =================================================\\
  @override
  void initState() {
    super.initState();
    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  //============================================ DISPOSE =================================================\\

  @override
  void dispose() {
    super.dispose();
  }

  //============================================ CONTROLLERS =================================================\\
  final ScrollController scrollController = ScrollController();

  //============================================ ALL VARIABLES =================================================\\
  late bool _loadingScreen;

  //============================================ FUNCTIONS =================================================\\

//============================================== Navigation ================================================\\
  void _toRegisterVendorPage() => Get.to(
        () => const RegisterVendor(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "RegisterVendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toAddThirdPartyVendor() => Get.to(
        () => const AddThirdPartyVendor(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "AddThirdPartyVendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(
        title: "Add a new vendor",
        elevation: 0.0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: FutureBuilder(
            future: null,
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
                  ? Center(
                      child: CircularProgressIndicator(color: kAccentColor),
                    )
                  : Scrollbar(
                      controller: scrollController,
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView(
                        physics: const ScrollPhysics(),
                        padding: const EdgeInsets.all(kDefaultPadding),
                        children: [
                          DottedBorder(
                            borderType: BorderType.RRect,
                            color: kLightGreyColor,
                            radius: const Radius.circular(kDefaultPadding),
                            padding: const EdgeInsets.all(kDefaultPadding),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                "assets/icons/store.png",
                                fit: BoxFit.contain,
                                height: media.height - 700,
                              ),
                            ),
                          ),
                          kSizedBox,
                          ListTile(
                            onTap: _toRegisterVendorPage,
                            horizontalTitleGap: 10,
                            mouseCursor: SystemMouseCursors.click,
                            tileColor: kAccentColor.withOpacity(0.15),
                            focusColor: kAccentColor.withOpacity(0.15),
                            splashColor: kAccentColor.withOpacity(0.15),
                            enableFeedback: true,
                            minVerticalPadding: kDefaultPadding / 2,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kDefaultPadding / 2),
                            ),
                            leading: FaIcon(
                              FontAwesomeIcons.store,
                              color: kAccentColor,
                              size: 30,
                            ),
                            title: const Text(
                              "Register a vendor",
                            ),
                            titleTextStyle: const TextStyle(
                              color: kTextBlackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            subtitle: const Text(
                              "Register a new vendor account",
                            ),
                            subtitleTextStyle: TextStyle(color: kTextGreyColor),
                            trailing: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: kAccentColor,
                              size: 26,
                            ),
                          ),
                          kSizedBox,
                          ListTile(
                            onTap: _toAddThirdPartyVendor,
                            horizontalTitleGap: 10,
                            mouseCursor: SystemMouseCursors.click,
                            enableFeedback: true,
                            tileColor: kLightGreyColor.withOpacity(0.15),
                            focusColor: kLightGreyColor.withOpacity(0.15),
                            splashColor: kLightGreyColor.withOpacity(0.15),
                            minVerticalPadding: kDefaultPadding / 2,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kDefaultPadding / 2),
                            ),
                            leading: FaIcon(
                              FontAwesomeIcons.store,
                              color: kAccentColor,
                              size: 30,
                            ),
                            title: const Text(
                              "Add third party vendor",
                            ),
                            titleTextStyle: const TextStyle(
                              color: kTextBlackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            subtitle: const Text(
                              "Create a vendor account on behalf of a vendor (3rd party account)",
                            ),
                            subtitleTextStyle: TextStyle(color: kTextGreyColor),
                            trailing: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: kAccentColor,
                              size: 26,
                            ),
                          ),
                          kSizedBox,
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}
