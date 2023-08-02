import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';
import 'all_vendors_list_skeleton.dart';
import 'page_skeleton.dart';

class AllVendorsPageSkeleton extends StatelessWidget {
  const AllVendorsPageSkeleton({
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
        AllVendorsListSkeleton(),
      ],
    );
  }
}
