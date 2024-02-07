import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../src/components/body/personal_info_body.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Personal Info",
        elevation: 0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      body: GestureDetector(
        onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
        child: const PersonalInfoBody(),
      ),
    );
  }
}
