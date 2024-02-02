// ignore_for_file: file_names

import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/main.dart';
import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../../theme/colors.dart';
import '../../../controller/rider_controller.dart';
import '../../../controller/vendor_controller.dart';
import '../../providers/constants.dart';

class AvailableBalanceCard extends StatefulWidget {
  const AvailableBalanceCard({super.key});

  @override
  State<AvailableBalanceCard> createState() => _AvailableBalanceCardState();
}

class _AvailableBalanceCardState extends State<AvailableBalanceCard> {
  // logic
  Future<void> toggleVisibleCash() async {
    bool isVisibleCash = prefs.getBool('isVisibleCash') ?? true;
    await prefs.setBool('isVisibleCash', !isVisibleCash);

    UserController.instance.setUserSync();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      width: media.width,
      height: deviceType(media.width) >= 2 ? 200 : 140,
      decoration: ShapeDecoration(
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 24,
            offset: Offset(0, 4),
            spreadRadius: 4,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Available Balance',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: kTextBlackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              GetBuilder<UserController>(
                init: UserController(),
                builder: (controller) => IconButton(
                  onPressed: toggleVisibleCash,
                  icon: FaIcon(
                    controller.user.value.isVisibleCash
                        ? FontAwesomeIcons.solidEye
                        : FontAwesomeIcons.solidEyeSlash,
                    color: kAccentColor,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              GetBuilder<UserController>(
                init: UserController(),
                builder: (controller) => controller.isLoading.value
                    ? Text(
                        'Loading...',
                        style: TextStyle(
                          color: kGreyColor,
                          fontSize: 20,
                          fontFamily: 'sen',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "₦ ",
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 30,
                                fontFamily: 'sen',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: controller.user.value.isVisibleCash
                                  ? doubleFormattedText(
                                      controller.user.value.balance)
                                  : '******',
                              style: TextStyle(
                                color: kAccentColor,
                                fontSize: 30,
                                fontFamily: 'sen',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              kSizedBox,
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
                onPressed: () {
                  UserController.instance.getUser();
                  VendorController.instance.getMyVendors();
                  RiderController.instance.getRiders();
                },
                mouseCursor: SystemMouseCursors.click,
                color: kGreyColor,
                iconSize: 25.0,
                tooltip: 'Refresh',
                padding: const EdgeInsets.all(10.0),
                splashRadius: 20.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
