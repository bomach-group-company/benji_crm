// ignore_for_file: file_names

import 'package:benji_aggregator/model/my_vendor_model.dart';
import 'package:benji_aggregator/src/components/image/my_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/colors.dart';
import '../../providers/constants.dart';

class MyVendorContainer extends StatelessWidget {
  final Function() onTap;
  final MyVendorModel vendor;
  const MyVendorContainer({
    super.key,
    required this.onTap,
    required this.vendor,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: ShapeDecoration(
          color: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: ShapeDecoration(
                color: kGreyColor1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: MyImage(url: vendor.profileLogo),
            ),
            kHalfWidthSizedBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: media.width - 200,
                  child: Text(
                    "${vendor.firstName} ${vendor.lastName}",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kTextBlackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                kHalfSizedBox,
                SizedBox(
                  width: media.width - 200,
                  child: Text(
                    vendor.email,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: kAccentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                kSizedBox,
                SizedBox(
                  width: media.width - 250,
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.shop,
                        color: kAccentColor,
                        size: 16,
                      ),
                      kHalfWidthSizedBox,
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: " ",
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            TextSpan(
                              text: "Businesses",
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Text(
                //       vendor.shopType.name,
                //       textAlign: TextAlign.center,
                //       style: const TextStyle(
                //         color: Color(0x662F2E3C),
                //         fontSize: 14,
                //         fontWeight: FontWeight.w400,
                //       ),
                //     ),
                //   ],
                // ),
                // kSizedBox,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     FaIcon(
                //       FontAwesomeIcons.solidStar,
                //       color: kStarColor,
                //       size: 18,
                //     ),
                //     const SizedBox(width: kDefaultPadding / 2),
                //     SizedBox(
                //       width: media.width - 250,
                //       child: Text(
                //         "${vendor.averageRating} (${vendor.numberOfClientsReactions}+)",
                //         style: const TextStyle(
                //           color: kTextBlackColor,
                //           fontSize: 15,
                //           fontWeight: FontWeight.w400,
                //           letterSpacing: -0.24,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
