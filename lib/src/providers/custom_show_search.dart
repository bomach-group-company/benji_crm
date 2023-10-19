import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../../theme/colors.dart';
import '../components/my_future_builder.dart';
import '../responsive/responsive_constant.dart';
import 'constants.dart';

class CustomSearchDelegate extends SearchDelegate {
  void _toProductDetailScreenPage(product) {}

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: FaIcon(FontAwesomeIcons.chevronLeft, color: kAccentColor),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: FaIcon(FontAwesomeIcons.xmark, color: kAccentColor),
      )
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    //==================================================== CONTROLLERS ===========================================================\\
    final scrollController = ScrollController();

    //======================== FUNCTIONS ======================\\
    //===================== Get Data ==========================\\

    //========================================================================\\
    double mediaWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: MyFutureBuilder(
        future: null,
        child: (data) {
          return data.isEmpty
              ? ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            "assets/animations/empty/frame_3.json",
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                          kSizedBox,
                          Text(
                            "No product found",
                            style: TextStyle(
                              color: kTextGreyColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Scrollbar(
                    controller: scrollController,
                    child: ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      children: [
                        LayoutGrid(
                          rowGap: kDefaultPadding / 2,
                          columnGap: kDefaultPadding / 2,
                          columnSizes: breakPointDynamic(
                              mediaWidth,
                              [1.fr],
                              [1.fr, 1.fr],
                              [1.fr, 1.fr, 1.fr],
                              [1.fr, 1.fr, 1.fr, 1.fr]),
                          rowSizes: data.isEmpty
                              ? [auto]
                              : List.generate(data.length, (index) => auto),
                          children: const [],
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/animations/empty/frame_3.json",
                  height: 300,
                  fit: BoxFit.contain,
                ),
                kSizedBox,
                Text(
                  "Search for a vendor",
                  style: TextStyle(
                    color: kTextGreyColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
