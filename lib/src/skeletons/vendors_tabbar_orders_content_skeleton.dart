import 'package:benji_aggregator/src/skeletons/page_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class VendorsTabBarOrdersContentSkeleton extends StatelessWidget {
  const VendorsTabBarOrdersContentSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) =>
          const SizedBox(height: kDefaultPadding),
      padding: const EdgeInsets.all(kDefaultPadding),
      itemCount: 30,
      addAutomaticKeepAlives: true,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            highlightColor: kBlackColor.withOpacity(0.02),
            baseColor: kBlackColor.withOpacity(0.8),
            direction: ShimmerDirection.ltr,
            child: const PageSkeleton(height: 120, width: 130),
          ),
          kWidthSizedBox,
          Column(
            children: [
              SizedBox(
                width: 200,
                child: Shimmer.fromColors(
                  highlightColor: kBlackColor.withOpacity(0.02),
                  baseColor: kBlackColor.withOpacity(0.8),
                  direction: ShimmerDirection.ltr,
                  child: const PageSkeleton(height: 20, width: 200),
                ),
              ),
              kSizedBox,
              const SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PageSkeleton(height: 15, width: 60),
                    kHalfWidthSizedBox,
                    PageSkeleton(height: 15, width: 60),
                  ],
                ),
              ),
              kHalfSizedBox,
              const PageSkeleton(height: 15, width: 200),
              kSizedBox,
              const PageSkeleton(height: 15, width: 200),
            ],
          ),
        ],
      ),
    );
  }
}
