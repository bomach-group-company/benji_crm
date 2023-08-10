import 'package:benji_aggregator/app/others/my_vendors/add_third_party_vendor.dart';
import 'package:benji_aggregator/src/common_widgets/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../../src/providers/constants.dart';
import '../../vendors/register_vendor.dart';

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
  ScrollController _scrollController = ScrollController();

  //============================================ ALL VARIABLES =================================================\\
  late bool _loadingScreen;

  //============================================ FUNCTIONS =================================================\\

//============================================== Navigation ================================================\\
  void _toRegisterVendorPage() => Get.to(
        () => const RegisterVendor(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Register a vendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toAddThirdPartyVendor() => Get.to(
        () => AddThirdPartyVendor(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Create vendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Add a new vendor",
        elevation: 0.0,
        actions: [],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: FutureBuilder(builder: (context, snapshot) {
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
              ? SpinKitDoubleBounce(color: kAccentColor)
              : Scrollbar(
                  controller: _scrollController,
                  radius: const Radius.circular(10),
                  scrollbarOrientation: ScrollbarOrientation.right,
                  child: ListView(
                    physics: ScrollPhysics(),
                    padding: const EdgeInsets.all(kDefaultPadding),
                    children: [
                      DottedBorder(
                        borderType: BorderType.RRect,
                        color: kLightGreyColor,
                        radius: Radius.circular(kDefaultPadding),
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Icon(
                            Icons.add_business_sharp,
                            color: kAccentColor,
                            size: 80,
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
                        leading: Icon(
                          Icons.add_business_outlined,
                          color: kAccentColor,
                          size: 30,
                        ),
                        title: Text(
                          "Register a vendor",
                        ),
                        titleTextStyle: TextStyle(
                          color: kTextBlackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: Text(
                          "Register a new vendor account",
                        ),
                        subtitleTextStyle: TextStyle(color: kTextGreyColor),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
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
                        leading: Icon(
                          Icons.add_business_outlined,
                          color: kAccentColor,
                          size: 30,
                        ),
                        title: Text(
                          "Add third party vendor",
                        ),
                        titleTextStyle: TextStyle(
                          color: kTextBlackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: Text(
                          "Create a vendor account on behalf of a vendor (3rd party account)",
                        ),
                        subtitleTextStyle: TextStyle(color: kTextGreyColor),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
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
