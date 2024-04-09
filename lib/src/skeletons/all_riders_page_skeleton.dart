import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';
import '../utils/constants.dart';
import 'page_skeleton.dart';
import 'riders_list_skeleton.dart';

class AllRidersPageSkeleton extends StatelessWidget {
  const AllRidersPageSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(kDefaultPadding),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 280,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                2,
                (index) => Shimmer.fromColors(
                  highlightColor: kBlackColor.withOpacity(0.02),
                  baseColor: kBlackColor.withOpacity(0.8),
                  direction: ShimmerDirection.ltr,
                  child: const PageSkeleton(height: 35, width: 130),
                ),
                growable: true,
              ),
            ),
          ),
        ),
        kSizedBox,
        const RidersListSkeleton(),
      ],
    );
  }
}
