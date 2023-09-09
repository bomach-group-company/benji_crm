// ignore_for_file: file_names, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../model/vendor_product_model.dart';
import '../../theme/colors.dart';
import '../providers/constants.dart';

class VendorsProductContainer extends StatefulWidget {
  final Function() onTap;
  final String productImage;
  final String productName;
  final String productDescription;
  final double productPrice;
  final String productQuantity;
  final Item? product;

  const VendorsProductContainer(
      {super.key,
      required this.onTap,
      required this.productImage,
      required this.productName,
      required this.productDescription,
      required this.productPrice,
      required this.productQuantity,
      required this.product});

  @override
  State<VendorsProductContainer> createState() =>
      _VendorsProductContainerState();
}

class _VendorsProductContainerState extends State<VendorsProductContainer> {
  //======================================= ALL VARIABLES ==========================================\\

  //======================================= FUNCTIONS ==========================================\\

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2.5),
        width: MediaQuery.of(context).size.width,
        decoration: ShapeDecoration(
          color: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 24,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 90,
              height: 92,
              decoration: ShapeDecoration(
                color: kPageSkeletonColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                // image: DecorationImage(
                //   image: AssetImage(
                //       "assets/images/products/${widget.productImage}.png"),
                //   fit: BoxFit.fill,
                // ),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.product!.productImage ?? "",
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CupertinoActivityIndicator(
                  color: kRedColor,
                )),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: kRedColor,
                ),
              ),
            ),
            kHalfWidthSizedBox,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product!.name ?? "",
                  style: const TextStyle(
                    color: kTextBlackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: mediaWidth / 2,
                  child: Text(
                    widget.product!.description ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                kHalfSizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: mediaWidth / 4,
                      child: Text(
                        '₦${convertToCurrency(widget.product!.price.toString())}',
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                          fontFamily: 'Sen',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: mediaWidth / 4,
                      height: 17,
                      child: Text(
                        'Qty: ${widget.product!.quantityAvailable}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: kTextGreyColor,
                          fontSize: 13.60,
                          fontWeight: FontWeight.w400,
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
