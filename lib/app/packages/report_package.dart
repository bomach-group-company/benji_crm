// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/form_controller.dart';
import '../../model/package/delivery_item.dart';
import '../../services/api_url.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/button/my_elevatedbutton.dart';
import '../../src/components/input/message_textformfield.dart';
import '../../src/utils/constants.dart';
import '../../theme/colors.dart';

class ReportPackage extends StatefulWidget {
  final DeliveryItem deliveryItem;
  const ReportPackage({
    required this.deliveryItem,
    super.key,
  });

  @override
  State<ReportPackage> createState() => _ReportPackageState();
}

class _ReportPackageState extends State<ReportPackage> {
  @override
  void initState() {
    super.initState();
    consoleLog(widget.deliveryItem.id);
  }
  //============================================ ALL VARIABLES ===========================================\\

  //============================================ BOOL VALUES ===========================================\\
  bool submittingReport = false;

  //============================================ CONTROLLERS ===========================================\\
  final messageEC = TextEditingController();

  //============================================ FOCUS NODES ===========================================\\
  final messageFN = FocusNode();

  //============================================ KEYS ===========================================\\
  final formKey = GlobalKey<FormState>();

  //============================================ FUNCTIONS ===========================================\\

  submitReport() async {
    Map data = {
      'package_id': widget.deliveryItem.id.toString(),
      'message': messageEC.text,
    };
    String url = Api.baseUrl + Api.reportPackage + widget.deliveryItem.id;
    url += '?message=${Uri.encodeComponent(messageEC.text)}';
    consoleLog(url);
    await FormController.instance.postAuth(url, data, 'reportPackage');
    if (FormController.instance.status.toString().startsWith('2')) {
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
          title: "Help and support",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: kPrimaryColor),
          padding: const EdgeInsets.all(kDefaultPadding),
          child: GetBuilder<FormController>(
            builder: (controller) {
              return MyElevatedButton(
                onPressed: (() async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    submitReport();
                  }
                }),
                isLoading: controller.isLoad.value,
                title: "Submit",
              );
            },
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(kDefaultPadding),
            physics: const BouncingScrollPhysics(),
            children: [
              const Text(
                'We will like to hear from you',
                style: TextStyle(
                  color: kTextBlackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              kHalfSizedBox,
              Text(
                "What went wrong with this package delivery?",
                style: TextStyle(
                  color: kTextGreyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: kDefaultPadding * 2),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyMessageTextFormField(
                      controller: messageEC,
                      textInputAction: TextInputAction.newline,
                      focusNode: messageFN,
                      hintText: "Enter your message here",
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      maxLength: 1000,
                      validator: (value) {
                        if (value == null || value!.isEmpty) {
                          messageFN.requestFocus();
                          return "Field cannot be left empty";
                        }

                        return null;
                      },
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
