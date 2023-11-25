import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/button/my_elevatedButton.dart';
import '../../src/components/input/number_textformfield.dart';
import '../../src/providers/constants.dart';
import '../../src/responsive/my_reponsive_width.dart';
import '../../theme/colors.dart';
import 'verify_withdrawal.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  @override
  void initState() {
    super.initState();
    // Add a listener to format the input with commas
    amountEC.addListener(() {
      final text = amountEC.text;
      final cleanText =
          text.replaceAll(RegExp(r'[^\d]'), ''); // Remove non-digits
      final formattedText = NumberFormat('#,###').format(int.parse(cleanText));

      if (text != formattedText) {
        amountEC.value = amountEC.value.copyWith(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    });
  }

//===================================== ALL VARIABLES =========================================\\
  final productType = FocusNode();
  final amountFN = FocusNode();
  final amountEC = TextEditingController();
  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

  //================================== FUNCTION ====================================\\
  void goToVerify() {
    Get.to(
      () => const VerifyWithdrawalPage(),
      routeName: 'VerifyWithdrawalPage',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          title: "Withdraw",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        body: SafeArea(
          child: MyResponsiveWidth(
            child: Scrollbar(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(10),
                physics: const BouncingScrollPhysics(),
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: kDefaultPadding),
                          child: Text(
                            'Amount',
                            style: TextStyle(
                              color: kTextGreyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        kHalfSizedBox,
                        NumberTextFormField(
                          controller: amountEC,
                          focusNode: amountFN,
                          hintText: "Enter the amount here",
                          textInputAction: TextInputAction.go,
                          validator: (value) {
                            if (value == null || value!.isEmpty) {
                              amountFN.requestFocus();
                              return "Enter the amount";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            amountEC.text = value!;
                          },
                        ),
                        kSizedBox,
                        MyElevatedButton(
                          onPressed: (() async {
                            if (formKey.currentState!.validate()) {
                              goToVerify();
                            }
                          }),
                          title: "Withdraw",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
