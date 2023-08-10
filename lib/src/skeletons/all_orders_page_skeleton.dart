import 'package:benji_aggregator/src/skeletons/dashboard_orders_list_skeleton.dart';
import 'package:benji_aggregator/src/skeletons/page_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class AllOrdersPageskeleton extends StatelessWidget {
  const AllOrdersPageskeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kDefaultPadding),
      physics: const BouncingScrollPhysics(),
      children: [
        Center(
          child: Shimmer.fromColors(
            highlightColor: kBlackColor.withOpacity(0.02),
            baseColor: kBlackColor.withOpacity(0.8),
            direction: ShimmerDirection.ltr,
            child: PageSkeleton(height: 80, width: 320),
          ),
        ),
        kSizedBox,
        ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => OrdersListSkeleton(),
          separatorBuilder: (context, index) =>
              SizedBox(height: kDefaultPadding / 2),
          itemCount: 10,
        )
      ],
    );
  }
}
