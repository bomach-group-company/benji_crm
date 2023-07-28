// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../src/common_widgets/my appbar.dart';
import '../../theme/colors.dart';

class AddRider extends StatefulWidget {
  const AddRider({super.key});

  @override
  State<AddRider> createState() => _AddRiderState();
}

class _AddRiderState extends State<AddRider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Add New Vendor",
        elevation: 0.0,
        actions: const [],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
      ),
    );
  }
}
