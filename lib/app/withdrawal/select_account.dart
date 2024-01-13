import 'dart:async';
import 'dart:math';

import 'package:benji_aggregator/controller/account_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/button/my_elevatedButton.dart';
import 'package:benji_aggregator/src/components/card/empty.dart';
import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import 'add_bank_account.dart';
import 'withdraw.dart';

class SelectAccountPage extends StatefulWidget {
  const SelectAccountPage({super.key});

  @override
  State<SelectAccountPage> createState() => _SelectAccountPageState();
}

class _SelectAccountPageState extends State<SelectAccountPage> {
  //===================================== INITIAL STATE AND DISPOSE =========================================\\
  @override
  void initState() {
    super.initState();
    UserController.instance.getUser();
    loadingScreen = true;
    scrollController.addListener(_scrollListener);
    _timer = Timer(const Duration(milliseconds: 1000), () {
      setState(() => loadingScreen = false);
    });
  }

  @override
  void dispose() {
    _handleRefresh().ignore();
    scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

//=============================================== ALL CONTROLLERS ======================================================\\
  final scrollController = ScrollController();

//=============================================== ALL VARIABLES ======================================================\\
  late Timer _timer;

//=============================================== BOOL VALUES ======================================================\\
  late bool loadingScreen;
  bool _isScrollToTopBtnVisible = false;

//=============================================== FUNCTIONS ======================================================\\

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

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    loadingScreen = true;
    _timer = Timer(const Duration(milliseconds: 1000), () {
      scrollController.addListener(_scrollListener);

      setState(() => loadingScreen = false);
    });
  }

  void _goToWithdraw(String bankDetailId) {
    Get.to(
      () => WithdrawPage(bankDetailId: bankDetailId),
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
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            children: [
              Scrollbar(
                controller: scrollController,
                child: GetBuilder<AccountController>(
                    initState: (state) =>
                        AccountController.instance.getAccounts(),
                    builder: (controller) {
                      if (controller.isLoad.value &&
                          controller.accounts.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(color: kAccentColor),
                        );
                      }
                      if (controller.accounts.isEmpty) {
                        return const EmptyCard();
                      }
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.accounts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () =>
                                _goToWithdraw(controller.accounts[index].id),
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
                                    offset: const Offset(0, 1),
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
                                          FaIcon(
                                            FontAwesomeIcons.buildingColumns,
                                            color: kAccentColor,
                                          ),
                                          kHalfWidthSizedBox,
                                          Text(
                                            controller.accounts[index].bankName,
                                            style: TextStyle(
                                              color: kTextGreyColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // IconButton(
                                      //   onPressed: () {
                                      //     showBottomSheet(context);
                                      //   },
                                      //   icon: FaIcon(
                                      //     FontAwesomeIcons.ellipsis,
                                      //     color: kAccentColor,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                  kSizedBox,
                                  Text(
                                    '${controller.accounts[index].accountHolder}....${controller.accounts[index].accountNumber.substring(max(controller.accounts[index].accountNumber.length - 5, 0))}',
                                    style: const TextStyle(
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
                      );
                    }),
              ),
              kSizedBox,
            ],
          ),
        ),
      ),
    );
  }

//Delete Account
  void _deleteAccount() {}

  void showBottomSheet(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
                  onTap: _deleteAccount,
                  mouseCursor: SystemMouseCursors.click,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    width: media.width - 200,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidTrashCan,
                          color: kAccentColor,
                        ),
                        kWidthSizedBox,
                        const SizedBox(
                          child: Center(
                            child: Text(
                              'Delete account',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        );
      },
    );
  }
}
