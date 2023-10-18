// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

import '../providers/constants.dart';
import '../../theme/colors.dart';

Future<dynamic> ShowModalBottomSheet(
  BuildContext context,
  double elevation,
  double boxConstraintsMaxHeight,
  double boxConstraintsMinHeight,
  Widget widget,
) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: kPrimaryColor,
    barrierColor: kBlackColor.withOpacity(0.5),
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    isDismissible: true,
    elevation: elevation,
    constraints: BoxConstraints(
      maxHeight: boxConstraintsMaxHeight,
      minHeight: boxConstraintsMinHeight,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(
          kDefaultPadding,
        ),
      ),
    ),
    enableDrag: true,
    builder: (context) => widget,
  );
}
