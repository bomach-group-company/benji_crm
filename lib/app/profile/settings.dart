import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/body/settings_body.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

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
