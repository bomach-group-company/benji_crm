// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class ReusableAuthenticationFirstHalf extends StatelessWidget {
  final String title;
  final String subtitle;
  final Decoration decoration;
  final double imageContainerHeight;
  final Duration duration;
  final Curve curves;
  final Widget containerChild;
  const ReusableAuthenticationFirstHalf({
    super.key,
    required this.title,
    required this.subtitle,
    required this.decoration,
    required this.imageContainerHeight,
    required this.duration,
    required this.curves,
    required this.containerChild,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          kSizedBox,
          kSizedBox,
          AnimatedContainer(
            duration: duration,
            curve: curves,
            height: imageContainerHeight,
            width: imageContainerHeight,
            decoration: decoration,
            margin: const EdgeInsets.only(bottom: kDefaultPadding / 3),
            child: containerChild,
          ),
          Container(
            color: kSecondaryColor,
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(kDefaultPadding / 3),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
