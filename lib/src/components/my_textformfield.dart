// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final dynamic onSaved;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final Icon prefixIcon;
  final Icon suffixIcon;

  const MyTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    this.onSaved,
    required this.textInputAction,
    required this.focusNode,
    required this.hintText,
    required this.textInputType,
    required this.prefixIcon,
    required this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      textInputAction: textInputAction,
      textAlign: TextAlign.start,
      cursorColor: kSecondaryColor,
      autocorrect: true,
      enableSuggestions: true,
      keyboardType: textInputType,
      maxLines: 1,
      style: TextStyle(
        color: kSecondaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF6F6F7),
        focusColor: const Color(0xFFF6F6F7),
        hintStyle: const TextStyle(
          color: Color(0xFF979797),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: const TextStyle(color: kErrorColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue.shade50),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue.shade50),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue.shade50),
        ),
      ),
    );
  }
}
