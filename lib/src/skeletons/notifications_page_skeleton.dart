// ignore_for_file: unused_local_variable

import 'package:benji_aggregator/src/skeletons/circular_page_skeleton.dart';
import 'package:benji_aggregator/src/skeletons/page_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class NotificationsPageSkeleton extends StatelessWidget {
  const NotificationsPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      // padding: const EdgeInsets.all(kDefaultPadding / 2),
      shrinkWrap: true,
      itemCount: 30,
      itemBuilder: (context, index) => ListTile(
        minVerticalPadding: kDefaultPadding / 2,
        leading: Shimmer.fromColors(
          highlightColor: kBlackColor.withOpacity(0.02),
          baseColor: kBlackColor.withOpacity(0.8),
          direction: ShimmerDirection.ltr,
          child: const CircularPageSkeleton(height: 45, width: 45),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              highlightColor: kBlackColor.withOpacity(0.02),
              baseColor: kBlackColor.withOpacity(0.8),
              direction: ShimmerDirection.ltr,
              child: PageSkeleton(height: 10, width: mediaWidth / 2),
            ),
            kHalfSizedBox,
            PageSkeleton(height: 10, width: mediaWidth / 3),
            kHalfSizedBox,
            PageSkeleton(height: 10, width: mediaWidth / 4),
          ],
        ),
      ),
    );
  }
}
