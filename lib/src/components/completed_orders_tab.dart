import 'package:flutter/material.dart';

class CompletedOrdersTab extends StatefulWidget {
  final Widget list;
  const CompletedOrdersTab({
    super.key,
    required this.list,
  });

  @override
  State<CompletedOrdersTab> createState() => _CompletedOrdersTabState();
}

class _CompletedOrdersTabState extends State<CompletedOrdersTab> {
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

    return SizedBox(width: mediaWidth, child: widget.list);
  }
}
