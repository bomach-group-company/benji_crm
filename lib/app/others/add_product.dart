// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../src/common_widgets/my_appbar.dart';
import '../../theme/colors.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Add New Product",
        elevation: 0.0,
        actions: const [],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
      ),
    );
  }
}
