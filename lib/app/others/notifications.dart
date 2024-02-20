// ignore_for_file: unused_field

import 'package:benji_aggregator/controller/notification_controller.dart';
import 'package:benji_aggregator/controller/operation.dart';
import 'package:benji_aggregator/src/components/card/empty.dart';
import 'package:benji_aggregator/src/components/image/my_image.dart';
import 'package:benji_aggregator/src/skeletons/notifications_page_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';
import '../../model/notification_model.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/section/my_liquid_refresh.dart';
import '../../src/providers/constants.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../theme/colors.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  //===================== Initial State ==========================\\
  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NotificationController.instance.runTask();
    });
  }

  //=================================== ALL VARIABLES =====================================\\

  bool _isScrollToTopBtnVisible = false;

  //============================================== CONTROLLERS =================================================\\
  final scrollController = ScrollController();

  //=================================== FUNCTIONS =====================================\\

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NotificationController.instance.runTask();
    });
  }

  //============================= Scroll to Top ======================================//
  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void _scrollListener() {
    //========= Show action button ========//
    if (scrollController.position.pixels >= 100) {
      setState(() => _isScrollToTopBtnVisible = true);
    }
    //========= Hide action button ========//
    else if (scrollController.position.pixels < 100) {
      setState(() => _isScrollToTopBtnVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MyLiquidRefresh(
      onRefresh: _handleRefresh,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          title: "Notifications",
          backgroundColor: kPrimaryColor,
          elevation: 0,
          actions: const [],
        ),
        floatingActionButton: _isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: scrollToTop,
                mini: deviceType(media.width) > 2 ? false : true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: FaIcon(
                  FontAwesomeIcons.chevronUp,
                  size: 18,
                  color: kPrimaryColor,
                ),
              )
            : const SizedBox(),
        body: SafeArea(
          child: GetBuilder<NotificationController>(
            builder: (notifications) {
              return notifications.isLoad.value
                  ? const NotificationsPageSkeleton()
                  : notifications.notification.isEmpty
                      ? const EmptyCard(
                          emptyCardMessage: "You have no notifications",
                        )
                      : Scrollbar(
                          radius: const Radius.circular(10),
                          child: ListView(
                            controller: scrollController,
                            scrollDirection: Axis.vertical,
                            children: [
                              ListView.separated(
                                itemCount: notifications.notification.length,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => kSizedBox,
                                // Container(
                                //   width: media.width - 350,
                                //   height: 1,
                                //   decoration: const BoxDecoration(
                                //       color: Color(0xFFF0F4F9)),
                                // ),
                                itemBuilder: (context, index) {
                                  final NotificationModel notify =
                                      notifications.notification[index];
                                  return ListTile(
                                    minVerticalPadding: kDefaultPadding / 2,
                                    enableFeedback: true,
                                    leading: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: ShapeDecoration(
                                        color: kPageSkeletonColor,
                                        shape: const OvalBorder(),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: MyImage(
                                          url: UserController
                                              .instance.user.value.image,
                                        ),
                                      ),
                                    ),
                                    title: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: notify.agent!.username ??
                                                "loading...",
                                            style: const TextStyle(
                                              color: Color(0xFF32343E),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: " ",
                                            style: TextStyle(
                                              color: Color(0xFF9B9BA5),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                notify.message ?? "loading...",
                                            style: const TextStyle(
                                              color: Color(0xFF9B9BA5),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: Text(
                                      notify.created == null
                                          ? "loading..."
                                          : Operation.convertDate(
                                              notify.created!),
                                      style: TextStyle(
                                        color: kAccentColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              kSizedBox,
                            ],
                          ),
                        );
            },
          ),
        ),
      ),
    );
  }
}
