// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../src/common_widgets/category_button_section.dart';
import '../../src/common_widgets/my_floating_snackbar.dart';
import '../../src/common_widgets/vendors_food_container.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class VendorsDetailPage extends StatefulWidget {
  const VendorsDetailPage({super.key});

  @override
  State<VendorsDetailPage> createState() => _VendorsDetailPageState();
}

class _VendorsDetailPageState extends State<VendorsDetailPage> {
  //=================================== ALL VARIABLES ====================================\\
  int selectedRating = 0;

  //=================================== CONTROLLERS ====================================\\

  TextEditingController searchController = TextEditingController();
  TextEditingController rateVendorEC = TextEditingController();

//===================== KEYS =======================\\
  // final _formKey = GlobalKey<FormState>();

//===================== FOCUS NODES =======================\\
  FocusNode rateVendorFN = FocusNode();

//===================== BOOL VALUES =======================\\
  bool isLoading = false;
  bool isValidating = false;
//===================== CATEGORY BUTTONS =======================\\
  final List _categoryButtonText = [
    "Pasta",
    "Burgers",
    "Rice Dishes",
    "Chicken",
    "Snacks"
  ];

  final List<Color> _categoryButtonBgColor = [
    kAccentColor,
    const Color(0xFFF2F2F2),
    const Color(0xFFF2F2F2),
    const Color(0xFFF2F2F2),
    const Color(0xFFF2F2F2)
  ];
  final List<Color> _categoryButtonFontColor = [
    kPrimaryColor,
    const Color(0xFF828282),
    const Color(0xFF828282),
    const Color(0xFF828282),
    const Color(0xFF828282)
  ];

//===================== VENDORS LIST VIEW INDEX =======================\\
  List<int> foodListView = [0, 1, 3, 4, 5, 6];

//===================== FUNCTIONS =======================\\
  void validate() {
    mySnackBar(
      context,
      "Success!",
      "Thank you for your feedback!",
      const Duration(seconds: 1),
    );

    Navigator.of(context).pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: kPrimaryColor.withOpacity(0.6),
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      "assets/images/food/burgers.png",
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.47,
              left: kDefaultPadding,
              right: kDefaultPadding,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    bottom: kDefaultPadding * 2,
                  ),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kHalfSizedBox,
                      CategoryButtonSection(
                        onPressed: () {},
                        category: _categoryButtonText,
                        categorybgColor: _categoryButtonBgColor,
                        categoryFontColor: _categoryButtonFontColor,
                      ),
                      for (int i = 0; i < foodListView.length; i++,)
                        VendorFoodContainer(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => ItemDetailScreen(),
                            //   ),
                            // );
                          },
                        ),
                      const SizedBox(
                        height: kDefaultPadding * 4,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.04,
              left: kDefaultPadding,
              right: kDefaultPadding,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(context);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: const Color(
                            0xFFFAFAFA,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              19,
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: kAccentColor,
                          size: 16,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: const Color(
                            0xFFFAFAFA,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              19,
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          color: kAccentColor,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.14,
              left: kDefaultPadding,
              right: kDefaultPadding,
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                decoration: ShapeDecoration(
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.1,
                      ),
                      blurRadius: 5,
                      spreadRadius: 2,
                      blurStyle: BlurStyle.normal,
                    ),
                  ],
                  color: const Color(
                    0xFFFEF8F8,
                  ),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 0.50,
                      color: Color(
                        0xFFFDEDED,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(
                      25,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: kDefaultPadding * 2.6,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Ntachi Osa",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(
                            0xFF302F3C,
                          ),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      kHalfSizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: kAccentColor,
                            size: 15,
                          ),
                          kHalfWidthSizedBox,
                          const SizedBox(
                            width: 300,
                            child: Text(
                              "Old Abakaliki Rd, Thinkers Corner 400103, Enugusdsudhosud",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      kHalfSizedBox,
                      InkWell(
                        onTap: (() async {
                          final websiteurl = Uri.parse(
                            "https://goo.gl/maps/8pKoBVCsew5oqjU49",
                          );
                          if (await canLaunchUrl(
                            websiteurl,
                          )) {
                            launchUrl(
                              websiteurl,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            throw "An unexpected error occured and $websiteurl cannot be loaded";
                          }
                        }),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: mediaWidth / 4,
                          padding: const EdgeInsets.all(kDefaultPadding / 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: kAccentColor,
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            "Show on map",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      kHalfSizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 102,
                            height: 56.67,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  19,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time_outlined,
                                  color: kAccentColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "30 mins",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 102,
                            height: 56.67,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  19,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: HexColor(
                                    "#FF6838",
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "4.8",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 102,
                            height: 56.67,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  19,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Open',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(
                                      0xFF189D60,
                                    ),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.36,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.info_outline,
                                  color: kAccentColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              left: MediaQuery.of(context).size.width / 2.7,
              child: Container(
                width: 107,
                height: 107,
                decoration: ShapeDecoration(
                  image: const DecorationImage(
                    image: AssetImage(
                      "assets/images/vendors/ntachi-osa-logo.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      43.50,
                    ),
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

// openRatingDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         child: RatingView(),
//       );
//     },
//   );
// }
