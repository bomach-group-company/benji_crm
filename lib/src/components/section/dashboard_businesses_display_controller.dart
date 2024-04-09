import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/colors.dart';
import '../../utils/constants.dart';

class DashboardDisplayBusinessesController extends StatelessWidget {
  final Function()? onTap;
  final String numberOfBusinesses;
  final bool refreshing;
  final bool showBusinesses;

  const DashboardDisplayBusinessesController({
    super.key,
    this.onTap,
    required this.numberOfBusinesses,
    this.refreshing = false,
    this.showBusinesses = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kDefaultPadding),
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
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
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FaIcon(
              FontAwesomeIcons.store,
              color: kAccentColor,
              size: 16,
            ),
            Row(
              children: [
                Text(
                  showBusinesses ? "Hide Businesses" : "Show Businesses",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: kTextBlackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                kHalfWidthSizedBox,
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "(",
                        style: TextStyle(
                          color: kTextGreyColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: refreshing ? "..." : numberOfBusinesses,
                        style: TextStyle(
                          color: kAccentColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: ")",
                        style: TextStyle(
                          color: kTextGreyColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            FaIcon(
              showBusinesses
                  ? FontAwesomeIcons.caretDown
                  : FontAwesomeIcons.caretUp,
              color: kAccentColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
