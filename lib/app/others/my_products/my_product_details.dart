// ignore_for_file: file_names, prefer_typing_uninitialized_variables, use_build_context_synchronously, unused_field

import 'package:benji_aggregator/src/components/my_elevatedButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:readmore/readmore.dart';

import '../../../src/components/my_appbar.dart';
import '../../../src/components/my_textformfield2.dart';
import '../../../src/components/showModalBottomSheetTitleWithIcon.dart';
import '../../../src/providers/constants.dart';
import '../../../src/skeletons/product_details_page_skeleton.dart';
import '../../../theme/colors.dart';

class MyProductDetails extends StatefulWidget {
  final String productImage;
  final String productName;
  final String productDescription;
  final double productPrice;

  const MyProductDetails(
      {super.key,
      required this.productImage,
      required this.productName,
      required this.productDescription,
      required this.productPrice});

  @override
  State<MyProductDetails> createState() => _MyProductDetailsState();
}

class _MyProductDetailsState extends State<MyProductDetails> {
  //=================================== ALL VARIABLES ==========================================\\
  late bool _loadingScreen;
  bool _isChecked = false;

  //======================================= KEYS ==========================================\\
  final GlobalKey<FormState> _updateQuantityKey = GlobalKey();

  //======================================= CONTROLLERS ==========================================\\
  final ScrollController scrollController = ScrollController();
  final _updateQuantityEC = TextEditingController();

  //======================================= FOCUS NODES ==========================================\\
  final _updateQuantityFN = FocusNode();

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

  // void _changeProductCategory() {}

  //Edit product details
  void _editProductDetails() {}

  //Delete product
  void _deleteProduct() {}

  //Save Updated Quantity
  void _saveUpdatedQuantity() => Get.back();

  //Update quantity
  void _updateQuantity() {
    // Get.back();
    showModalBottomSheet(
      context: context,
      backgroundColor: kPrimaryColor,
      barrierColor: kBlackColor.withOpacity(0.5),
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      elevation: 20.0,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(kDefaultPadding))),
      enableDrag: true,
      builder: (context) => SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ShowModalBottomSheetTitleWithIcon(title: "Update Quantity"),
            const SizedBox(height: kDefaultPadding * 2),
            Form(
              key: _updateQuantityKey,
              child: Column(
                children: [
                  Text(
                    'Quantity',
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            kSizedBox,
            MyTextFormField2(
              controller: _updateQuantityEC,
              textInputAction: TextInputAction.done,
              focusNode: _updateQuantityFN,
              hintText: "Enter quantity here",
              textInputType: TextInputType.number,
              validator: (value) {
                return null;
              },
              onSaved: (value) {},
            ),
            kSizedBox,
            Text(
              'Current qty: 230',
              style: TextStyle(
                color: kTextGreyColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            kSizedBox,
            MyElevatedButton(
              onPressed: _saveUpdatedQuantity,
              title: "Save",
            ),
            kSizedBox,
          ],
        ),
      ),
    );
  }

  void _editProduct() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kPrimaryColor,
      barrierColor: kBlackColor.withOpacity(0.5),
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      elevation: 20.0,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(kDefaultPadding))),
      enableDrag: true,
      builder: (context) => SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ShowModalBottomSheetTitleWithIcon(title: "Option"),
            const SizedBox(height: kDefaultPadding * 2),
            ListTile(
              onTap: _updateQuantity,
              leading: Icon(
                FontAwesomeIcons.boxesStacked,
                color: kAccentColor,
                size: 16,
              ),
              title: Text(
                'Update quantity',
                style: TextStyle(
                  color: kTextGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.32,
                ),
              ),
            ),
            ListTile(
              onTap: _editProductDetails,
              leading: Icon(
                Icons.edit,
                color: kAccentColor,
                size: 16,
              ),
              title: Text(
                'Edit',
                style: TextStyle(
                  color: kTextGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.32,
                ),
              ),
            ),
            ListTile(
              onTap: _deleteProduct,
              leading: Icon(
                Icons.delete,
                color: kAccentColor,
                size: 16,
              ),
              title: Text(
                'Delete',
                style: TextStyle(
                  color: kTextGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          actions: [
            IconButton(
              onPressed: _editProduct,
              icon: Icon(
                Icons.more_vert,
                color: kAccentColor,
              ),
            ),
          ],
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
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      "assets/images/products/${widget.productImage}.png"),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.6),
                                    blurRadius: 8,
                                    spreadRadius: 4,
                                    blurStyle: BlurStyle.normal,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: mediaHeight,
                              width: mediaWidth,
                              // color: kAccentColor,
                              padding: const EdgeInsets.all(kDefaultPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.productName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "₦ ${widget.productPrice.toStringAsFixed(2)}",
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
                                  ReadMoreText(
                                    widget.productDescription,
                                    callback: (val) {},
                                    delimiter: "...",
                                    trimMode: TrimMode.Line,
                                    textAlign: TextAlign.justify,
                                    trimLines: 5,
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
                                    delimiterStyle: TextStyle(
                                      color: kAccentColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    colorClickableText: kAccentColor,
                                  ),
                                  kSizedBox,
                                  SizedBox(
                                    height: 17,
                                    child: Text(
                                      'Qty: 3200',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: kTextGreyColor,
                                        fontSize: 13.60,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  kSizedBox,
                                  Row(
                                    children: [
                                      const Text(
                                        'Out of stock',
                                        style: TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Checkbox(
                                        value: _isChecked,
                                        splashRadius: 50,
                                        activeColor: kAccentColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        onChanged: (newValue) {
                                          setState(() {
                                            _isChecked = newValue!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  kSizedBox,
                                ],
                              ),
                            ),
                          ],
                        );
                }),
          ),
        ),
      ),
    );
  }
}
