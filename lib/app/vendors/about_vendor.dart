import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/vendor_model.dart';
import '../../src/components/card/customer_review_card.dart';
import '../../src/components/section/my_liquid_refresh.dart';
import '../../src/components/section/star_row.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class AboutVendor extends StatefulWidget {
  final VendorModel vendor;

  const AboutVendor({
    super.key,
    required this.vendor,
  });

  @override
  State<AboutVendor> createState() => _AboutVendorState();
}

class _AboutVendorState extends State<AboutVendor> {
//============================================= INITIAL STATE AND DISPOSE  ===================================================\\
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  //=================================== CONTROLLERS ====================================\\
  final ScrollController scrollController = ScrollController();

//============================================= ALL VARIABLES  ===================================================\\
  late bool loadingScreen;
  bool isScrollToTopBtnVisible = false;

//============================================= FUNCTIONS  ===================================================\\

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels >= 100 &&
        isScrollToTopBtnVisible != true) {
      setState(() {
        isScrollToTopBtnVisible = true;
      });
    }
    if (scrollController.position.pixels < 100 &&
        isScrollToTopBtnVisible == true) {
      setState(() {
        isScrollToTopBtnVisible = false;
      });
    }
  }

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      loadingScreen = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      loadingScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return MyLiquidRefresh(
      onRefresh: _handleRefresh,
      child: Scaffold(
        floatingActionButton: isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: scrollToTop,
                mini: true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: const FaIcon(FontAwesomeIcons.chevronUp, size: 18),
              )
            : const SizedBox(),
        appBar: MyAppBar(
          title: widget.vendor.shopName,
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            controller: scrollController,
            radius: const Radius.circular(10),
            scrollbarOrientation: ScrollbarOrientation.right,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(kDefaultPadding),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "About This Business",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    kSizedBox,
                    Container(
                      width: media.width,
                      padding: const EdgeInsets.all(kDefaultPadding),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFEF8F8),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 0.50,
                            color: Color(0xFFFDEDED),
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 24,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: const Text(
                        "Cruiselings whale shark diving pan Pacific romance at sea rusty dancemoves endless horizon home is where the anchor drops back packers Endless summer cruise insider paradise island languid afternoons the love boat cruise life.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    kSizedBox,
                    Container(
                      width: media.width,
                      padding: const EdgeInsets.all(kDefaultPadding),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFEF8F8),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 0.50,
                            color: Color(0xFFFDEDED),
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 24,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Email: ",
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.vendor.email,
                                  style: const TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          ),
                          kHalfSizedBox,
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Phone number: ",
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.vendor.phone,
                                  style: const TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    kSizedBox,
                    const Text(
                      "Opening Hours",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    kSizedBox,
                    Container(
                      width: media.width,
                      padding: const EdgeInsets.all(kDefaultPadding),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFEF8F8),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 0.50,
                            color: Color(0xFFFDEDED),
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 24,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mon. - Fri.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              kSizedBox,
                              Text(
                                "Sat.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              kSizedBox,
                              Text(
                                "Sun.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: kDefaultPadding * 2),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "8 AM".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: " - ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "10 PM".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              kSizedBox,
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "8 AM".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: " - ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "10 PM".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              kSizedBox,
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "closed".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: " - ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "closed".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              kSizedBox,
                            ],
                          ),
                        ],
                      ),
                    ),
                    kSizedBox,
                    Container(
                      width: media.width,
                      padding: const EdgeInsets.all(kDefaultPadding),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFEF8F8),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 0.50,
                            color: Color(0xFFFDEDED),
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 24,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Reviews View & Ratings",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding,
                              horizontal: kDefaultPadding * 0.5,
                            ),
                            child: const StarRow(),
                          ),
                        ],
                      ),
                    ),
                    kSizedBox,
                    ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => kSizedBox,
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return CostumerReviewCard(mediaWidth: media.width);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
