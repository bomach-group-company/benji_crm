import 'package:benji_aggregator/model/rating_model.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../providers/constants.dart';

class CostumerReviewCard extends StatelessWidget {
  final Ratings rating;
  const CostumerReviewCard({
    super.key,
    required this.rating,
  });

  String intToMonth(int monthNumber) {
    List<String> months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    if (monthNumber >= 1 && monthNumber <= 12) {
      return months[monthNumber];
    } else {
      throw Exception("Invalid month number");
    }
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

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
                    image:
                        AssetImage('assets/images/customers/ebuka_henry.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              kHalfWidthSizedBox,
              SizedBox(
                width: mediaWidth - 112 - 45,
                child: Text(
                  "${rating.client.firstName} ${rating.client.lastName}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Color(0xFF131514),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          ),
          kSizedBox,
          SizedBox(
            width: mediaWidth - 80,
            child: Text(
              rating.comment,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: TextStyle(
                color: kTextGreyColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          kSizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 20,
                    color: kStarColor,
                  ),
                  kHalfWidthSizedBox,
                  Text(
                    '${rating.ratingValue} Rating',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              Text(
                ' ${rating.created.day} ${intToMonth(rating.created.month)}, ${rating.created.year}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: kTextGreyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
