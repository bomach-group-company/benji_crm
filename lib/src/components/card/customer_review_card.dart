import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../providers/constants.dart';

class CostumerReviewCard extends StatelessWidget {
  const CostumerReviewCard({
    super.key,
    required this.mediaWidth,
  });

  final double mediaWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediaWidth,
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: ShapeDecoration(
        color: const Color(0xFFFEF8F8),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 0.50,
            color: Color(0xFFFDEDED),
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 24,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: const ShapeDecoration(
                  shape: OvalBorder(),
                  image: DecorationImage(
                    image: AssetImage('assets/images/customer/ebuka_henry.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              kHalfWidthSizedBox,
              const Text(
                'Ebuka Henry',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF131514),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
          kSizedBox,
          Text(
            'Their meals are on point, and their response time is encouraging.',
            style: TextStyle(
              color: kTextGreyColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          kSizedBox,
          Row(
            children: [
              Icon(
                Icons.star,
                size: 20,
                color: kStarColor,
              ),
              kHalfWidthSizedBox,
              Text(
                '5.0 Ratings',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: kTextGreyColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
