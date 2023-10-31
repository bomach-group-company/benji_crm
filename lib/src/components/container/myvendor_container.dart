// ignore_for_file: file_names

import 'package:benji_aggregator/model/my_vendor.dart';
import 'package:flutter/material.dart';

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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
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
                image: const DecorationImage(
                  image: AssetImage(
                    "assets/images/products/pasta.png",
                  ),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            kHalfWidthSizedBox,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    vendor.shopName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.36,
                    ),
                  ),
                ),
                kSizedBox,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      vendor.shopType.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0x662F2E3C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                kSizedBox,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(
                        Icons.star_rounded,
                        color: kAccentColor,
                      ),
                    ),
                    const SizedBox(
                      width: kDefaultPadding / 2,
                    ),
                    Container(
                      width: 81,
                      height: 19,
                      padding: const EdgeInsets.only(
                        top: 4,
                      ),
                      child: Text(
                        "${vendor.averageRating} (${vendor.numberOfClientsReactions}+)",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
