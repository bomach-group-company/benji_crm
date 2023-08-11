// ignore_for_file: file_names

import 'package:benji_aggregator/app/others/successful_screen.dart';
import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class ProfileFirstHalf extends StatelessWidget {
  final String availableBalance;
  const ProfileFirstHalf({
    super.key,
    required this.availableBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: kDefaultPadding * 2,
      ),
      decoration: ShapeDecoration(
        color: kAccentColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(
              25,
            ),
            bottomRight: Radius.circular(
              25,
            ),
          ),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              'Available Balance',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            kSizedBox,
            Text(
              '₦$availableBalance',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 40,
                fontFamily: 'Sen',
                fontWeight: FontWeight.w700,
              ),
            ),
            kSizedBox,
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SuccessfulScreen(
                      text: "Withdraw Successful",
                      elevatedButtonTitle: "Ok",
                    ),
                  ),
                );
              },
              child: Container(
                width: 100,
                height: 37,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.50,
                      color: kPrimaryColor,
                    ),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Withdraw',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: kDefaultPadding * 2,
            ),
          ],
        ),
      ),
    );
  }
}
