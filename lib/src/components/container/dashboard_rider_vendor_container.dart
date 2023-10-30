// ignore_for_file: file_names

import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../theme/colors.dart';
import '../../providers/constants.dart';

class RiderVendorContainer extends StatelessWidget {
  final Function() onTap;
  final String number;
  final String typeOf;
  final String? onlineStatus;
  const RiderVendorContainer({
    super.key,
    required this.onTap,
    required this.number,
    required this.typeOf,
    this.onlineStatus,
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
          children: [
            Align(
              alignment: Alignment.topRight,
              child: FaIcon(
                FontAwesomeIcons.chevronRight,
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
                    width: media.width - 250,
                    child: Text(
                      number,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: kTextBlackColor,
                        fontSize: 52.32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                onlineStatus == null
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          onlineStatus!,
                          textAlign: TextAlign.left,
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
