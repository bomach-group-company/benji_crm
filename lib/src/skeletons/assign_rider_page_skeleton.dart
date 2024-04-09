// ignore_for_file: unused_local_variable

import 'package:benji_aggregator/src/skeletons/page_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';
import '../utils/constants.dart';

class AssignRiderPageSkeleton extends StatefulWidget {
  const AssignRiderPageSkeleton({super.key});

  @override
  State<AssignRiderPageSkeleton> createState() =>
      _AssignRiderPageSkeletonState();
}

class _AssignRiderPageSkeletonState extends State<AssignRiderPageSkeleton> {
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
//=============================================================================\\
    return ListView.separated(
      itemBuilder: (context, indext) => Shimmer.fromColors(
          highlightColor: kBlackColor.withOpacity(0.02),
          baseColor: kBlackColor.withOpacity(0.8),
          direction: ShimmerDirection.ltr,
          child: PageSkeleton(height: 80, width: mediaWidth)),
      separatorBuilder: (context, index) =>
          const SizedBox(height: kDefaultPadding / 2),
      itemCount: 20,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
    );
  }
}
