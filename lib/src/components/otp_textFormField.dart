// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/colors.dart';

class MyOTPTextFormField extends StatelessWidget {
  final TextInputAction textInputAction;
  final dynamic onSaved;
  final dynamic validator;
  final dynamic onChanged;
  const MyOTPTextFormField({
    super.key,
    required this.textInputAction,
    required this.onSaved,
    required this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      textInputAction: textInputAction,
      onSaved: onSaved,
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: "0",
        hintStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
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
