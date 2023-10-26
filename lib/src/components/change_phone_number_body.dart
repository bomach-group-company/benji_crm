import 'package:benji_aggregator/app/auth_screens/otp_reset_password.dart';
import 'package:benji_aggregator/src/components/my_elevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../src/components/my_intl_phonefield.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class ChangePhoneNumberBody extends StatefulWidget {
  const ChangePhoneNumberBody({Key? key}) : super(key: key);

  @override
  State<ChangePhoneNumberBody> createState() => _ChangePhoneNumberBodyState();
}

class _ChangePhoneNumberBodyState extends State<ChangePhoneNumberBody> {
//================== INTIAL STATE ===============\\
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//================== KEYS ===============\\
  final _formKey = GlobalKey<FormState>();

//================== CONTROLLERS ===============\\
  final userPhoneNumberEC = TextEditingController();

//================== FOCUS NODES ===============\\

  final userPhoneNumberFN = FocusNode();

//================== FUNCTIONS ===============\\
  toOTPPage() => Get.to(
        () => const OTPResetPassword(),
        routeName: 'OTPResetPassword',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      physics: const BouncingScrollPhysics(),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Phone Number".toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyIntlPhoneField(
                controller: userPhoneNumberEC,
                initialCountryCode: "NG",
                invalidNumberMessage: "Invalid phone number",
                dropdownIconPosition: IconPosition.trailing,
                showCountryFlag: true,
                showDropdownIcon: true,
                dropdownIcon:
                    Icon(Icons.arrow_drop_down_rounded, color: kAccentColor),
                textInputAction: TextInputAction.next,
                focusNode: userPhoneNumberFN,
                validator: (value) {
                  if (value == null || userPhoneNumberEC.text.isEmpty) {
                    return "Field cannot be empty";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  userPhoneNumberEC.text = value!;
                },
              ),
              kSizedBox,
            ],
          ),
        ),
        kSizedBox,
        MyElevatedButton(
          title: "Get OTP",
          onPressed: toOTPPage,
        )
      ],
    );
  }
}
