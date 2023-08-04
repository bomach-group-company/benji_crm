// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class VendorsProductsTab extends StatefulWidget {
  final Widget list;
  const VendorsProductsTab({
    super.key,
    required this.list,
  });

  @override
  State<VendorsProductsTab> createState() => _VendorsProductsTabState();
}

class _VendorsProductsTabState extends State<VendorsProductsTab> {
  //===================== VARIABLES =======================\\

//============================================ FUNCTIONS ==============================================\\

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: mediaWidth,
      child: widget.list,
    );
  }
}
