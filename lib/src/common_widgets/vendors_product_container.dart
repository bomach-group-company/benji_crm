// ignore_for_file: file_names, unused_local_variable

import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class VendorsProductContainer extends StatefulWidget {
  final Function() onTap;
  const VendorsProductContainer({
    super.key,
    required this.onTap,
  });

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
        margin: const EdgeInsets.symmetric(
          vertical: kDefaultPadding / 3,
          horizontal: kDefaultPadding,
        ),
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
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      12,
                    ),
                    bottomLeft: Radius.circular(
                      12,
                    ),
                  ),
                ),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/productspasta.png",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            kHalfWidthSizedBox,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Smokey Jollof Pasta',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                kHalfSizedBox,
                SizedBox(
                  width: mediaWidth / 2,
                  child: const Text(
                    'Short description about the food here',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(
                        0xFF676565,
                      ),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                kHalfSizedBox,
                const SizedBox(
                  child: Text(
                    '₦1200.00',
                    style: TextStyle(
                      color: Color(
                        0xFF333333,
                      ),
                      fontSize: 14,
                      fontFamily: 'Sen',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
