import 'package:flutter/material.dart';

import '../../src/common_widgets/my_appbar.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  //=================================== ALL VARIABLES =====================================\\
  final int _notifications = 4;

//=================================== LISTS =====================================\\
  final List<String> _notificationTitle = [
    "Tanbir Ahmed",
    "Salim Smith",
    "Royal Bengol",
    "Pabel Vuiya",
  ];
  final List<String> _notificationSubject = [
    "Placed a new order",
    "left a 5 star review",
    "agreed to cancel",
    "Placed a new order",
  ];
  final List<String> _notificationTime = [
    "2 mins",
    "8 mins",
    "15 mins",
    "24 mins",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: MyAppBar(
        title: "Notifications",
        toolbarHeight: 80,
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        actions: const [],
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Container(
          padding: const EdgeInsets.all(
            kDefaultPadding,
          ),
          child: ListView.builder(
            itemCount: _notifications,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: ((context, index) {
              return Column(
                children: [
                  ListTile(
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
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${_notificationTitle[index]} \n",
                            style: const TextStyle(
                              color: Color(0xFF32343E),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: _notificationSubject[index],
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
                      _notificationTime[index],
                      style: const TextStyle(
                        color: Color(0xFF9B9BA5),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    width: 327,
                    height: 1,
                    decoration: const BoxDecoration(
                      color: Color(
                        0xFFF0F4F9,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
