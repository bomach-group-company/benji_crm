import 'package:benji_aggregator/src/common_widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../src/common_widgets/my_elevatedButton.dart';
import '../../../src/common_widgets/my_textformfield2.dart';
import '../../../src/providers/constants.dart';
import '../../../src/responsive/reponsive_width.dart';
import '../../../theme/colors.dart';

class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({Key? key}) : super(key: key);

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
//===================================== ALL VARIABLES =========================================\\
  FocusNode _bankNames = FocusNode();
  FocusNode _accountNumberFN = FocusNode();
  TextEditingController _accountNumberEC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String dropDownItemValue = "Access Bank";

  //================================== FUNCTION ====================================\\

  void dropDownOnChanged(String? onChanged) {
    setState(() {
      dropDownItemValue = onChanged!;
    });
  }

  //=================================== Navigation ============================\\
  void _saveAccount() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          title: "Add bank account",
          elevation: 0.0,
          actions: [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: MyResponsiveWidth(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding, vertical: kDefaultPadding * 2),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank Details',
                        style: TextStyle(
                          color: kTextBlackColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                        ),
                      ),
                      kSizedBox,
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
                      DropdownButtonFormField<String>(
                        value: dropDownItemValue,
                        onChanged: dropDownOnChanged,
                        enableFeedback: true,
                        focusNode: _bankNames,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        elevation: 20,
                        validator: (value) {
                          if (value == null) {
                            _bankNames.requestFocus();
                            return "Pick an account";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue.shade50),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue.shade50),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue.shade50),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: kErrorBorderColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(16),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                        ),
                        iconEnabledColor: kAccentColor,
                        iconDisabledColor: kGreyColor2,
                        items: [
                          DropdownMenuItem<String>(
                            value: "Access Bank",
                            enabled: true,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/accessbank.png',
                                  height: 45,
                                  width: 45,
                                ),
                                Text(
                                  'Access Bank',
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "UBA",
                            enabled: true,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/accessbank.png',
                                  height: 45,
                                  width: 45,
                                ),
                                Text(
                                  'UBA',
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "FCMB",
                            enabled: true,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/accessbank.png',
                                  height: 45,
                                  width: 45,
                                ),
                                Text(
                                  'FCMB',
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "First Bank",
                            enabled: true,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/accessbank.png',
                                  height: 45,
                                  width: 45,
                                ),
                                Text(
                                  'First Bank',
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                      Text(
                        'Account Number',
                        style: TextStyle(
                          color: Color(0xFF575757),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      kHalfSizedBox,
                      MyTextFormField2(
                        controller: _accountNumberEC,
                        focusNode: _accountNumberFN,
                        hintText: "Enter the account number here",
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value!.isEmpty) {
                            _accountNumberFN.requestFocus();
                            return "Enter the account number";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _accountNumberEC.text = value!;
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
                      SizedBox(
                        height: kDefaultPadding * 4,
                      ),
                      MyElevatedButton(
                        onPressed: _saveAccount,
                        buttonTitle: "Save Account",
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
