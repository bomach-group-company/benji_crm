import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';
import 'page_skeleton.dart';

class DashboardPageSkeleton extends StatelessWidget {
  const DashboardPageSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(kDefaultPadding),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            2,
            (index) => Shimmer.fromColors(
              highlightColor: kBlackColor.withOpacity(0.9),
              baseColor: kBlackColor.withOpacity(0.6),
              direction: ShimmerDirection.ltr,
              child: const PageSkeleton(
                width: 160,
                height: 140,
              ),
            ),
            growable: true,
          ),
        ),
        kSizedBox,
        SizedBox(
          height: 450,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (index) => Shimmer.fromColors(
                highlightColor: kBlackColor.withOpacity(0.9),
                baseColor: kBlackColor.withOpacity(0.6),
                direction: ShimmerDirection.ltr,
                child: PageSkeleton(
                  width: media.width,
                  height: 140,
                ),
              ),
              growable: true,
            ),
          ),
        ),
      ],
    );
  }
}
