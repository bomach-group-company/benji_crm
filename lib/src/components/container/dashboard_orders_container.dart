// ignore_for_file: file_names

import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../theme/colors.dart';
import '../../providers/constants.dart';

class OrdersContainer extends StatelessWidget {
  final Function() onTap;
  final String numberOfOrders;
  final String typeOfOrders;
  final Color containerColor;
  final Color typeOfOrderColor;
  final Color iconColor;

  const OrdersContainer({
    super.key,
    required this.onTap,
    required this.numberOfOrders,
    required this.typeOfOrders,
    required this.containerColor,
    required this.typeOfOrderColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kDefaultPadding),
      child: Container(
        padding: const EdgeInsets.only(
          top: kDefaultPadding / 1.5,
          left: kDefaultPadding,
          right: kDefaultPadding / 1.5,
        ),
        width: media.width * 0.41,
        height: deviceType(media.width) > 2 ? 200 : 140,
        decoration: ShapeDecoration(
          color: containerColor,
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
          children: [
            Align(
              alignment: Alignment.topRight,
              child: FaIcon(
                FontAwesomeIcons.chevronRight,
                // size: 20,
                color: iconColor,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      numberOfOrders,
                      textAlign: TextAlign.left,
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kAccentColor,
                        fontSize: deviceType(media.width) > 2 ? 64 : 54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "$typeOfOrders Orders",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: typeOfOrderColor,
                      fontSize: deviceType(media.width) > 2 ? 23 : 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
