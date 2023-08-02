// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final Color bgColor;
  final Color categoryFontColor;
  const CategoryButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.bgColor,
    required this.categoryFontColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        minimumSize: const Size(100, 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 14,
          color: categoryFontColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
