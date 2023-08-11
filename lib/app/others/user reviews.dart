// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../src/common_widgets/my_appbar.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class UserReviews extends StatefulWidget {
  const UserReviews({super.key});

  @override
  State<UserReviews> createState() => _UserReviewsState();
}

class _UserReviewsState extends State<UserReviews> {
  //=================================== ALL VARIABLES =====================================\\

//=================================== LISTS =====================================\\
  List<String> reviewDate = [
    "20/05/2023",
    "20/05/2023",
    "20/12/2022",
    "20/12/2022",
    "20/12/2022",
  ];
  List<String> reviewTitle = [
    "Great Food and Service",
    "Great Food and Service",
    "Awesome and Nice",
    "Awesome and Nice",
    "Awesome and Nice",
  ];
  List<String> reviewContent = [
    "This Food so tasty & delicious. Breakfast so fast Delivered in my place. Chef is very friendly. I'm really like chef for Home Food Order. Thanks.",
    "This Food so tasty & delicious. Breakfast so fast Delivered in my place. Chef is very friendly. I'm really like chef for Home Food Order. Thanks.",
    "This Food so tasty & delicious. Breakfast so fast Delivered in my place. ",
    "This Food so tasty & delicious. Breakfast so fast Delivered in my place. ",
    "This Food so tasty & delicious. Breakfast so fast Delivered in my place. ",
  ];
  List<IconData> starRating = [
    Icons.star,
    Icons.star,
    Icons.star,
    Icons.star,
    Icons.star_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        backgroundColor: kPrimaryColor,
        toolbarHeight: 80,
        title: "Reviews",
        actions: const [],
        elevation: 0.0,
      ),
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Container(
          padding: const EdgeInsets.all(
            kDefaultPadding,
          ),
          child: ListView.builder(
            itemCount: 5,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return ListTile(
                minVerticalPadding: kDefaultPadding / 2,
                enableFeedback: true,
                leading: const CircleAvatar(
                  backgroundColor: Color(
                    0xFF98A8B8,
                  ),
                  child: ClipOval(
                    clipBehavior: Clip.hardEdge,
                  ),
                ),
                title: Container(
                  width: 274,
                  height: 171,
                  padding: const EdgeInsets.only(
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: kDefaultPadding,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF6F8FA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            reviewDate[index],
                            style: const TextStyle(
                              color: Color(0xFF9B9BA5),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.more_horiz_rounded,
                            ),
                          )
                        ],
                      ),
                      Text(
                        reviewTitle[index],
                        style: const TextStyle(
                          color: Color(0xFF32343E),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      kHalfSizedBox,
                      Row(
                        children: [
                          for (int i = 0; i < 5; i++)
                            Icon(
                              starRating[i],
                              color: kAccentColor,
                              size: 12,
                            ),
                        ],
                      ),
                      kHalfSizedBox,
                      Text(
                        reviewContent[index],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        softWrap: true,
                        style: const TextStyle(
                          color: Color(0xFF737782),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
