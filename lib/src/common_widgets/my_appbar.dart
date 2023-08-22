// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double elevation;
  final Color backgroundColor;
  final List<Widget> actions;
  final double toolbarHeight;
  @override
  Size get preferredSize => const Size.fromHeight(40);
  const MyAppBar({
    super.key,
    required this.title,
    required this.elevation,
    required this.actions,
    required this.backgroundColor,
    required this.toolbarHeight,
  });
//========================================= FUNCTIONS ============================================\\

//========================================= Navigation ============================================\\
  void _popContext() => Get.back();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: false,
      elevation: elevation,
      backgroundColor: backgroundColor,
      actions: actions,
      title: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: _popContext,
            mouseCursor: SystemMouseCursors.click,
            child: Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                color: const Color(0xFFFEF8F8),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 0.50,
                    color: Color(0xFFFDEDED),
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: kAccentColor,
              ),
            ),
          ),
          kWidthSizedBox,
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF151515),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
