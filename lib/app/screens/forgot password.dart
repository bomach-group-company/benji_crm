// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../src/providers/constants.dart';
import '../../src/common_widgets/email textformfield.dart';
import '../../src/common_widgets/my appbar.dart';
import '../../src/common_widgets/my fixed snackBar.dart';
import '../../src/common_widgets/reusable authentication first half.dart';
import '../../theme/colors.dart';

import 'otp.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //=========================== ALL VARIABBLES ====================================\\

  //=========================== CONTROLLERS ====================================\\

  TextEditingController emailController = TextEditingController();

  //=========================== KEYS ====================================\\

  final _formKey = GlobalKey<FormState>();

  //=========================== FOCUS NODES ====================================\\
  FocusNode emailFocusNode = FocusNode();

  //=========================== BOOL VALUES====================================\\
  bool isLoading = false;

  //=========================== FUNCTIONS ====================================\\
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    // Simulating a delay of 3 seconds
    await Future.delayed(const Duration(seconds: 2));

    //Display snackBar
    myFixedSnackBar(
      context,
      "An OTP code has been sent to your email".toUpperCase(),
      kSecondaryColor,
      const Duration(
        seconds: 2,
      ),
    );

    // Navigate to the new page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const SendOTP(),
      ),
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        appBar: const MyAppBar(
          title: "",
          elevation: 0.0,
          toolbarHeight: 80,
          actions: [],
          backgroundColor: kTransparentColor,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const ReusableAuthenticationFirstHalf(
                title: "Forgot Password",
                subtitle:
                    "Forgot your password? Enter your email below and we will send you a code via which you need to recover your password",
                decoration: BoxDecoration(),
                imageContainerHeight: 0,
              ),
              kSizedBox,
              Expanded(
                child: Container(
                  width: media.size.width,
                  padding: const EdgeInsets.only(
                    top: kDefaultPadding / 2,
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              child: Text(
                                'Email',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(
                                    0xFF31343D,
                                  ),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            kHalfSizedBox,
                            EmailTextFormField(
                              controller: emailController,
                              emailFocusNode: emailFocusNode,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                RegExp emailPattern = RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                                );
                                if (value == null || value!.isEmpty) {
                                  emailFocusNode.requestFocus();
                                  return "Enter your email address";
                                } else if (!emailPattern.hasMatch(value)) {
                                  return "Please enter a valid email address";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                emailController.text = value;
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            isLoading
                                ? Center(
                                    child: SpinKitChasingDots(
                                      color: kAccentColor,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: (() async {
                                      if (_formKey.currentState!.validate()) {
                                        loadData();
                                      }
                                    }),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: kAccentColor,
                                      fixedSize: Size(media.size.width, 50),
                                    ),
                                    child: Text(
                                      'Send Code'.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
