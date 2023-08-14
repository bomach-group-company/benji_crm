import 'package:flutter/material.dart';

import '../../../theme/responsive_constant.dart';

class MyResponsiveWidthAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget child;
  const MyResponsiveWidthAppbar({super.key, required this.child});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return SizedBox(
      child: Center(
        heightFactor: 1,
        child: SizedBox(
          width: breakPoint(media.width, media.width, media.width - 100,
              media.width - 200, media.width - 200),
          child: child,
        ),
      ),
    );
  }
}
