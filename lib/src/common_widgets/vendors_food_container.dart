// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';
import 'my_floating_snackbar.dart';

class VendorFoodContainer extends StatefulWidget {
  final Function() onTap;
  const VendorFoodContainer({
    super.key,
    required this.onTap,
  });

  @override
  State<VendorFoodContainer> createState() => _VendorFoodContainerState();
}

class _VendorFoodContainerState extends State<VendorFoodContainer> {
  //======================================= ALL VARIABLES ==========================================\\

  int quantity = 1;

  //======================================= FUNCTIONS ==========================================\\

  void incrementQuantity() {
    setState(() {
      quantity++; // Increment the quantity by 1
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--; // Decrement the quantity by 1, but ensure it doesn't go below 1
      } else {
        cartFunction();
      }
    });
  }

  bool isAddedToCart = false;

  void cartFunction() {
    setState(() {
      isAddedToCart = !isAddedToCart;
    });

    mySnackBar(
      context,
      "Success!",
      isAddedToCart ? "Item has been added to cart." : "Item has been removed.",
      const Duration(
        seconds: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    // double mediaHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: kDefaultPadding / 2.5,
        ),
        width: MediaQuery.of(context).size.width,
        decoration: ShapeDecoration(
          color: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          shadows: const [
            BoxShadow(
              color: Color(
                0x0F000000,
              ),
              blurRadius: 24,
              offset: Offset(
                0,
                4,
              ),
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
                    "assets/images/food/pasta.png",
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
                    color: Color(
                      0xFF333333,
                    ),
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
            isAddedToCart
                ? Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          decrementQuantity();
                        },
                        icon: Icon(
                          Icons.remove_circle,
                          color: kAccentColor,
                          size: 30,
                        ),
                      ),
                      Text(
                        "$quantity",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          incrementQuantity();
                        },
                        icon: Icon(
                          Icons.add_circle_rounded,
                          color: kAccentColor,
                          size: 30,
                        ),
                      ),
                    ],
                  )
                : IconButton(
                    onPressed: () {
                      cartFunction();
                    },
                    icon: Icon(
                      Icons.add_circle_rounded,
                      color: kAccentColor,
                      size: 30,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
