// ignore_for_file:   avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../theme/colors.dart';

class MyPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String initialCountryCode;
  final String invalidNumberMessage;
  final IconPosition dropdownIconPosition;
  final bool showCountryFlag;
  final bool showDropdownIcon;
  final Icon dropdownIcon;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final void Function(Country country)? onCountryChanged;
  const MyPhoneField({
    super.key,
    required this.controller,
    required this.initialCountryCode,
    required this.invalidNumberMessage,
    required this.dropdownIconPosition,
    required this.showCountryFlag,
    required this.showDropdownIcon,
    required this.dropdownIcon,
    required this.textInputAction,
    required this.focusNode,
    this.onSaved,
    this.validator,
    this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderPhoneField(
      name: 'phone_number',
      defaultSelectedCountryIsoCode: "NG",
      priorityListByIsoCode: const ['NG'],
      countryFilterByIsoCode: const ['NG'],
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: textInputAction,
      focusNode: focusNode,
      validator: validator,
      onSaved: onSaved,
      cursorColor: kSecondaryColor,
      onChanged: (phone) {},
      style: TextStyle(
        color: kSecondaryColor,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        hintText: "Enter phone Number",
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
