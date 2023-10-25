import 'package:benji_aggregator/src/components/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../../src/components/my_blue_textformfield.dart';
import '../../../src/components/my_elevatedButton.dart';
import '../../../src/components/my_textformfield2.dart';
import '../../../src/providers/constants.dart';
import '../../../src/responsive/my_reponsive_width.dart';
import '../../../theme/colors.dart';
import 'select_bank.dart';

class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({Key? key}) : super(key: key);

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
//===================================== ALL VARIABLES =========================================\\

//================= Controllers ==================\\
  final bankNameEC = TextEditingController();
  final accountNumberEC = TextEditingController();

//================= Focus Nodes ==================\\
  final bankNameFN = FocusNode();
  final bankNames = FocusNode();
  final accountNumberFN = FocusNode();

  final formKey = GlobalKey<FormState>();

  String dropDownItemValue = "Access Bank";

  //================================== FUNCTION ====================================\\

  void dropDownOnChanged(String? onChanged) {
    setState(() {
      dropDownItemValue = onChanged!;
    });
  }

  //=================================== Navigation ============================\\
  _selectBank() async {
    Get.to(
      () => const SelectBank(),
      routeName: 'SelectBank',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  void _saveAccount() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          title: "Add bank account",
          elevation: 0.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPadding),
            physics: const BouncingScrollPhysics(),
            child: MyResponsiveWidth(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Bank Details',
                        style: TextStyle(
                          color: kTextBlackColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                        ),
                      ),
                    ),
                    kSizedBox,
                    Text(
                      'Bank Name',
                      style: TextStyle(
                        color: kTextGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    kHalfSizedBox,
                    InkWell(
                      onTap: _selectBank,
                      child: MyBlueTextFormField(
                        controller: bankNameEC,
                        isEnabled: false,
                        textInputAction: TextInputAction.next,
                        focusNode: bankNameFN,
                        hintText: "Select a bank",
                        suffixIcon: FaIcon(
                          FontAwesomeIcons.chevronDown,
                          size: 20,
                          color: kAccentColor,
                        ),
                        textInputType: TextInputType.name,
                        validator: (value) {
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    kSizedBox,
                    Text(
                      'Account Number',
                      style: TextStyle(
                        color: kTextGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    kHalfSizedBox,
                    MyTextFormField2(
                      controller: accountNumberEC,
                      focusNode: accountNumberFN,
                      hintText: "Enter the account number here",
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value!.isEmpty) {
                          accountNumberFN.requestFocus();
                          return "Enter the account number";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        accountNumberEC.text = value!;
                      },
                    ),
                    kSizedBox,
                    Text(
                      'Blessing Mesoma',
                      style: TextStyle(
                        color: kAccentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: kDefaultPadding * 4,
                    ),
                    MyElevatedButton(
                      onPressed: _saveAccount,
                      title: "Save Account",
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
