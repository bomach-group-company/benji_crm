import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';

class MyDropDownMenu extends StatelessWidget {
  const MyDropDownMenu({
    super.key,
    required this.controller,
    required this.hintText,
    required this.dropdownMenuEntries,
    this.enabled = true,
    this.onSelected,
    this.enableSearch,
    this.enableFilter,
    this.menuHeight,
    this.errorText,
    this.width,
  });

  final TextEditingController controller;
  final bool enabled;
  final String hintText;
  final List<DropdownMenuEntry<Object>> dropdownMenuEntries;
  final Function(dynamic value)? onSelected;
  final bool? enableSearch;
  final bool? enableFilter;
  final double? menuHeight;
  final String? errorText;
  final double? width;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return DropdownMenu(
      dropdownMenuEntries: dropdownMenuEntries,
      enabled: enabled,
      menuStyle: const MenuStyle(
        mouseCursor: MaterialStatePropertyAll(SystemMouseCursors.click),
        elevation: MaterialStatePropertyAll(10),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
        ),
      ),
      onSelected: onSelected ??
          (value) {
            controller.text = value!.toString();
          },
      width: width ?? media.width - 40,
      hintText: hintText,
      enableSearch: enableSearch ?? true,
      enableFilter: enableFilter ?? true,
      errorText: errorText,
      menuHeight: menuHeight ?? deviceType(media.width) >= 2
          ? media.height * 0.6
          : media.height * 0.4,
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: TextStyle(color: kAccentColor),
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
    );
  }
}
