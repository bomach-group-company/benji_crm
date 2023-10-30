// ignore_for_file: file_names, prefer_typing_uninitialized_variables, use_build_context_synchronously, unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:readmore/readmore.dart';

import '../../model/vendor_product_model.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/providers/constants.dart';
import '../../src/skeletons/product_details_page_skeleton.dart';
import '../../theme/colors.dart';

class ProductDetails extends StatefulWidget {
  final String productImage;
  final String productName;
  final String productDescription;
  final double productPrice;
  final Item? product;

  const ProductDetails(
      {super.key,
      required this.productImage,
      required this.productName,
      required this.productDescription,
      required this.productPrice,
      required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  //=================================== ALL VARIABLES ==========================================\\
  late bool _loadingScreen;

  //======================================= CONTROLLERS ==========================================\\
  final ScrollController scrollController = ScrollController();

  //======================================= FUNCTIONS ==========================================\\
  @override
  void initState() {
    super.initState();

    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _loadingScreen = false;
    });
  }

  //===================== Navigation ==========================\\

  // void _toSimilarProductsPage() => Get.to(
  //       () => const SimilarProductsPage(),
  //       duration: const Duration(milliseconds: 300),
  //       fullscreenDialog: true,
  //       curve: Curves.easeIn,
  //       routeName: "Similar Products",
  //       preventDuplicates: true,
  //       popGesture: true,
  //       transition: Transition.rightToLeft,
  //     );
  // void _toVendorsProductsPage() => Get.to(
  //       () => const VendorsProductsPage(),
  //       duration: const Duration(milliseconds: 300),
  //       fullscreenDialog: true,
  //       curve: Curves.easeIn,
  //       routeName: "Vendors Products",
  //       preventDuplicates: true,
  //       popGesture: true,
  //       transition: Transition.rightToLeft,
  //     );
//===========================================================================\\

  @override
  Widget build(BuildContext context) {
    double mediaHeight = MediaQuery.of(context).size.height;
    double mediaWidth = MediaQuery.of(context).size.width;

    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: kAccentColor,
      borderWidth: 5.0,
      backgroundColor: kPrimaryColor,
      height: 150,
      animSpeedFactor: 2,
      showChildOpacityTransition: false,
      child: Scaffold(
        appBar: MyAppBar(
          title: "Product Details",
          elevation: 10.0,
          backgroundColor: kPrimaryColor,
          actions: const [],
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: kPrimaryColor,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            controller: scrollController,
            radius: const Radius.circular(10),
            scrollbarOrientation: ScrollbarOrientation.right,
            child: FutureBuilder(
              future: null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  Center(child: SpinKitDoubleBounce(color: kAccentColor));
                }
                if (snapshot.connectionState == ConnectionState.none) {
                  const Center(
                    child: Text("Please connect to the internet"),
                  );
                }
                // if (snapshot.connectionState == snapshot.requireData) {
                //   SpinKitDoubleBounce(color: kAccentColor);
                // }
                if (snapshot.connectionState == snapshot.error) {
                  const Center(
                    child: Text("Error, Please try again later"),
                  );
                }
                return _loadingScreen
                    ? const ProductDetailsPageSkeleton()
                    // ? Center(child: SpinKitDoubleBounce(color: kAccentColor))
                    : ListView(
                        physics: const BouncingScrollPhysics(),
                        dragStartBehavior: DragStartBehavior.down,
                        children: [
                          Container(
                            height: mediaHeight * 0.4,
                            decoration: ShapeDecoration(
                              color: kPageSkeletonColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                              ),

                              // image: DecorationImage(
                              //   fit: BoxFit.fill,
                              //   image: AssetImage(
                              //       "assets/images/products/${widget.productImage}.png"),
                              // ),

                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.6),
                                  blurRadius: 8,
                                  spreadRadius: 4,
                                  blurStyle: BlurStyle.normal,
                                ),
                              ],
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.product!.productImage ?? "",
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
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
                          Container(
                            width: mediaWidth,
                            padding: const EdgeInsets.all(kDefaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.product!.name ?? "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: kTextBlackColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "₦ ${convertToCurrency(widget.product!.price.toString())}",
                                      style: const TextStyle(
                                        color: kTextBlackColor,
                                        fontSize: 22,
                                        fontFamily: 'sen',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                kSizedBox,
                                const Text(
                                  "Description",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                kHalfSizedBox,
                                ReadMoreText(
                                  widget.product!.description ?? "",
                                  callback: (val) {},
                                  delimiter: "...",
                                  trimLines: 10,
                                  trimExpandedText: "...show less",
                                  style: TextStyle(
                                    color: kTextGreyColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  moreStyle: TextStyle(
                                    color: kAccentColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  lessStyle: TextStyle(
                                    color: kAccentColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                //   kSizedBox,
                                //   const Text(
                                //     "Description",
                                //     textAlign: TextAlign.start,
                                //     style: TextStyle(
                                //       color: kTextBlackColor,
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.w700,
                                //     ),
                                //   ),
                                //   colorClickableText: kAccentColor,
                                // ),
                                // kSizedBox,
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     const Text(
                                //       "Similar products",
                                //       textAlign: TextAlign.start,
                                //       style: TextStyle(
                                //         color: kTextBlackColor,
                                //         fontSize: 18,
                                //         fontWeight: FontWeight.w700,
                                //       ),
                                //     ),
                                //     TextButton(
                                //       onPressed: _toSimilarProductsPage,
                                //       child: Text(
                                //         "See all",
                                //         style: TextStyle(
                                //           color: kAccentColor,
                                //           fontSize: 18,
                                //           fontWeight: FontWeight.w700,
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // kSizedBox,
                                // SizedBox(
                                //   height: 160,
                                //   child: ListView.separated(
                                //     scrollDirection: Axis.horizontal,
                                //     physics: const BouncingScrollPhysics(),
                                //     separatorBuilder: (context, index) =>
                                //         const SizedBox(
                                //       width: kDefaultPadding / 2,
                                //     ),
                                //     itemBuilder: (context, index) => InkWell(
                                //       onTap: () {},
                                //       child: Shimmer.fromColors(
                                //         highlightColor:
                                //             kBlackColor.withOpacity(0.02),
                                //         baseColor: kBlackColor.withOpacity(0.8),
                                //         direction: ShimmerDirection.ltr,
                                //         child: const PageSkeleton(
                                //           height: 160,
                                //           width: 140,
                                //         ),
                                //       ),
                                //     ),
                                //     itemCount: 30,
                                //   ),
                                // ),
                                // kSizedBox,
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     const Text(
                                //       "Vendors Products",
                                //       textAlign: TextAlign.start,
                                //       style: TextStyle(
                                //         color: kTextBlackColor,
                                //         fontSize: 18,
                                //         fontWeight: FontWeight.w700,
                                //       ),
                                //     ),
                                //     TextButton(
                                //       onPressed: _toVendorsProductsPage,
                                //       child: Text(
                                //         "See all",
                                //         style: TextStyle(
                                //           color: kAccentColor,
                                //           fontSize: 18,
                                //           fontWeight: FontWeight.w700,
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // kSizedBox,
                                // SizedBox(
                                //   height: 160,
                                //   child: ListView.separated(
                                //     scrollDirection: Axis.horizontal,
                                //     physics: const BouncingScrollPhysics(),
                                //     separatorBuilder: (context, index) =>
                                //         const SizedBox(
                                //       width: kDefaultPadding / 2,
                                //     ),
                                //     itemBuilder: (context, index) => InkWell(
                                //       onTap: () {},
                                //       child: Shimmer.fromColors(
                                //         highlightColor:
                                //             kBlackColor.withOpacity(0.02),
                                //         baseColor: kBlackColor.withOpacity(0.8),
                                //         direction: ShimmerDirection.ltr,
                                //         child: const PageSkeleton(
                                //           height: 160,
                                //           width: 140,
                                //         ),
                                //       ),
                                //     ),
                                //     itemCount: 30,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
