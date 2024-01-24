// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names,

import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/colors.dart';

class MyBlueTextFormField extends StatelessWidget {
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final dynamic onSaved;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final bool? isEnabled;
  final VoidCallback? click;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final int maxlines;
  final bool? readOnly;
  final void Function(String)? onChanged;

  const MyBlueTextFormField({
    Key? key,
    required this.hintText,
    required this.textInputType,
    required this.controller,
    required this.validator,
    this.onSaved,
    required this.textInputAction,
    required this.focusNode,
    this.isEnabled,
    this.click,
    this.suffixIcon,
    this.inputFormatters,
    this.maxlines = 1,
    this.readOnly,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return TextFormField(
      readOnly: readOnly ?? false,
      focusNode: focusNode,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      textInputAction: textInputAction,
      textAlign: TextAlign.start,
      cursorColor: kSecondaryColor,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: true,
      enableSuggestions: true,
      keyboardType: textInputType,
      maxLines: maxlines,
      enabled: isEnabled ?? true,
      onTap: click,
      inputFormatters: inputFormatters,
      style: TextStyle(
        color: kSecondaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        errorStyle: TextStyle(color: kAccentColor),
        suffixIcon: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(10),
            width: deviceType(media.width) >= 2 ? 50 : 30,
            child: suffixIcon ?? const FaIcon(null)),
        filled: true,
        fillColor: Colors.blue.shade50,
        focusColor: Colors.blue.shade50,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
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
