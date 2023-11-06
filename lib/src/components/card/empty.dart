import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyCard extends StatelessWidget {
  final String message;
  const EmptyCard({
    super.key,
    this.message = "Oops! There is nothing here.",
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Column(
          children: [
            Lottie.asset(
              "assets/animations/empty/frame_1.json",
            ),
            kSizedBox,
            Text(
              message,
              style: TextStyle(
                color: kTextGreyColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            kSizedBox,
          ],
        ),
      ],
    );
  }
}
