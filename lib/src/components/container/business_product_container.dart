// ignore_for_file: file_names, unused_local_variable

import 'package:benji_aggregator/model/product_model.dart';
import 'package:benji_aggregator/src/components/image/my_image.dart';
import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

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
              width: deviceType(media.width) >= 2 ? 150 : 100,
              height: deviceType(media.width) >= 2 ? 150 : 100,
              decoration: ShapeDecoration(
                color: kPageSkeletonColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MyImage(url: widget.product.productImage)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
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
                    Text(
                      widget.product.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: kTextGreyColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    kHalfSizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₦${convertToCurrency(widget.product.price.toString())}',
                          style: const TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14,
                            fontFamily: 'Sen',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          // width: (media.width - 110) / 3,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
