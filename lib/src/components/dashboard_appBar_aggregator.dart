// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class AppBarAggregator extends StatelessWidget {
  final String aggregatorName;
  final String title;
  const AppBarAggregator({
    super.key,
    required this.aggregatorName,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: kAccentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(
            width: media.width - 250,
            child: Text(
              aggregatorName,
              style: const TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
