// ignore_for_file: unused_field

import 'package:benji_aggregator/controller/notification_controller.dart';
import 'package:benji_aggregator/controller/operation.dart';
import 'package:benji_aggregator/src/components/card/empty.dart';
import 'package:benji_aggregator/src/skeletons/notifications_page_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';
import '../../model/notification_model.dart';
import '../../services/api_url.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../src/utils/constants.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await NotificationController.instance.runTask();
    });
  }

  //=================================== ALL VARIABLES =====================================\\

  bool _isScrollToTopBtnVisible = false;

  //============================================== CONTROLLERS =================================================\\
  final scrollController = ScrollController();

  //=================================== FUNCTIONS =====================================\\

  //===================== Handle refresh ==========================\\

  Future<void> handleRefresh() async {
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
    return RefreshIndicator(
      onRefresh: handleRefresh,
      color: kAccentColor,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      child: Scaffold(
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
          child: Scrollbar(
            child: GetBuilder<NotificationController>(
              builder: (notifications) {
                return notifications.isLoad.value
                    ? const NotificationsPageSkeleton()
                    : notifications.notification.isEmpty
                        ? const EmptyCard(
                            emptyCardMessage: "You have no notifications",
                          )
                        : ListView.separated(
                            controller: scrollController,
                            itemCount: notifications.notification.length,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => kSizedBox,
                            itemBuilder: (context, index) {
                              final NotificationModel notify =
                                  notifications.notification[index];
                              final image =
                                  UserController.instance.user.value.image;
                              return ListTile(
                                minVerticalPadding: kDefaultPadding / 2,
                                enableFeedback: true,
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: ShapeDecoration(
                                    color: kPageSkeletonColor,
                                    shape: const CircleBorder(),
                                    image: image.isEmpty
                                        ? const DecorationImage(
                                            image: NetworkImage(
                                              "https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg",
                                            ),
                                          )
                                        : DecorationImage(
                                            image:
                                                NetworkImage(baseImage + image),
                                            fit: BoxFit.cover,
                                            filterQuality: FilterQuality.high,
                                          ),
                                  ),
                                  // child: Padding(
                                  //   padding: const EdgeInsets.all(5),
                                  //   child: MyImage(
                                  //     url: image,
                                  //   ),
                                  // ),
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
                                          fontWeight: FontWeight.w600,
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
                                        text: notify.message ?? "loading...",
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
                                      : Operation.convertDate(notify.created!),
                                  style: TextStyle(
                                    color: kAccentColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                          );
              },
            ),
          ),
        ),
      ),
    );
  }
}
