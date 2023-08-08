import 'package:benji_aggregator/src/common_widgets/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder({super.key});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Track order",
        elevation: 0.0,
        actions: [],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
      ),
    );
  }
}
