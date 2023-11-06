import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/colors.dart';

class BankListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String bank;
  final String bankImage;
  const BankListTile({
    super.key,
    required this.onTap,
    required this.bank,
    required this.bankImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          horizontalTitleGap: 0,
          leading: bankImage.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    backgroundColor: kLightGreyColor,
                    child: FaIcon(
                      FontAwesomeIcons.buildingColumns,
                      color: kAccentColor,
                      size: 18,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    backgroundColor: kLightGreyColor,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: bankImage,
                        fit: BoxFit.fill,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child:
                              CupertinoActivityIndicator(color: kAccentColor),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error, color: kAccentColor),
                      ),
                    ),
                  ),
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
