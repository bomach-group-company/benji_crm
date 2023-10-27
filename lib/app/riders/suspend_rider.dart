// ignore_for_file: use_build_context_synchronously

import 'package:benji_aggregator/src/components/message_textformfield.dart';
import 'package:benji_aggregator/src/components/my_appbar.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../src/components/my_elevatedButton.dart';
import '../../src/components/my_fixed_snackBar.dart';
import '../../src/providers/constants.dart';

class SuspendRider extends StatefulWidget {
  const SuspendRider({super.key});

  @override
  State<SuspendRider> createState() => _SuspendRiderState();
}

class _SuspendRiderState extends State<SuspendRider> {
  //============================================ ALL VARIABLES ===========================================\\
  bool _submittingRequest = false;

  //============================================ CONTROLLERS ===========================================\\
  final TextEditingController _messageEC = TextEditingController();

  //============================================ FOCUS NODES ===========================================\\
  final FocusNode _messageFN = FocusNode();

  //============================================ KEYS ===========================================\\
  final GlobalKey<FormState> _formKey = GlobalKey();

  //============================================ FUNCTIONS ===========================================\\
  //========================== Save data ==================================\\
  Future<void> _submitRequest() async {
    setState(() {
      _submittingRequest = true;
    });

    // Simulating a delay of 3 seconds
    await Future.delayed(const Duration(seconds: 1));

    //Display snackBar
    myFixedSnackBar(
      context,
      "Your request has been submitted successfully".toUpperCase(),
      kAccentColor,
      const Duration(seconds: 3),
    );

    Future.delayed(const Duration(seconds: 1), () {
      // Navigate to the new page
      Navigator.of(context).pop(context);

      setState(() {
        _submittingRequest = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(
        title: "Suspend Rider",
        elevation: 0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: _submittingRequest
          ? Center(child: CircularProgressIndicator(color: kAccentColor))
          : Container(
              color: kPrimaryColor,
              padding: const EdgeInsets.all(kDefaultPadding),
              child: MyElevatedButton(
                onPressed: (() async {
                  if (_formKey.currentState!.validate()) {
                    _submitRequest();
                  }
                }),
                title: "Submit",
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
