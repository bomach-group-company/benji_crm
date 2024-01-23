// ignore_for_file: unused_field

import 'package:benji_aggregator/model/business_order_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../providers/constants.dart';

class VendorsOrderContainer extends StatelessWidget {
  final BusinessOrderModel order;
  const VendorsOrderContainer({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    int qty = 0;
    final media = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: kDefaultPadding / 2,
      ),
      padding: const EdgeInsets.only(
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding / 2,
        left: kDefaultPadding / 2,
        right: kDefaultPadding / 2,
      ),
      width: media.width / 1.1,
      // height: 150,
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
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: kPageSkeletonColor,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage(
                      "assets/images/vendors/ntachi-osa.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: order.client.image ?? "",
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const Center(
                          child: CupertinoActivityIndicator(
                    color: kRedColor,
                  )),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: kRedColor,
                  ),
                ),
              ),
              kHalfSizedBox,
              SizedBox(
                width: 60,
                child: Text(
                  "#${order.code}",
                  style: TextStyle(
                    color: kTextGreyColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
          kWidthSizedBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: media.width * 0.6 - 2,
                // color: kAccentColor,
                child: const Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Text(
                        "Hot Kitchen",
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      child: Text(
                        'created date',
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              kHalfSizedBox,
              Container(
                color: kTransparentColor,
                width: 150,
                child: const Text(
                  'order id or name etc.',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              kHalfSizedBox,
              Container(
                width: 150,
                color: kTransparentColor,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "x $qty",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const TextSpan(text: "  "),
                      TextSpan(
                        text:
                            "₦ ${convertToCurrency(order.totalPrice.toString())}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'sen',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              kHalfSizedBox,
              Container(
                color: kLightGreyColor,
                height: 1,
                width: media.width * 0.5,
              ),
              kHalfSizedBox,
              SizedBox(
                width: media.width * 0.5,
                child: Text(
                  "${order.client.lastName} ${order.client.firstName}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: media.width * 0.5,
                child: const Text(
                  'address',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
