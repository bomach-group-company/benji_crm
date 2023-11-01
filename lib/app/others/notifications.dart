// ignore_for_file: unused_field

import 'package:benji_aggregator/controller/notification_controller.dart';
import 'package:benji_aggregator/controller/operation.dart';
import 'package:benji_aggregator/src/components/card/empty.dart';
import 'package:benji_aggregator/src/skeletons/notifications_page_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/notificatin_model.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/section/my_liquid_refresh.dart';
import '../../src/providers/constants.dart';
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

    _loadingScreen = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NotificationController.instance.runTask();
    });
    _loadingScreen = false;
  }

  //=================================== ALL VARIABLES =====================================\\
  late bool _loadingScreen;

  //============================================== CONTROLLERS =================================================\\
  final ScrollController scrollController = ScrollController();

  //=================================== FUNCTIONS =====================================\\

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NotificationController.instance.runTask();
    });
    setState(() {
      _loadingScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.of(context).size;
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
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: GetBuilder<NotificationController>(
            builder: (notifications) {
              return notifications.isLoad.value
                  ? const NotificationsPageSkeleton()
                  : notifications.notification.isEmpty
                      ? const EmptyCard()
                      : Scrollbar(
                          radius: const Radius.circular(10),
                          child: ListView(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
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
                                      width: 45,
                                      height: 45,
                                      decoration: ShapeDecoration(
                                        color: kPageSkeletonColor,
                                        shape: const OvalBorder(),
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
                                      style: const TextStyle(
                                        color: Color(0xFF9B9BA5),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  );
                                },
                              ),
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
