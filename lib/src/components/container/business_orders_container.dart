// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/business_order_model.dart';
import '../../../theme/colors.dart';
import '../../utils/constants.dart';
import '../image/my_image.dart';

class BusinessOrderContainer extends StatelessWidget {
  final BusinessOrderModel order;
  const BusinessOrderContainer({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
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
                  color: kLightGreyColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: MyImage(
                  url: order.client.image,
                ),
              ),
              kHalfSizedBox,
              SizedBox(
                width: 60,
                child: Text(
                  "#${order.code}",
                  maxLines: 2,
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
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: media.width - 300,
                    // color: kAccentColor,
                    child: Text(
                      order.deliveryStatus == "CANC"
                          ? "Cancelled"
                          : order.deliveryStatus == "dispatched"
                              ? "Dispatched"
                              : order.deliveryStatus == "PEND"
                                  ? "Pending"
                                  : "Completed",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: order.deliveryStatus == "CANC"
                            ? kAccentColor
                            : order.deliveryStatus == "dispatched"
                                ? kSecondaryColor
                                : order.deliveryStatus == "PEND"
                                    ? kLoadingColor
                                    : kSuccessColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    order.created,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              kHalfSizedBox,
              SizedBox(
                width: media.width - 260,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "₦ ${convertToCurrency(order.preTotal.toString())}",
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
                  color: kLightGreyColor, height: 2, width: media.width - 160),
              kHalfSizedBox,
              SizedBox(
                width: media.width - 260,
                child: Text(
                  "${order.client.firstName} ${order.client.lastName}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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
