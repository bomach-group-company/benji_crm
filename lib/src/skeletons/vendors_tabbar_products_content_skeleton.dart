// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';
import 'page_skeleton.dart';

class VendorsTabBarProductsContentSkeleton extends StatelessWidget {
  final int vendorProductCount;
  final int vendorProductCategoryCount;
  const VendorsTabBarProductsContentSkeleton({
    super.key,
    required this.vendorProductCount,
    required this.vendorProductCategoryCount,
  });

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: mediaHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              itemCount: vendorProductCategoryCount,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              // const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(kDefaultPadding / 2),
                  child: Shimmer.fromColors(
                    highlightColor: kBlackColor.withOpacity(0.02),
                    baseColor: kBlackColor.withOpacity(0.8),
                    direction: ShimmerDirection.ltr,
                    child: const PageSkeleton(
                      height: 30,
                      width: 100,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: mediaHeight,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vendorProductCount,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: kDefaultPadding / 2);
              },
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(kDefaultPadding / 2),
                  child: Shimmer.fromColors(
                    highlightColor: kBlackColor.withOpacity(0.02),
                    baseColor: kBlackColor.withOpacity(0.8),
                    direction: ShimmerDirection.ltr,
                    child: const PageSkeleton(
                      width: 90,
                      height: 92,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
