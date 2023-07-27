// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class MyOutlinedElevatedButton extends StatelessWidget {
  final Function() onPressed;
  final double circularBorderRadius;
  final double minimumSizeWidth;
  final double minimumSizeHeight;
  final double maximumSizeWidth;
  final double maximumSizeHeight;
  final String buttonTitle;
  final double titleFontSize;
  final double elevation;

  const MyOutlinedElevatedButton({
    super.key,
    required this.onPressed,
    required this.circularBorderRadius,
    required this.minimumSizeWidth,
    required this.minimumSizeHeight,
    required this.maximumSizeWidth,
    required this.maximumSizeHeight,
    required this.buttonTitle,
    required this.titleFontSize,
    required this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: kAccentColor,
          ),
          borderRadius: BorderRadius.circular(
            circularBorderRadius,
          ),
        ),
        minimumSize: Size(
          minimumSizeWidth,
          minimumSizeHeight,
        ),
        maximumSize: Size(
          maximumSizeWidth,
          maximumSizeHeight,
        ),
      ),
      child: Text(
        buttonTitle,
        style: TextStyle(
          color: kAccentColor,
          fontSize: titleFontSize,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
