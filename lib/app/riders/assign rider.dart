// ignore_for_file: file_names

import 'package:benji_aggregator/src/common_widgets/my%20appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';

class AssignRider extends StatefulWidget {
  const AssignRider({super.key});

  @override
  State<AssignRider> createState() => _AssignRiderState();
}

class _AssignRiderState extends State<AssignRider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Available Riders",
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "See all",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
      ),
    );
  }
}
