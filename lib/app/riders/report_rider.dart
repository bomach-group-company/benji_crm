// ignore_for_file: use_build_context_synchronously

import 'package:benji_aggregator/controller/form_controller.dart';
import 'package:benji_aggregator/model/rider_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/input/message_textformfield.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../src/components/button/my_elevatedButton.dart';
import '../../src/providers/constants.dart';

class ReportRider extends StatefulWidget {
  final RiderItem rider;
  const ReportRider({super.key, required this.rider});

  @override
  State<ReportRider> createState() => _ReportRiderState();
}

class _ReportRiderState extends State<ReportRider> {
  //============================================ ALL VARIABLES ===========================================\\
  final bool _submittingRequest = false;

  //============================================ CONTROLLERS ===========================================\\
  final TextEditingController _messageEC = TextEditingController();

  //============================================ FOCUS NODES ===========================================\\
  final FocusNode _messageFN = FocusNode();

  //============================================ KEYS ===========================================\\
  final GlobalKey<FormState> _formKey = GlobalKey();

  //============================================ FUNCTIONS ===========================================\\
  //========================== Save data ==================================\\
  Future<void> _submitRequest() async {
    Map data = {
      "user_id": widget.rider.id.toString(),
      "message": _messageEC.text,
    };

    await FormController.instance.postAuth(Api.baseUrl + Api.report, data,
        'report_rider', 'Error occurred', "Submitted successfully", false);
    if (FormController.instance.status.value == 200) {
      Get.close(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(
        title: "Report Rider",
        elevation: 0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: _submittingRequest
          ? Center(child: CircularProgressIndicator(color: kAccentColor))
          : Container(
              color: kPrimaryColor,
              padding: const EdgeInsets.all(kDefaultPadding),
              child: GetBuilder<FormController>(
                id: 'report_rider',
                builder: (controller) => MyElevatedButton(
                  isLoading: controller.isLoad.value,
                  onPressed: (() async {
                    if (_formKey.currentState!.validate()) {
                      _submitRequest();
                    }
                  }),
                  title: "Submit",
                ),
              ),
            ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(kDefaultPadding),
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              width: media.width - 250,
              child: const Text(
                'We will like to hear from you',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kTextBlackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            kHalfSizedBox,
            SizedBox(
              width: media.width - 250,
              child: Text(
                'Tell us why you want this rider suspended',
                overflow: TextOverflow.ellipsis,
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
                    controller: _messageEC,
                    validator: (value) {
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    focusNode: _messageFN,
                    hintText: "Enter your reason here",
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
    );
  }
}
