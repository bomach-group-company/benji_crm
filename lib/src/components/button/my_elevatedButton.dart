// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';

class MyElevatedButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final bool isLoading;
  final bool disable;

  const MyElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.disable = false,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: disable
          ? null
          : isLoading
              ? null
              : onPressed,
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: kAccentColor.withOpacity(0.5),
        backgroundColor: kAccentColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: kBlackColor.withOpacity(0.4),
        minimumSize: Size(media.width, 60),
      ),
      child: isLoading
          ? CircularProgressIndicator(color: kPrimaryColor)
          : Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18,
                fontFamily: "Sen",
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
