import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../theme/colors.dart';

class MyLiquidRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  const MyLiquidRefresh(
      {super.key, required this.onRefresh, required this.child});

  @override
  build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: onRefresh,
      color: kAccentColor,
      borderWidth: 5.0,
      backgroundColor: kPrimaryColor,
      height: 150,
      animSpeedFactor: 2,
      showChildOpacityTransition: false,
      child: child,
    );
  }
}
