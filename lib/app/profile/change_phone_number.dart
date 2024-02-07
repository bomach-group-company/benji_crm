import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:flutter/material.dart';

import '../../src/components/body/change_phone_number_body.dart';

class ChangePhoneNumber extends StatelessWidget {
  const ChangePhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Change Phone Number",
        elevation: 0,
        actions: const [],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: const SafeArea(
        child: ChangePhoneNumberBody(),
      ),
    );
  }
}
