import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class PageSkeleton extends StatelessWidget {
  const PageSkeleton({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);
  final double height, width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: kBlackColor.withOpacity(0.35),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}
