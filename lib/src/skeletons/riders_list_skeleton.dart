import 'package:benji_aggregator/src/skeletons/page_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class RidersListSkeleton extends StatelessWidget {
  const RidersListSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
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
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: mediaWidth - 200,
                  child: PageSkeleton(height: 20, width: mediaWidth - 200),
                ),
                kSizedBox,
                PageSkeleton(height: 15, width: mediaWidth - 230),
                kSizedBox,
                PageSkeleton(height: 15, width: mediaWidth - 250),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
