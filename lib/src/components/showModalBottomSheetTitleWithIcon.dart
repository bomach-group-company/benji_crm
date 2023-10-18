// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../theme/colors.dart';

class ShowModalBottomSheetTitleWithIcon extends StatelessWidget {
  final String title;
  const ShowModalBottomSheetTitleWithIcon({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
//Remove Context

    void _removeContext() => Get.back();

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
          onTap: _removeContext,
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
