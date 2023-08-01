// ignore_for_file: unused_local_variable

import 'package:benji_aggregator/app/vendors/vendors%20detail.dart';
import 'package:benji_aggregator/src/common_widgets/my%20outlined%20elevatedButton.dart';
import 'package:benji_aggregator/src/common_widgets/vendors%20card.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/category button section.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/custom show search.dart';
import '../../theme/colors.dart';
import 'add vendor.dart';

class Vendors extends StatefulWidget {
  final Color appBarBackgroundColor;
  final Color appTitleColor;
  final Color appBarSearchIconColor;

  const Vendors(
      {super.key,
      required this.appBarBackgroundColor,
      required this.appTitleColor,
      required this.appBarSearchIconColor});

  @override
  State<Vendors> createState() => _VendorsState();
}

class _VendorsState extends State<Vendors> {
//============================================== ALL VARIABLES =================================================\\

  //===================== CATEGORY BUTTONS =======================\\
  final List _categoryButton = [
    "Food",
    "Drinks",
    "Groceries",
    "Pharmaceuticals",
    "Snacks",
  ];

  final List<Color> _categoryButtonBgColor = [
    kAccentColor,
    kDefaultCategoryBackgroundColor,
    kDefaultCategoryBackgroundColor,
    kDefaultCategoryBackgroundColor,
    kDefaultCategoryBackgroundColor,
  ];
  final List<Color> _categoryButtonFontColor = [
    kPrimaryColor,
    kTextGreyColor,
    kTextGreyColor,
    kTextGreyColor,
    kTextGreyColor,
  ];

//===================== POPULAR VENDORS =======================\\
  final List<int> popularVendorsIndex = [0, 1, 2, 3, 4];

  final List<String> popularVendorImage = [
    "best-choice-restaurant.png",
    "golden-toast.png",
    "best-choice-restaurant.png",
    "best-choice-restaurant.png",
    "best-choice-restaurant.png",
  ];
  final List<dynamic> popularVendorBannerColor = [
    kAccentColor,
    kTransparentColor,
    kAccentColor,
    kAccentColor,
    kAccentColor,
  ];
  final List<dynamic> popularVendorBannerText = [
    "Free Delivery",
    "",
    "Free Delivery",
    "Free Delivery",
    "Free Delivery",
  ];

  final List<String> popularVendorName = [
    "Best Choice restaurant",
    "Golden Toast",
    "Best Choice restaurant",
    "Best Choice restaurant",
    "Best Choice restaurant",
  ];

  final List<String> popularVendorFood = [
    "Food",
    "Traditional",
    "Food",
    "Food",
    "Food",
  ];

  final List<String> popularVendorCategory = [
    "Fast Food",
    "Continental",
    "Fast Food",
    "Fast Food",
    "Fast Food",
  ];
  final List<String> popularVendorRating = [
    "3.6",
    "3.6",
    "3.6",
    "3.6",
    "3.6",
  ];
  final List<String> popularVendorNoOfUsersRating = [
    "500",
    "500",
    "500",
    "500",
    "500",
  ];

//============================================== FUNCTIONS =================================================\\
  toAddVendorPage() => Get.to(
        () => const AddVendor(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Add vendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void toVendorDetailsPage() => Get.to(
        () => const VendorsDetailPage(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Add vendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void showSearchField() =>
      showSearch(context: context, delegate: CustomSearchDelegate());
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        backgroundColor: widget.appBarBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: Text(
            "All Vendors",
            style: TextStyle(
              fontSize: 20,
              color: widget.appTitleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: showSearchField,
            tooltip: "Search",
            icon: Icon(
              Icons.search_rounded,
              color: widget.appBarSearchIconColor,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: MyOutlinedElevatedButton(
              onPressed: toAddVendorPage,
              circularBorderRadius: 20,
              minimumSizeWidth: 100,
              minimumSizeHeight: 30,
              maximumSizeWidth: 100,
              maximumSizeHeight: 30,
              buttonTitle: "Add Vendor",
              titleFontSize: 12,
              elevation: 10.0,
            ),
          ),
        ],
        elevation: 0.0,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(kDefaultPadding),
          children: [
            CategoryButtonSection(
              onPressed: () {},
              category: _categoryButton,
              categorybgColor: _categoryButtonBgColor,
              categoryFontColor: _categoryButtonFontColor,
            ),
            kSizedBox,
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < popularVendorsIndex.length; i++,)
                    VendorCard(
                      onTap: toVendorDetailsPage,
                      cardImage: popularVendorImage[i],
                      bannerColor: popularVendorBannerColor[i],
                      bannerText: popularVendorBannerText[i],
                      vendorName: popularVendorName[i],
                      food: popularVendorFood[i],
                      category: popularVendorCategory[i],
                      rating: popularVendorRating[i],
                      noOfUsersRated: popularVendorNoOfUsersRating[i],
                    ),
                ],
              ),
            ),
            kSizedBox,
          ],
        ),
      ),
    );
  }
}
