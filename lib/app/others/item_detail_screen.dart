// ignore_for_file: file_names, prefer_typing_uninitialized_variables, use_build_context_synchronously, unused_field

import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../src/common_widgets/category_button_section.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  //=================================== ALL VARIABLES ==========================================\\
  double itemPrice = 2500;
  late bool _loadingScreen;

  //======================================= FUNCTIONS ==========================================\\
  @override
  void initState() {
    _loadingScreen = true;
    Future.delayed(
      const Duration(seconds: 3),
      () => setState(
        () => _loadingScreen = false,
      ),
    );

    super.initState();
  }

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _loadingScreen = false;
    });
  }

  //===================== CATEGORY BUTTONS =======================\\
  final List _proteinCategoryButtonText = [
    "Beef (+N2,000)",
    "Goat meat (+N700)",
    "Fish (+N700)",
    "Chicken (+N2,500)",
    "Pork (+N800)",
  ];

  final List<Color> _proteinCategoryButtonBgColor = [
    kAccentColor,
    kDefaultCategoryBackgroundColor,
    kDefaultCategoryBackgroundColor,
    kDefaultCategoryBackgroundColor,
    kDefaultCategoryBackgroundColor
  ];
  final List<Color> _proteincategoryButtonFontColor = [
    kPrimaryColor,
    kTextGreyColor,
    kTextGreyColor,
    kTextGreyColor,
    kTextGreyColor,
  ];
  final List _stewTypeCategoryButtonText = [
    "Tomato (+N250)",
    "Ofe Akwu (+N0)",
    "Chicken Sauce  (+N4000)",
    "Egg Sauce(+N2,500)",
    "Curry Sauce (+N2,000)",
  ];

  final List<Color> _stewTypeCategoryButtonBgColor = [
    kAccentColor,
    kDefaultCategoryBackgroundColor,
    kDefaultCategoryBackgroundColor,
    kDefaultCategoryBackgroundColor,
    kDefaultCategoryBackgroundColor,
  ];
  final List<Color> _stewTypeCategoryButtonFontColor = [
    kPrimaryColor,
    kTextGreyColor,
    kTextGreyColor,
    kTextGreyColor,
    kTextGreyColor,
  ];

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
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: kPrimaryColor.withOpacity(0.6),
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: kPrimaryColor,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: mediaHeight * 0.3,
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/products/pasta.png"),
                  ),
                ),
              ),
            ),
            Positioned(
              top: mediaHeight * 0.35,
              left: kDefaultPadding,
              right: kDefaultPadding,
              child: Container(
                height: mediaHeight - 220,
                width: mediaWidth,
                // color: kAccentColor,
                padding: const EdgeInsets.all(5.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Smokey Jollof Rice",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF302F3C),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "₦ ${itemPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 22,
                              fontFamily: 'sen',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      kSizedBox,
                      const Text(
                        "This is a short description about the food you mentoned which is a restaurant food in this case.",
                        style: TextStyle(
                          color: Color(0xFF676565),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: kDefaultPadding,
                          bottom: kDefaultPadding / 2,
                        ),
                        child: const Text(
                          "Protein",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF302F3C),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      CategoryButtonSection(
                        onPressed: () {},
                        category: _proteinCategoryButtonText,
                        categorybgColor: _proteinCategoryButtonBgColor,
                        categoryFontColor: _proteincategoryButtonFontColor,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: kDefaultPadding,
                          bottom: kDefaultPadding / 2,
                        ),
                        child: const Text(
                          "Stew Type",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF302F3C),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      CategoryButtonSection(
                        onPressed: () {},
                        category: _stewTypeCategoryButtonText,
                        categorybgColor: _stewTypeCategoryButtonBgColor,
                        categoryFontColor: _stewTypeCategoryButtonFontColor,
                      ),
                      kSizedBox,
                      // const SizedBox(height: kDefaultPadding * 3),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
