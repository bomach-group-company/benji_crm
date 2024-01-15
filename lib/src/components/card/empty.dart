import 'package:benji_aggregator/app/overview/overview.dart';
import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

import '../button/my_elevatedButton.dart';

class EmptyCard extends StatelessWidget {
  final String emptyCardMessage;
  final String buttonTitle;
  final String animation;
  final dynamic onPressed;
  final bool showButton;

  const EmptyCard({
    super.key,
    this.animation = "assets/animations/empty/frame_1.json",
    this.emptyCardMessage = "Oops! There is nothing here",
    this.buttonTitle = "",
    this.onPressed,
    this.showButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(kDefaultPadding),
      children: [
        Column(
          children: [
            Lottie.asset(animation),
            kSizedBox,
            Text(
              emptyCardMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kTextGreyColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            kSizedBox,
            showButton == false
                ? const SizedBox()
                : MyElevatedButton(
                    title: buttonTitle,
                    onPressed: onPressed ??
                        () {
                          Get.offAll(
                            () => OverView(currentIndex: 0),
                            routeName: 'OverView',
                            duration: const Duration(milliseconds: 300),
                            fullscreenDialog: true,
                            curve: Curves.easeIn,
                            popGesture: false,
                            predicate: (routes) => false,
                            transition: Transition.rightToLeft,
                          );
                        },
                  ),
          ],
        ),
      ],
    );
  }
}
