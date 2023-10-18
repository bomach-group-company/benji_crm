// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../theme/colors.dart';

void myFixedSnackBar(
  BuildContext context,
  String text,
  Color bgColor,
  Duration duration,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      duration: duration,
      showCloseIcon: true,
      elevation: 50.0,
      closeIconColor: kPrimaryColor,
      behavior: SnackBarBehavior.fixed,
      backgroundColor: bgColor,
    ),
  );
}
