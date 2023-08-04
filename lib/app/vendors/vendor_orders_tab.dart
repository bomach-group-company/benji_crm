// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class VendorsOrdersTab extends StatefulWidget {
  final Widget list;
  const VendorsOrdersTab({
    super.key,
    required this.list,
  });

  @override
  State<VendorsOrdersTab> createState() => _VendorsOrdersTabState();
}

class _VendorsOrdersTabState extends State<VendorsOrdersTab> {
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return SizedBox(width: mediaWidth, child: widget.list);
  }
}
