import 'package:flutter/material.dart';

import '../providers/constants.dart';
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
                (index) => const PageSkeleton(height: 35, width: 130),
                growable: true,
              ),
            ),
          ),
        ),
        kSizedBox,
        ListView.separated(
          separatorBuilder: (context, index) =>
              const SizedBox(height: kDefaultPadding),
          itemCount: 30,
          addAutomaticKeepAlives: true,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageSkeleton(height: 120, width: 130),
              kWidthSizedBox,
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: PageSkeleton(height: 20, width: 200),
                  ),
                  kSizedBox,
                  SizedBox(
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
                  PageSkeleton(height: 15, width: 200),
                  kSizedBox,
                  PageSkeleton(height: 15, width: 200),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
