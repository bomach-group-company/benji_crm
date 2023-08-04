import 'package:benji_aggregator/src/skeletons/dashboard_orders_list_skeleton.dart';
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
    double mediaWidth = MediaQuery.of(context).size.width;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(kDefaultPadding),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            2,
            (index) => Shimmer.fromColors(
              highlightColor: kBlackColor.withOpacity(0.02),
              baseColor: kBlackColor.withOpacity(0.8),
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
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              2,
              (index) => Shimmer.fromColors(
                highlightColor: kBlackColor.withOpacity(0.02),
                baseColor: kBlackColor.withOpacity(0.8),
                direction: ShimmerDirection.ltr,
                child: PageSkeleton(
                  width: mediaWidth,
                  height: 140,
                ),
              ),
              growable: true,
            ),
          ),
        ),
        kSizedBox,
        Shimmer.fromColors(
          highlightColor: kBlackColor.withOpacity(0.02),
          baseColor: kBlackColor.withOpacity(0.8),
          direction: ShimmerDirection.ltr,
          child: PageSkeleton(
            width: mediaWidth,
            height: 30,
          ),
        ),
        kSizedBox,
        const DashboardOrdersListSkeleton(),
      ],
    );
  }
}
