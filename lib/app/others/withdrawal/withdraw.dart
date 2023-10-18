import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../src/components/my_elevatedButton.dart';
import '../../../src/components/my_textformfield2.dart';
import '../../../src/providers/constants.dart';
import '../../../src/responsive/reponsive_width.dart';
import '../../../theme/colors.dart';
import 'verify.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
//===================================== ALL VARIABLES =========================================\\
  FocusNode productType = FocusNode();
  FocusNode productNameFN = FocusNode();
  TextEditingController productNameEC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String dropDownItemValue = "Access Bank";

  //================================== FUNCTION ====================================\\
  void _goToVerify() {
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

  void dropDownOnChanged(String? onChanged) {
    setState(() {
      dropDownItemValue = onChanged!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: -20,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Container(
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Builder(
              builder: (context) => Row(
                children: [
                  IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: kAccentColor,
                    ),
                  ),
                  kHalfWidthSizedBox,
                  const Text(
                    "Withdraw",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: kBlackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: MyResponsiveWidth(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding, vertical: kDefaultPadding * 2),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kSizedBox,
                      const Text(
                        'Amount',
                        style: TextStyle(
                          color: Color(0xFF575757),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      kHalfSizedBox,
                      MyTextFormField2(
                        controller: productNameEC,
                        focusNode: productNameFN,
                        hintText: "Enter the amount here",
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value!.isEmpty) {
                            productNameFN.requestFocus();
                            return "Enter the amount";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          productNameEC.text = value!;
                        },
                      ),
                      kSizedBox,
                      MyElevatedButton(
                        onPressed: _goToVerify,
                        buttonTitle: "Withdraw",
                        circularBorderRadius: 16,
                        elevation: 10.0,
                        maximumSizeHeight: 60,
                        maximumSizeWidth: media.width,
                        minimumSizeHeight: 60,
                        minimumSizeWidth: media.width,
                        titleFontSize: 14,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
