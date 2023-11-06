// ignore_for_file: file_names

import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../theme/colors.dart';
import '../../../services/helper.dart';
import '../../providers/constants.dart';

class AvailableBalanceCard extends StatefulWidget {
  final String availableBalance;
  const AvailableBalanceCard({
    super.key,
    required this.availableBalance,
  });

  @override
  State<AvailableBalanceCard> createState() => _AvailableBalanceCardState();
}

class _AvailableBalanceCardState extends State<AvailableBalanceCard> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      width: media.width,
      height: deviceType(media.width) >= 2 ? 200 : 140,
      decoration: ShapeDecoration(
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 24,
            offset: Offset(0, 4),
            spreadRadius: 4,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Available Balance',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: kTextBlackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    setRememberBalance(!rememberBalance());
                  });
                },
                icon: rememberBalance()
                    ? FaIcon(FontAwesomeIcons.solidEye, color: kAccentColor)
                    : const FaIcon(
                        FontAwesomeIcons.solidEyeSlash,
                        color: kGreyColor1,
                      ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: media.width - 200,
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "₦ ",
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 30,
                        fontFamily: 'sen',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: rememberBalance()
                          ? widget.availableBalance
                          : 'XXXXXXX',
                      style: TextStyle(
                        color: kAccentColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
