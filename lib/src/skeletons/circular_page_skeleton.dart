import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class CircularPageSkeleton extends StatelessWidget {
  final double height;
  final double width;
  const CircularPageSkeleton(
      {super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      decoration: ShapeDecoration(
        color: kPageSkeletonColor,
        shape: const OvalBorder(),
      ),
    );
  }
}
