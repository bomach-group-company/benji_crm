import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class ItemDropDownMenu extends StatelessWidget {
  const ItemDropDownMenu({
    super.key,
    required this.itemEC,
    required this.mediaWidth,
    required this.hintText,
    required this.dropdownMenuEntries2,
    this.onSelected,
  });

  final TextEditingController itemEC;
  final double mediaWidth;
  final String hintText;
  final List<DropdownMenuEntry<Object>> dropdownMenuEntries2;
  final Function(dynamic value)? onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      onSelected: onSelected ??
          (value) {
            itemEC.text = value!.toString();
          },
      width: mediaWidth,
      hintText: hintText,
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: const TextStyle(color: kErrorColor),
        filled: true,
        fillColor: Colors.blue.shade50,
        focusColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.blue.shade50,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.blue.shade50,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.blue.shade50,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: kErrorBorderColor,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: kErrorBorderColor,
            width: 2.0,
          ),
        ),
      ),
      dropdownMenuEntries: dropdownMenuEntries2,
    );
  }
}
