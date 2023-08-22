// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/email_textformfield.dart';
import '../../src/common_widgets/my_appbar.dart';
import '../../src/common_widgets/my_fixed_snackBar.dart';
import '../../src/common_widgets/reusable_authentication_firsthalf.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constant.dart';
import '../../theme/colors.dart';
import 'otp.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //=========================== ALL VARIABBLES ====================================\\

  //=========================== BOOL VALUES ====================================\\
  bool _isLoading = false;
  bool _validAuthCredentials = false;
  // bool _invalidAuthCredentials = false;

  //=========================== KEYS ====================================\\

  final _formKey = GlobalKey<FormState>();

  //=========================== CONTROLLERS ====================================\\

  TextEditingController emailController = TextEditingController();

  //=========================== FOCUS NODES ====================================\\
  FocusNode emailFocusNode = FocusNode();

  //=========================== FUNCTIONS ====================================\\
  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulating a delay of 3 seconds
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _validAuthCredentials = true;
    });

    //Display snackBar
    myFixedSnackBar(
      context,
      "An OTP code has been sent to your email".toUpperCase(),
      kSuccessColor,
      const Duration(seconds: 2),
    );

    // Simulating a delay of 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to the new page
    Get.to(
      () => const SendOTP(),
      routeName: 'SendOTP',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
          backgroundColor: kSecondaryColor,
          appBar: MyAppBar(
            title: "",
            elevation: 0.0,
            actions: [],
            backgroundColor: kTransparentColor,
            toolbarHeight: kToolbarHeight,
          ),
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: SafeArea(
              maintainBottomViewPadding: true,
              child: Column(children: [
                Expanded(
                  child: () {
                    if (_validAuthCredentials) {
                      return ReusableAuthenticationFirstHalf(
                        title: "Forgot Password",
                        subtitle:
                            "Forgot your password? Enter your email below and we will send you a code via which you need to recover your password",
                        curves: Curves.easeInOut,
                        duration: Duration(),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.solidCircleCheck,
                            color: kSuccessColor,
                            size: 80,
                          ),
                        ),
                        decoration: ShapeDecoration(
                          color: kPrimaryColor,
                          shape: OvalBorder(),
                        ),
                        imageContainerHeight:
                            deviceType(media.size.width) > 2 ? 200 : 100,
                      );
                    } else {
                      return ReusableAuthenticationFirstHalf(
                        title: "Forgot Password",
                        subtitle:
                            "Forgot your password? Enter your email below and we will send you a code via which you need to recover your password",
                        curves: Curves.easeInOut,
                        duration: Duration(),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.question,
                            color: kSecondaryColor,
                            size: 80,
                          ),
                        ),
                        decoration: ShapeDecoration(
                          color: kPrimaryColor,
                          shape: OvalBorder(),
                        ),
                        imageContainerHeight:
                            deviceType(media.size.width) > 2 ? 200 : 100,
                      );
                    }
                  }(),
                ),
                Container(
                  height: media.size.height,
                  width: media.size.width,
                  padding: const EdgeInsets.only(
                    top: kDefaultPadding,
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          breakPoint(media.size.width, 24, 24, 0, 0)),
                      topRight: Radius.circular(
                          breakPoint(media.size.width, 24, 24, 0, 0)),
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
                            _isLoading
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
                )
              ]))),
    );
  }
}
