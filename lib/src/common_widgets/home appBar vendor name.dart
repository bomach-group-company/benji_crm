// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class AppBarVendor extends StatelessWidget {
  final String vendorLocation;
  final String vendorName;
  const AppBarVendor({
    super.key,
    required this.vendorLocation,
    required this.vendorName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 130,
                child: Text(
                  vendorName.toUpperCase(),
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: kAccentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Text(
            vendorLocation,
            style: const TextStyle(
              color: Color(
                0xFF676767,
              ),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
