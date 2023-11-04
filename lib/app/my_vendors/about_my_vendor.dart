import 'package:benji_aggregator/model/rating_model.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/card/customer_review_card.dart';
import 'package:benji_aggregator/src/components/card/empty.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../model/my_vendor_model.dart';
import '../../src/components/section/my_liquid_refresh.dart';
import '../../src/providers/constants.dart';

class AboutMyVendor extends StatefulWidget {
  final MyVendorModel vendor;
  const AboutMyVendor({
    super.key,
    required this.vendor,
  });

  @override
  State<AboutMyVendor> createState() => _AboutMyVendorState();
}

class _AboutMyVendorState extends State<AboutMyVendor> {
  @override
  void initState() {
    super.initState();
    getData();
    scrollController.addListener(_scrollListener);
  }

  //=================================== CONTROLLERS ====================================\\
  final ScrollController scrollController = ScrollController();

//============================================= ALL VARIABLES  ===================================================\\
  final List<String> stars = ['5', '4', '3', '2', '1'];
  String active = 'all';
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

  List<Ratings>? _ratings = [];
  Future<void> getData() async {
    setState(() {
      _ratings = null;
    });

    List<Ratings> ratings;
    if (active == 'all') {
      ratings = await getRatingsByVendorId(widget.vendor.id);
    } else {
      ratings = await getRatingsByVendorIdAndRating(
          widget.vendor.id, int.parse(active));
    }

    setState(() {
      _ratings = ratings;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MyLiquidRefresh(
      onRefresh: getData,
      child: Scaffold(
        appBar: MyAppBar(
          title: "About Vendor",
          elevation: 0,
          backgroundColor: kPrimaryColor,
          actions: const [],
        ),
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
        body: Scrollbar(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(kDefaultPadding),
            controller: scrollController,
            children: [
              kSizedBox,
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
                    child: Text(
                      widget.vendor.shopType.isBlank == true
                          ? 'Not Available'
                          : widget.vendor.shopType.description,
                      style: const TextStyle(
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
                                text: "Business Phone number: ",
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
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  kSizedBox,
                  const Text(
                    "Working Hours",
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
                        kHalfSizedBox,
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
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: active == 'all'
                                          ? kAccentColor
                                          : const Color(
                                              0xFFA9AAB1,
                                            ),
                                    ),
                                    backgroundColor: active == 'all'
                                        ? kAccentColor
                                        : kPrimaryColor,
                                    foregroundColor: active == 'all'
                                        ? kPrimaryColor
                                        : const Color(0xFFA9AAB1),
                                  ),
                                  onPressed: () async {
                                    active = 'all';
                                    setState(() {
                                      _ratings = null;
                                    });

                                    List<Ratings> ratings =
                                        await getRatingsByVendorId(
                                            widget.vendor.id);

                                    setState(() {
                                      _ratings = ratings;
                                    });
                                  },
                                  child: const Text(
                                    'All',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: stars
                                      .map(
                                        (item) => Row(
                                          children: [
                                            kHalfWidthSizedBox,
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                  color: active == item
                                                      ? kStarColor
                                                      : const Color(0xFFA9AAB1),
                                                ),
                                                foregroundColor: active == item
                                                    ? kStarColor
                                                    : const Color(0xFFA9AAB1),
                                              ),
                                              onPressed: () async {
                                                active = item;

                                                setState(() {
                                                  _ratings = null;
                                                });

                                                List<Ratings> ratings =
                                                    await getRatingsByVendorIdAndRating(
                                                        widget.vendor.id,
                                                        int.parse(active));

                                                setState(() {
                                                  _ratings = ratings;
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  const FaIcon(
                                                    FontAwesomeIcons.solidStar,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(
                                                    width:
                                                        kDefaultPadding * 0.2,
                                                  ),
                                                  Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                                kHalfWidthSizedBox,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  kSizedBox,
                  _ratings == null
                      ? Center(
                          child: CircularProgressIndicator(color: kAccentColor),
                        )
                      : _ratings!.isEmpty
                          ? const EmptyCard()
                          : Column(
                              children: [
                                ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      kSizedBox,
                                  shrinkWrap: true,
                                  itemCount: _ratings!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          CostumerReviewCard(
                                              rating: _ratings![index]),
                                ),
                                kSizedBox,
                              ],
                            ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
