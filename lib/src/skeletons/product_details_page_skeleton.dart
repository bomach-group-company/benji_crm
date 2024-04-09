import 'package:benji_aggregator/src/skeletons/page_skeleton.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';

class ProductDetailsPageSkeleton extends StatelessWidget {
  const ProductDetailsPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Shimmer.fromColors(
          highlightColor: kBlackColor.withOpacity(0.02),
          baseColor: kBlackColor.withOpacity(0.8),
          direction: ShimmerDirection.ltr,
          child: PageSkeleton(height: 300, width: mediaWidth),
        ),
        kHalfSizedBox,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PageSkeleton(height: 30, width: 180),
              PageSkeleton(height: 30, width: 120),
            ],
          ),
        ),
        kSizedBox,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Shimmer.fromColors(
            highlightColor: kBlackColor.withOpacity(0.02),
            baseColor: kBlackColor.withOpacity(0.8),
            direction: ShimmerDirection.ltr,
            child: PageSkeleton(height: 200, width: mediaWidth),
          ),
        ),
        kSizedBox,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PageSkeleton(height: 30, width: 180),
              PageSkeleton(height: 30, width: 80),
            ],
          ),
        ),
        kSizedBox,
        Container(
          height: 100,
          margin: const EdgeInsets.only(left: kDefaultPadding / 2),
          child: ListView.separated(
            itemCount: 30,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(
              width: kDefaultPadding / 2,
            ),
            itemBuilder: (context, index) => Shimmer.fromColors(
              highlightColor: kBlackColor.withOpacity(0.02),
              baseColor: kBlackColor.withOpacity(0.8),
              direction: ShimmerDirection.ltr,
              child: Container(
                decoration: BoxDecoration(
                  color: kPageSkeletonColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: 100,
              ),
            ),
          ),
        ),
        kSizedBox,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PageSkeleton(height: 30, width: 180),
              PageSkeleton(height: 30, width: 80),
            ],
          ),
        ),
        kSizedBox,
        Container(
          height: 100,
          margin: const EdgeInsets.only(left: kDefaultPadding / 2),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 30,
            separatorBuilder: (context, index) => const SizedBox(
              width: kDefaultPadding / 2,
            ),
            itemBuilder: (context, index) => Shimmer.fromColors(
              highlightColor: kBlackColor.withOpacity(0.02),
              baseColor: kBlackColor.withOpacity(0.8),
              direction: ShimmerDirection.ltr,
              child: Container(
                decoration: BoxDecoration(
                  color: kPageSkeletonColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: 100,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
