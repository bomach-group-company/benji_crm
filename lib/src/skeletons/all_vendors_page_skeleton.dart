import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'page_skeleton.dart';
import 'vendors_list_skeleton.dart';

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
                (index) => const PageSkeleton(height: 35, width: 130),
                growable: true,
              ),
            ),
          ),
        ),
        kSizedBox,
        const VendorsListSkeleton(),
      ],
    );
  }
}
