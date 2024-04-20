import 'package:benji_aggregator/controller/withdraw_controller.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/card/empty.dart';
import 'package:benji_aggregator/src/components/card/withdrawal_detail_card.dart';
import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../theme/colors.dart';

class WithdrawalHistoryPage extends StatefulWidget {
  const WithdrawalHistoryPage({super.key});

  @override
  State<WithdrawalHistoryPage> createState() => _WithdrawalHistoryPageState();
}

class _WithdrawalHistoryPageState extends State<WithdrawalHistoryPage> {
//===================================== INITIAL STATE AND DISPOSE =========================================\\
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    scrollController.addListener(() {
      WithdrawController.instance.scrollListener(scrollController);
    });
  }

//===================================== ALL VARIABLES =========================================\\

//============================================== BOOL VALUES =================================================\\
  bool _isScrollToTopBtnVisible = false;
  bool loadingScreen = false;

  //==================================================== CONTROLLERS ======================================================\\
  final scrollController = ScrollController();

//===================================== FUNCTIONS =========================================\\
//===================== Handle refresh ==========================\\

  Future<void> handleRefresh() async {
    await WithdrawController.instance.refreshWithdraaw();
  }

  //===================== Scroll to Top ==========================\\
  Future<void> _scrollToTop() async {
    await scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _isScrollToTopBtnVisible = false;
    });
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels >= 100 &&
        _isScrollToTopBtnVisible != true) {
      setState(() {
        _isScrollToTopBtnVisible = true;
      });
    }
    if (scrollController.position.pixels < 100 &&
        _isScrollToTopBtnVisible == true) {
      setState(() {
        _isScrollToTopBtnVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MyAppBar(
        title: "Withdrawal History",
        elevation: 0.0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButton: _isScrollToTopBtnVisible
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              mini: deviceType(media.width) > 2 ? false : true,
              backgroundColor: kAccentColor,
              enableFeedback: true,
              mouseCursor: SystemMouseCursors.click,
              tooltip: "Scroll to top",
              hoverColor: kAccentColor,
              hoverElevation: 50.0,
              child: const FaIcon(FontAwesomeIcons.chevronUp, size: 18),
            )
          : const SizedBox(),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          controller: scrollController,
          shrinkWrap: true,
          children: [
            GetBuilder<WithdrawController>(
              initState: (state) =>
                  WithdrawController.instance.withdrawalHistory(),
              builder: (controller) {
                if (controller.listOfWithdrawals.isEmpty &&
                    controller.isLoad.value) {
                  return Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: kAccentColor,
                        ),
                      ],
                    ),
                  );
                }
                if (controller.listOfWithdrawals.isEmpty) {
                  return const Center(
                    child: EmptyCard(
                      emptyCardMessage: "You haven't made any withdrawals",
                    ),
                  );
                }

                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.listOfWithdrawals.length,
                  padding: const EdgeInsets.all(30),
                  separatorBuilder: (context, index) => kSizedBox,
                  itemBuilder: (context, index) {
                    return WithdrawalDetailCard(
                      withdrawalDetail: controller.listOfWithdrawals[index],
                    );
                  },
                );
              },
            ),
            GetBuilder<WithdrawController>(
              builder: (controller) {
                return Column(
                  children: [
                    controller.loadedAll.value
                        ? Container(
                            margin: const EdgeInsets.only(top: 20),
                            height: 10,
                            width: 10,
                            decoration: ShapeDecoration(
                                shape: const CircleBorder(),
                                color: kPageSkeletonColor),
                          )
                        : const SizedBox(),
                    controller.isLoadMore.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: kAccentColor,
                            ),
                          )
                        : const SizedBox()
                  ],
                );
              },
            ),
            kSizedBox,
          ],
        ),
      ),
    );
  }
}
