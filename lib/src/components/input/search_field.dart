// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class SearchField extends StatelessWidget {
  final Function() onTap;
  const SearchField({
    super.key,
    required this.searchController,
    required this.hintText,
    required this.onTap,
  });

  final String hintText;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // onSubmitted: ,
      onTap: onTap,
      controller: searchController,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      enableSuggestions: true,
      autocorrect: true,

      cursorColor: kSecondaryColor,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(
            0x662F2E3C,
          ),
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 30,
        ),
        prefixIconColor: const Color(
          0x662F2E3C,
        ),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.filter_list,
            color: kAccentColor,
          ),
        ),
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
      ),
    );
  }
}
