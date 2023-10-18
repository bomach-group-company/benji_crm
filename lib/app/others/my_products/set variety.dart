// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../src/components/my_appbar.dart';
import '../../../src/components/my_elevatedButton.dart';
import '../../../src/components/my_outlined_elevatedButton.dart';
import '../../../src/components/my_textformfield2.dart';
import '../../../src/providers/constants.dart';
import '../../../theme/colors.dart';

class SetVariety extends StatefulWidget {
  const SetVariety({super.key});

  @override
  State<SetVariety> createState() => _SetVarietyState();
}

class _SetVarietyState extends State<SetVariety> {
  //============================= ALL VARIABLES =====================================\\

  //===================== GLOBAL KEYS =======================\\
  final _formKey = GlobalKey<FormState>();

  //===================== FOCUS NODES =======================\\
  FocusNode titleFN = FocusNode();
  FocusNode optionFN = FocusNode();

  FocusNode priceFN = FocusNode();
  //===================== CONTROLLERS =======================\\
  TextEditingController titleEC = TextEditingController();
  TextEditingController optionEC = TextEditingController();

  TextEditingController priceEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: MyAppBar(
        title: "Set Variety",
        toolbarHeight: 80,
        elevation: 0.0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      body: GestureDetector(
        onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
        child: SafeArea(
          maintainBottomViewPadding: true,
          child: ListView(
            padding: const EdgeInsets.all(kDefaultPadding),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Title',
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.26,
                      ),
                    ),
                    kHalfSizedBox,
                    MyTextFormField2(
                      hintText: "Enter a title",
                      textInputType: TextInputType.name,
                      controller: titleEC,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          titleFN.requestFocus();
                          return "Enter a title";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        titleEC.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      focusNode: titleFN,
                    ),
                    kSizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Option 1',
                                style: TextStyle(
                                  color: Color(0xFF222222),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.26,
                                ),
                              ),
                              kHalfSizedBox,
                              MyTextFormField2(
                                hintText: "Enter an option",
                                textInputType: TextInputType.name,
                                controller: titleEC,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    optionFN.requestFocus();
                                    return "Enter an option";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  optionEC.text = value!;
                                },
                                textInputAction: TextInputAction.next,
                                focusNode: optionFN,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(
                                  color: Color(0xFF222222),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.26,
                                ),
                              ),
                              kHalfSizedBox,
                              MyTextFormField2(
                                hintText: "Enter cost here",
                                textInputType: TextInputType.number,
                                controller: priceEC,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    optionFN.requestFocus();
                                    return "Enter the cost";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  priceEC.text = value!;
                                },
                                textInputAction: TextInputAction.next,
                                focusNode: priceFN,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    kSizedBox,
                    Align(
                      alignment: Alignment.centerRight,
                      child: MyOutlinedElevatedButton(
                        onPressed: () {},
                        circularBorderRadius: 20,
                        minimumSizeWidth: 165,
                        minimumSizeHeight: 48,
                        maximumSizeWidth: 165,
                        maximumSizeHeight: 48,
                        buttonTitle: "Add an option",
                        titleFontSize: 14,
                        elevation: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: kDefaultPadding * 4,
              ),
              MyElevatedButton(
                onPressed: () {},
                circularBorderRadius: 20,
                minimumSizeWidth: MediaQuery.of(context).size.width,
                minimumSizeHeight: 50,
                maximumSizeWidth: MediaQuery.of(context).size.width,
                maximumSizeHeight: 50,
                buttonTitle: "Set Variety",
                titleFontSize: 14,
                elevation: 0.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
