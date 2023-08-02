// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'category_button.dart';

class CategoryButtonSection extends StatelessWidget {
  const CategoryButtonSection({
    super.key,
    required List category,
    required List<Color> categorybgColor,
    required List<Color> categoryFontColor,
    required this.onPressed,
  })  : _category = category,
        _categorybgColor = categorybgColor,
        _categoryFontColor = categoryFontColor;

  final List _category;
  final List<Color> _categorybgColor;
  final List<Color> _categoryFontColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemCount: _category.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.all(
            8.0,
          ),
          child: CategoryButton(
            onPressed: onPressed,
            title: _category[index],
            bgColor: _categorybgColor[index],
            categoryFontColor: _categoryFontColor[index],
          ),
        ),
      ),
    );
  }
}
