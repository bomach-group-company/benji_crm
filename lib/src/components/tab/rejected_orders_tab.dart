import 'package:flutter/material.dart';

class RejectedOrdersTab extends StatefulWidget {
  final Widget list;
  const RejectedOrdersTab({
    super.key,
    required this.list,
  });

  @override
  State<RejectedOrdersTab> createState() => _RejectedOrdersTabState();
}

class _RejectedOrdersTabState extends State<RejectedOrdersTab> {
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

    return SizedBox(width: mediaWidth, child: widget.list);
  }
}
