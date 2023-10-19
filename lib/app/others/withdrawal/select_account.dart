import 'dart:async';

import 'package:benji_aggregator/src/components/my_appbar.dart';
import 'package:benji_aggregator/src/components/my_elevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../../src/providers/constants.dart';
import '../../../src/responsive/responsive_constant.dart';
import '../../../theme/colors.dart';
import 'add_bank_account.dart';
import 'withdraw.dart';

class SelectAccountPage extends StatefulWidget {
  const SelectAccountPage({Key? key}) : super(key: key);

  @override
  State<SelectAccountPage> createState() => _SelectAccountPageState();
}

class _SelectAccountPageState extends State<SelectAccountPage> {
  //===================================== INITIAL STATE AND DISPOSE =========================================\\
  @override
  void initState() {
    super.initState();
    _loadingScreen = true;
    _scrollController.addListener(_scrollListener);

    _timer = Timer(const Duration(milliseconds: 1000), () {
      setState(() => _loadingScreen = false);
    });
  }

  @override
  void dispose() {
    _handleRefresh().ignore();
    _scrollController.dispose();

    _timer.cancel();
    super.dispose();
  }

//=============================================== ALL CONTROLLERS ======================================================\\
  final _scrollController = ScrollController();

//=============================================== ALL VARIABLES ======================================================\\
  late Timer _timer;

//=============================================== BOOL VALUES ======================================================\\
  late bool _loadingScreen;
  bool _isScrollToTopBtnVisible = false;

//=============================================== FUNCTIONS ======================================================\\

  //===================== Scroll to Top ==========================\\
  Future<void> _scrollToTop() async {
    await _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _isScrollToTopBtnVisible = false;
    });
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels >= 100 &&
        _isScrollToTopBtnVisible != true) {
      setState(() {
        _isScrollToTopBtnVisible = true;
      });
    }
    if (_scrollController.position.pixels < 100 &&
        _isScrollToTopBtnVisible == true) {
      setState(() {
        _isScrollToTopBtnVisible = false;
      });
    }
  }

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _scrollController.addListener(_scrollListener);
      _loadingScreen = false;
    });
  }

  void _goToWithdraw() {
    Get.to(
      () => const WithdrawPage(),
      routeName: 'WithdrawPage',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  void _addBankAccount() => Get.to(
        () => const AddBankAccountPage(),
        routeName: 'AddBankAccountPage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(
        title: "Select an account",
        elevation: 0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kAccentColor.withOpacity(0.08),
            offset: const Offset(3, 0),
            blurRadius: 32,
          ),
        ]),
        child: MyElevatedButton(
          title: "Add a new account",
          onPressed: _addBankAccount,
        ),
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
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        displacement: 5,
        color: kAccentColor,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              _loadingScreen
                  ? kSizedBox
                  : Scrollbar(
                      controller: _scrollController,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: _goToWithdraw,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding,
                                vertical: kDefaultPadding / 2,
                              ),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    color: Colors.grey.shade400,
                                    spreadRadius: 1,
                                    // offset: Offset(1, 1),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(kDefaultPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                              'assets/icons/accessbank.png'),
                                          kHalfWidthSizedBox,
                                          Text(
                                            'Access Bank',
                                            style: TextStyle(
                                              color: kTextGreyColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _showBottomSheet(context);
                                        },
                                        icon: FaIcon(
                                          FontAwesomeIcons.ellipsis,
                                          color: kAccentColor,
                                        ),
                                      )
                                    ],
                                  ),
                                  kSizedBox,
                                  const Text(
                                    'Blessing George....09876',
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              kSizedBox,
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      backgroundColor: kPrimaryColor,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(left: 100, right: 100, bottom: 25),
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  mouseCursor: SystemMouseCursors.click,
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidTrashCan,
                        color: kAccentColor,
                      ),
                      kWidthSizedBox,
                      const Text(
                        'Delete account',
                        style: TextStyle(
                          color: kTextBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                kSizedBox,
                const Divider(),
              ],
            ),
          ),
        );
      },
    );
  }
}
