import 'package:benji_aggregator/src/skeletons/page_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class VendorsListSkeleton extends StatelessWidget {
  const VendorsListSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return ListView.separated(
      separatorBuilder: (context, index) =>
          const SizedBox(height: kDefaultPadding),
      itemCount: 30,
      addAutomaticKeepAlives: true,
      physics: const BouncingScrollPhysics(),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: PageSkeleton(height: 20, width: 100),
              ),
              kSizedBox,
              SizedBox(
                width: media.width - 200,
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
              PageSkeleton(height: 15, width: media.width - 200),
              kSizedBox,
              PageSkeleton(height: 15, width: media.width - 200),
            ],
          ),
        ],
      ),
    );
  }
}
