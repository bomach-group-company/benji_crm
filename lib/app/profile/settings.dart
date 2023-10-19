import 'package:benji_aggregator/src/components/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../src/components/settings_body.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Settings",
        elevation: 0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      body: const SettingsBody(),
    );
  }
}
