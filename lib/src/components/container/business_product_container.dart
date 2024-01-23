// ignore_for_file: file_names, unused_local_variable
import 'package:flutter/material.dart';

import '../../../model/product_model.dart';
import '../../../theme/colors.dart';
import '../../providers/constants.dart';
import '../../responsive/responsive_constant.dart';
import '../image/my_image.dart';

class BusinessProductContainer extends StatefulWidget {
  final Function() onTap;
  final ProductModel product;

  const BusinessProductContainer(
      {super.key, required this.onTap, required this.product});

  @override
  State<BusinessProductContainer> createState() =>
      _BusinessProductContainerState();
}

class _BusinessProductContainerState extends State<BusinessProductContainer> {
  //======================================= ALL VARIABLES ==========================================\\

  //======================================= F UNCTIONS ==========================================\\

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2.5),
        width: media.width,
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
              width: deviceType(media.width) >= 2
                  ? media.width - 250
                  : media.width - 300,
              height: deviceType(media.width) >= 2 ? 150 : 100,
              decoration: ShapeDecoration(
                color: kPageSkeletonColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: MyImage(url: widget.product.productImage),
            ),
            kHalfWidthSizedBox,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    color: kTextBlackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: media.width - 250,
                  child: Text(
                    widget.product.description,
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
                      width: media.width - 300,
                      child: Text(
                        '₦${convertToCurrency(widget.product.price.toString())}',
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                          fontFamily: 'Sen',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: media.width - 300,
                      child: Text(
                        'Qty: ${widget.product.quantityAvailable}',
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
