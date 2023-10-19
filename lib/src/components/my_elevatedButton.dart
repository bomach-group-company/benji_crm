// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class MyElevatedButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool isLoading;

  const MyElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: kAccentColor.withOpacity(0.5),
        backgroundColor: kAccentColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: kBlackColor.withOpacity(0.4),
        minimumSize: Size(mediaWidth, 60),
      ),
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
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
