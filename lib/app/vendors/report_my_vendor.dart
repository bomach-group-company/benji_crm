// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/input/message_textformfield.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/form_controller.dart';
import '../../model/my_vendor_model.dart';
import '../../src/components/button/my_elevatedButton.dart';
import '../../src/utils/constants.dart';

class ReportMyVendor extends StatefulWidget {
  final MyVendorModel vendor;
  const ReportMyVendor({super.key, required this.vendor});

  @override
  State<ReportMyVendor> createState() => _ReportMyVendorState();
}

class _ReportMyVendorState extends State<ReportMyVendor> {
  @override
  void initState() {
    log(widget.vendor.id.toString());
    super.initState();
  }

  //============================================ ALL VARIABLES ===========================================\\

  //============================================ CONTROLLERS ===========================================\\
  final TextEditingController messageEC = TextEditingController();

  //============================================ FOCUS NODES ===========================================\\
  final FocusNode messageFN = FocusNode();

  //============================================ KEYS ===========================================\\
  final _formKey = GlobalKey<FormState>();

  //============================================ FUNCTIONS ===========================================\\
  //========================== Save data ==================================\\
  Future<void> submitReport() async {
    Map data = {
      "user_id": widget.vendor.id.toString(),
      "message": messageEC.text,
    };
    var url = Api.baseUrl + Api.report;
    log(url);

    await FormController.instance.postAuth(url, data, "reportVendor");
    if (FormController.instance.status.value == 200) {
      Get.close(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(
          title: "Report vendor",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: GetBuilder<FormController>(
              id: "report_my_vendor",
              builder: (controller) {
                return MyElevatedButton(
                  onPressed: (() async {
                    if (_formKey.currentState!.validate()) {
                      submitReport();
                    }
                  }),
                  isLoading: controller.isLoad.value,
                  title: "Submit",
                );
              }),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(kDefaultPadding),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                child: Text(
                  'We will like to hear from you',
                  style: TextStyle(
                    color: kTextBlackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              kHalfSizedBox,
              SizedBox(
                child: Text(
                  'Let us know how we can help you.',
                  style: TextStyle(
                    color: kTextGreyColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: kDefaultPadding * 2),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyMessageTextFormField(
                      controller: messageEC,
                      validator: (value) {
                        if (value == null ||
                            messageEC.text.isEmpty ||
                            messageEC.text == "") {
                          return "Field cannot be left blank";
                        } else if (messageEC.text.length < 10) {
                          return "Your reason is too short.";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      focusNode: messageFN,
                      hintText: "Enter your report here",
                      maxLines: 10,
                      keyboardType: TextInputType.text,
                      maxLength: 6000,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
