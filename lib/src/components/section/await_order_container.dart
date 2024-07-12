import 'package:benji_aggregator/app/business_orders/awaiting_orders.dart';
import 'package:benji_aggregator/model/third_party_vendor_model.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../theme/colors.dart';

class AwaitingOrderConfirmation extends StatelessWidget {
  final ThirdPartyVendorModel vendor;

  const AwaitingOrderConfirmation({super.key, required this.vendor});

  toOrderAwaitPage() {
    Get.to(
      () => OrdersAwaiting(vendor: vendor),
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      routeName: "BusinessDetailScreen",
      preventDuplicates: true,
      popGesture: false,
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(kDefaultPadding),
      child: Container(
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
          child: ListTile(
            onTap: toOrderAwaitPage,
            leading: FaIcon(
              FontAwesomeIcons.store,
              color: kAccentColor,
              size: 16,
            ),
            title: const Text(
              'Awaiting confirmation',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: const FaIcon(FontAwesomeIcons.chevronRight),
          )),
    );
  }
}
