import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/controller/withdraw_controller.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/button/my_elevatedButton.dart';
import 'package:benji_aggregator/src/components/input/number_textformfield.dart';
import 'package:benji_aggregator/src/responsive/my_reponsive_width.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../src/utils/constants.dart';
import '../../theme/colors.dart';

class WithdrawPage extends StatefulWidget {
  final String bankDetailId;
  const WithdrawPage({super.key, required this.bankDetailId});

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
  void makeWithdrawal() async {
    final user = UserController.instance.user.value;
    if (user.balance < double.parse(amountEC.text.replaceAll(',', ''))) {
      ApiProcessorController.errorSnack('Amount more than balance');
      return;
    }

    Map data = {
      "user_id": UserController.instance.user.value.id,
      "amount_to_withdraw": amountEC.text,
      "bank_details_id": widget.bankDetailId
    };

    final result = await WithdrawController.instance.withdraw(data);
    if (result.statusCode == 200) {
      Get.close(1);
    }
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
                            if (value == null || value == '') {
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
                        GetBuilder<WithdrawController>(
                          builder: (controller) => MyElevatedButton(
                            isLoading: controller.isLoadWithdraw.value,
                            onPressed: (() async {
                              if (formKey.currentState!.validate()) {
                                makeWithdrawal();
                              }
                            }),
                            title: "Withdraw",
                          ),
                        )
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
