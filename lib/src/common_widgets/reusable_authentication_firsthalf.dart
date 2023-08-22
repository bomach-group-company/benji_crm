// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class ReusableAuthenticationFirstHalf extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Duration duration;
  final Curve curves;
  final double imageContainerHeight;
  final Decoration decoration;

  const ReusableAuthenticationFirstHalf({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.duration,
    required this.curves,
    required this.imageContainerHeight,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: duration,
          curve: curves,
          height: imageContainerHeight,
          width: imageContainerHeight,
          decoration: decoration,
          child: child,
          margin: const EdgeInsets.only(bottom: kDefaultPadding / 3),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
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
    );
  }
}
