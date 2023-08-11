// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class ShowModalBottomSheetTitleWithIcon extends StatelessWidget {
  final String title;
  const ShowModalBottomSheetTitleWithIcon({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.48,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pop(context);
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: ShapeDecoration(
              color: kAccentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: kPrimaryColor,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
