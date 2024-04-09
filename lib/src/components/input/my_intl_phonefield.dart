// ignore_for_file: file_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../theme/colors.dart';
import '../../utils/constants.dart';

class MyIntlPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String initialCountryCode;
  final String invalidNumberMessage;
  final IconPosition dropdownIconPosition;
  final bool showCountryFlag;
  final bool showDropdownIcon;
  final dynamic dropdownIcon;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final dynamic onSaved;
  final dynamic validator;
  final bool? enabled;
  const MyIntlPhoneField({
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
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      enabled: enabled ?? true,
      initialCountryCode: initialCountryCode,
      invalidNumberMessage: invalidNumberMessage,
      dropdownIconPosition: dropdownIconPosition,
      showCountryFlag: showCountryFlag,
      keyboardType: TextInputType.number,
      showDropdownIcon: showDropdownIcon,
      dropdownIcon: dropdownIcon,
      textInputAction: textInputAction,
      focusNode: focusNode,
      validator: validator,
      onSaved: onSaved,
      flagsButtonPadding: const EdgeInsets.all(
        kDefaultPadding / 2,
      ),
      cursorColor: kSecondaryColor,
      onChanged: (phone) {
        print(phone.completeNumber);
      },
      onCountryChanged: (country) {
        print('Country changed to: ' + country.name);
      },
      decoration: InputDecoration(
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
