// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../providers/constants.dart';

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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kDefaultPadding),
      child: Container(
        padding: const EdgeInsets.only(
          top: kDefaultPadding / 1.5,
          left: kDefaultPadding,
          right: kDefaultPadding / 1.5,
        ),
        width: MediaQuery.of(context).size.width * 0.41,
        height: 140,
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
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 20,
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
                    height: 62.78,
                    child: Text(
                      numberOfOrders,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: kAccentColor,
                        fontSize: 52.32,
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
                      fontSize: 13,
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
