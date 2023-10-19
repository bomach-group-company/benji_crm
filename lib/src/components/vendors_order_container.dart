// ignore_for_file: unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/operation.dart';
import '../../model/vendor_orders_model.dart';
import '../../theme/colors.dart';
import '../providers/constants.dart';

class VendorsOrderContainer extends StatelessWidget {
  const VendorsOrderContainer(
      {super.key,
      required this.mediaWidth,
      required String orderImage,
      required int orderID,
      required this.formattedDateAndTime,
      required String orderItem,
      required int itemQuantity,
      required double itemPrice,
      required String customerName,
      required String customerAddress,
      required this.order})
      : _orderImage = orderImage,
        _orderID = orderID,
        _orderItem = orderItem,
        _itemQuantity = itemQuantity,
        _itemPrice = itemPrice,
        _customerName = customerName,
        _customerAddress = customerAddress;

  final double mediaWidth;
  final String _orderImage;
  final int _orderID;
  final String formattedDateAndTime;
  final String _orderItem;
  final int _itemQuantity;
  final double _itemPrice;
  final String _customerName;
  final String _customerAddress;
  final DataItem? order;
  @override
  Widget build(BuildContext context) {
    int qty = 0;
    if (order != null) {
      for (var element in order!.orderitems!) {
        qty += int.tryParse(element.quantity!.toString())!;
      }
    }
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
      width: mediaWidth / 1.1,
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
                  // image: DecorationImage(
                  //   image: AssetImage(
                  //     "assets/images/products/$_orderImage.png",
                  //   ),
                  // ),
                ),
                child: CachedNetworkImage(
                  imageUrl: order!.client!.image ?? "",
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
                  "#00${order!.id ?? ""}",
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
                width: mediaWidth * 0.6 - 2,
                // color: kAccentColor,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    const SizedBox(
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
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      child: Text(
                        Operation.convertDate(order!.created!),
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
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
                child: Text(
                  _orderItem,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
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
                            "₦ ${convertToCurrency(order == null ? "0.0" : order!.totalPrice!.toString())}",
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
                width: mediaWidth * 0.5,
              ),
              kHalfSizedBox,
              SizedBox(
                width: mediaWidth * 0.5,
                child: Text(
                  "${order!.client!.lastName!} ${order!.client!.firstName!}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: mediaWidth * 0.5,
                child: Text(
                  order!.deliveryAddress!.streetAddress!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
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
