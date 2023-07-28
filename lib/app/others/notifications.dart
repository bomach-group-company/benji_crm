import 'package:benji_aggregator/src/common_widgets/my%20appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Notifications",
        elevation: 0.0,
        actions: const [],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
      ),
    );
  }
}
