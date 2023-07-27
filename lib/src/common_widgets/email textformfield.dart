// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class EmailTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator validator;
  final dynamic onSaved;
  final TextInputAction textInputAction;
  final FocusNode emailFocusNode;

  const EmailTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    this.onSaved,
    required this.textInputAction,
    required this.emailFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // onTap: onTap,
      focusNode: emailFocusNode,
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      textInputAction: textInputAction,
      textAlign: TextAlign.start,
      cursorColor: kSecondaryColor,
      autocorrect: true,
      enableSuggestions: true,
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      style: TextStyle(
        color: kSecondaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: "example@gmail.com",
        errorStyle: const TextStyle(
          color: kErrorColor,
        ),
        filled: true,
        fillColor: Colors.blue.shade50,
        focusColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          borderSide: BorderSide(
            color: Colors.blue.shade50,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          borderSide: BorderSide(
            color: Colors.blue.shade50,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          borderSide: BorderSide(
            color: Colors.blue.shade50,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          borderSide: const BorderSide(
            color: kErrorBorderColor,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          borderSide: const BorderSide(
            color: kErrorBorderColor,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
