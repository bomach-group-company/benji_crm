import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/colors.dart';

class BankListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String bank;
  const BankListTile({
    super.key,
    required this.onTap,
    required this.bank,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          horizontalTitleGap: 0,
          leading: FaIcon(
            FontAwesomeIcons.buildingColumns,
            color: kAccentColor,
            size: 18,
          ),
          title: Text(
            bank,
            style: const TextStyle(
              color: kTextBlackColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Divider(
          height: 2,
          thickness: 2,
          color: kLightGreyColor,
        ),
      ],
    );
  }
}
