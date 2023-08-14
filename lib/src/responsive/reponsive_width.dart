import 'package:flutter/material.dart';

import '../providers/responsive_constant.dart';

class MyResponsiveWidth extends StatelessWidget {
  final Widget child;
  const MyResponsiveWidth({super.key, this.child = const SizedBox()});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Center(
      heightFactor: 1,
      child: SizedBox(
        width: breakPoint(media.width, media.width, media.width - 100,
            media.width - 200, media.width - 200),
        child: child,
      ),
    );
  }
}
