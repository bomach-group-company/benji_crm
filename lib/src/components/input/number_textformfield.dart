// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/colors.dart';

class NumberTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator validator;
  final dynamic onSaved;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final int maxlength;

  const NumberTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    this.onSaved,
    this.maxlength = 20,
    required this.textInputAction,
    required this.focusNode,
    required this.hintText,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // onTap: onTap,
      focusNode: focusNode,
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      textInputAction: textInputAction,
      textAlign: TextAlign.start,
      cursorColor: kSecondaryColor,
      autocorrect: true,
      enableSuggestions: true,
      keyboardType: TextInputType.number,
      inputFormatters: inputFormatters,
      maxLength: maxlength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // mouseCursor: SystemMouseCursors.text,
      maxLines: 1,
      style: TextStyle(
        color: kSecondaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
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
          borderSide: const BorderSide(color: kErrorBorderColor, width: 2.0),
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
