// ignore_for_file: unused_field

import 'package:benji_aggregator/controller/notification_controller.dart';
import 'package:benji_aggregator/controller/operation.dart';
import 'package:benji_aggregator/src/skeletons/notifications_page_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../model/notificatin_model.dart';
import '../../src/common_widgets/my_appbar.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NotificationController.instance.runTask();
    });
    super.initState();

    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  //=================================== ALL VARIABLES =====================================\\
  late bool _loadingScreen;

  //============================================== CONTROLLERS =================================================\\
  final ScrollController _scrollController = ScrollController();

  //=================================== FUNCTIONS =====================================\\

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _loadingScreen = false;
    });
  }

  void _seeMoreNotifications() {}

//=================================== LISTS =====================================\\
  final List<String> _notificationTitle = [
    "Tanbir Ahmed",
    "Salim Smith",
    "Royal Bengol",
    "Pabel Vuiya",
    "Pabel Vuiya",
    "Pabel Vuiya",
    "Pabel Vuiya",
    "Pabel Vuiya",
    "Pabel Vuiya",
    "Pabel Vuiya",
    "Pabel Vuiya",
    "Pabel Vuiya",
    "Pabel Vuiya",
    "Pabel Vuiya",
  ];
  final List<String> _notificationSubject = [
    "Placed a new order",
    "left a 5 star review",
    "agreed to cancel",
    "Placed a new order",
    "Placed a new order",
    "Placed a new order",
    "Placed a new order",
    "Placed a new order",
    "Placed a new order",
    "Placed a new order",
    "Placed a new order",
    "Placed a new order",
    "Placed a new order",
    "Placed a new order",
  ];
  final List<String> _notificationTime = [
    "2 mins ago",
    "8 mins ago",
    "15 mins ago",
    "24 mins ago",
    "24 mins ago",
    "24 mins ago",
    "24 mins ago",
    "24 mins ago",
    "24 mins ago",
    "24 mins ago",
    "24 mins ago",
    "24 mins ago",
    "24 mins ago",
    "24 mins ago",
  ];

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: kAccentColor,
      borderWidth: 5.0,
      backgroundColor: kPrimaryColor,
      height: 150,
      animSpeedFactor: 2,
      showChildOpacityTransition: false,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          title: "Notifications",
          toolbarHeight: 80,
          backgroundColor: kPrimaryColor,
          elevation: 10.0,
          actions: const [],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: FutureBuilder(
            future: null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                SpinKitDoubleBounce(color: kAccentColor);
              }
              if (snapshot.connectionState == ConnectionState.none) {
                const Center(
                  child: Text("Please connect to the internet"),
                );
              }
              // if (snapshot.connectionState == snapshot.requireData) {
              //   SpinKitDoubleBounce(color: kAccentColor);
              // }
              if (snapshot.connectionState == snapshot.error) {
                const Center(
                  child: Text("Error, Please try again later"),
                );
              }
              return GetBuilder<NotificationController>(
                  builder: (notifications) {
                return notifications.isLoad.value
                    ? const NotificationsPageSkeleton()
                    : Scrollbar(
                        controller: _scrollController,
                        radius: const Radius.circular(10),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          children: [
                            ListView.separated(
                              itemCount: notifications.notification.length,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => Container(
                                width: 327,
                                height: 1,
                                decoration: const BoxDecoration(
                                    color: Color(0xFFF0F4F9)),
                              ),
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
                                          text:
                                              "${notify.agent!.username ?? ""} \n",
                                          style: const TextStyle(
                                            color: Color(0xFF32343E),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: notify.message ?? "",
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
                                        ? ""
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
                            TextButton(
                              onPressed: _seeMoreNotifications,
                              child: Text(
                                "See more",
                                style: TextStyle(color: kAccentColor),
                              ),
                            ),
                          ],
                        ),
                      );
              });
            },
          ),
        ),
      ),
    );
  }
}
