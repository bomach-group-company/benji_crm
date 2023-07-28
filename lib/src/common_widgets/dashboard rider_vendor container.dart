// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../providers/constants.dart';

class RiderVendorContainer extends StatelessWidget {
  final Function() onTap;
  final String number;
  final String typeOf;
  final String onlineStatus;
  const RiderVendorContainer({
    super.key,
    required this.onTap,
    required this.number,
    required this.typeOf,
    required this.onlineStatus,
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
        width: MediaQuery.of(context).size.width,
        height: 140,
        decoration: ShapeDecoration(
          color: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultPadding),
          ),
          shadows: const [
            BoxShadow(
              color: Color(
                0x0F000000,
              ),
              blurRadius: 24,
              offset: Offset(
                0,
                4,
              ),
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
                color: kAccentColor,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    typeOf,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: kTextBlackColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 62.78,
                    child: Text(
                      number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: kTextBlackColor,
                        fontSize: 52.32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    onlineStatus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kAccentColor,
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
