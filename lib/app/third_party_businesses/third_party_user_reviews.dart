import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/reviews_controller.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/card/customer_review_card.dart';
import '../../src/components/card/empty.dart';
import '../../src/utils/constants.dart';
import '../../theme/colors.dart';

class ThirdPartyUserReviewsPage extends StatefulWidget {
  const ThirdPartyUserReviewsPage({super.key});

  @override
  State<ThirdPartyUserReviewsPage> createState() =>
      _ThirdPartyUserReviewsPageState();
}

const List<int> stars = [5, 4, 3, 2, 1];

class _ThirdPartyUserReviewsPageState extends State<ThirdPartyUserReviewsPage> {
  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  final scrollController = ScrollController();

  bool isScrollToTopBtnVisible = false;

  Future<void> scrollToTop() async {
    await scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      isScrollToTopBtnVisible = false;
    });
  }

  Future<void> scrollListener() async {
    if (scrollController.position.pixels >= 200 &&
        isScrollToTopBtnVisible != true) {
      setState(() {
        isScrollToTopBtnVisible = true;
      });
    }
    if (scrollController.position.pixels < 200 &&
        isScrollToTopBtnVisible == true) {
      setState(() {
        isScrollToTopBtnVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(
        backgroundColor: kPrimaryColor,
        title: "User Reviews",
        actions: const [],
        elevation: 0.0,
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
              child: const Icon(Icons.keyboard_arrow_up),
            )
          : const SizedBox(),
      body: Scrollbar(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(kDefaultPadding),
          physics: const BouncingScrollPhysics(),
          controller: scrollController,
          children: [
            const Text(
              "Reviews & Ratings",
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          GetBuilder<ReviewsController>(
                            builder: (controller) => OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: controller.ratingValue.value == 0
                                      ? kAccentColor
                                      : const Color(
                                          0xFFA9AAB1,
                                        ),
                                ),
                                backgroundColor:
                                    controller.ratingValue.value == 0
                                        ? kAccentColor
                                        : kPrimaryColor,
                                foregroundColor:
                                    controller.ratingValue.value == 0
                                        ? kPrimaryColor
                                        : const Color(0xFFA9AAB1),
                              ),
                              onPressed: () async {
                                await controller.setRatingValue();
                              },
                              child: const Text(
                                'All',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          GetBuilder<ReviewsController>(
                            builder: (controller) => Row(
                              children: stars
                                  .map(
                                    (item) => Row(
                                      children: [
                                        kHalfWidthSizedBox,
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: controller
                                                          .ratingValue.value ==
                                                      item
                                                  ? kStarColor
                                                  : const Color(0xFFA9AAB1),
                                            ),
                                            foregroundColor:
                                                controller.ratingValue.value ==
                                                        item
                                                    ? kStarColor
                                                    : const Color(0xFFA9AAB1),
                                          ),
                                          onPressed: () async {
                                            await controller
                                                .setRatingValue(item);
                                          },
                                          child: Row(
                                            children: [
                                              const FaIcon(
                                                FontAwesomeIcons.solidStar,
                                                size: 18,
                                              ),
                                              const SizedBox(
                                                width: kDefaultPadding * 0.2,
                                              ),
                                              Text(
                                                item.toString(),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
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
            GetBuilder<ReviewsController>(
              initState: (state) async {
                await ReviewsController.instance.getReviews();
              },
              builder: (controller) => Column(
                children: [
                  controller.isLoad.value && controller.reviews.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(
                            color: kAccentColor,
                          ),
                        )
                      : controller.reviews.isEmpty
                          ? const EmptyCard(
                              emptyCardMessage: "You have no reviews",
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (context, index) => kSizedBox,
                              shrinkWrap: true,
                              itemCount: controller.reviews.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  CostumerReviewCard(
                                rating: controller.reviews[index],
                              ),
                            ),
                  kSizedBox,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
