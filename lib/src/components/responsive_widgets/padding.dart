import 'package:flutter/material.dart';

import '../../responsive/responsive_constant.dart';

class MyResponsivePadding extends StatelessWidget {
  final Widget child;
  final double reduceby;
  final double reducebyLarge;
  const MyResponsivePadding({
    super.key,
    required this.child,
    this.reduceby = 100,
    this.reducebyLarge = 150,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      child: Center(
        heightFactor: 1,
        child: SizedBox(
          width: breakPoint(
              width, width, width, width - reduceby, width - reducebyLarge),
          child: child,
        ),
      ),
    );
  }
}
