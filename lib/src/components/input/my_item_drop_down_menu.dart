import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class ItemDropDownMenu extends StatelessWidget {
  const ItemDropDownMenu({
    super.key,
    required this.itemEC,
    required this.hintText,
    required this.dropdownMenuEntries,
    this.enabled = true,
    this.onSelected,
    this.menuHeight,
    this.errorText,
    this.width,
  });

  final TextEditingController itemEC;
  final bool enabled;
  final String hintText;
  final List<DropdownMenuEntry<Object>> dropdownMenuEntries;
  final Function(dynamic value)? onSelected;
  final double? menuHeight;
  final String? errorText;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return DropdownMenu(
      onSelected: onSelected ??
          (value) {
            itemEC.text = value!.toString();
          },
      enabled: enabled,
      width: width ?? media.width - 40,
      menuHeight: menuHeight ?? deviceType(media.width) >= 2
          ? media.height * 0.6
          : media.height * 0.4,
      hintText: hintText,
      errorText: errorText,
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: const TextStyle(
          color: kErrorColor,
        ),
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
      dropdownMenuEntries: dropdownMenuEntries,
    );
  }
}
