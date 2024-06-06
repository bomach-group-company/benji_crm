import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class MyOutlinedElevatedButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final bool isLoading;

  const MyOutlinedElevatedButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: kAccentColor),
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: kBlackColor.withOpacity(0.4),
        minimumSize: Size(mediaWidth, 60),
        // maximumSize: Size(mediaWidth, 60),
      ),
      child: isLoading
          ? CircularProgressIndicator(color: kAccentColor)
          : Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kAccentColor,
                fontSize: 18,
                fontFamily: "Sen",
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
