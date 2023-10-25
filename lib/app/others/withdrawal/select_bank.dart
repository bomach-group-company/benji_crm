import 'package:benji_aggregator/src/components/my_appbar.dart';
import 'package:flutter/material.dart';

import '../../../src/components/select_bank_body.dart';

class SelectBank extends StatelessWidget {
  const SelectBank({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        appBar: MyAppBar(
          title: "Select a bank",
          elevation: 0,
          actions: const [],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: const SelectBankBody(),
      ),
    );
  }
}
