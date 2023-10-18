// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../../services/api_url.dart';
import '../../src/components/my_appbar.dart';
import '../../src/components/my_fixed_snackBar.dart';
import '../../src/components/otp_textFormField.dart';
import '../../src/components/reusable_authentication_firsthalf.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constant.dart';
import '../../theme/colors.dart';
import 'reset_password.dart';

class OTPResetPassword extends StatefulWidget {
  const OTPResetPassword({super.key});

  @override
  State<OTPResetPassword> createState() => _OTPResetPasswordState();
}

class _OTPResetPasswordState extends State<OTPResetPassword> {
  //=========================== INITIAL STATE ====================================\\
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  //=========================== ALL VARIABBLES ====================================\\
  late Timer _timer;
  int _secondsRemaining = 30;

  //=========================== BOOL VALUES ====================================\\
  bool _isLoading = false;
  bool _validAuthCredentials = false;
  bool _timerComplete = false;

  //=========================== CONTROLLERS ====================================\\

  TextEditingController pin1EC = TextEditingController();
  TextEditingController pin2EC = TextEditingController();
  TextEditingController pin3EC = TextEditingController();
  TextEditingController pin4EC = TextEditingController();

  //=========================== KEYS ====================================\\

  final _formKey = GlobalKey<FormState>();

  //=========================== FOCUS NODES ====================================\\
  FocusNode pin1FN = FocusNode();
  FocusNode pin2FN = FocusNode();
  FocusNode pin3FN = FocusNode();
  FocusNode pin4FN = FocusNode();

  //=========================== FUNCTIONS ====================================\\

  //================= Start Timer ======================\\
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _timerComplete = true;
        });
        _timer.cancel();
      }
    });
  }

  //================= Resend OTP ======================\\
  void _resendOTP() async {
    // Implement your resend OTP logic here
    // For example, you could restart the timer and reset the `_timerComplete` state.
    String? userEmail = prefs.getString('email');

    if (userEmail == null) {
      myFixedSnackBar(
        context,
        "Something went wrong".toUpperCase(),
        kSuccessColor,
        const Duration(
          seconds: 2,
        ),
      );

      Get.back();

      // Get.to(
      //   () => const ForgotPassword(),
      //   routeName: 'ForgotPassword',
      //   duration: const Duration(milliseconds: 300),
      //   fullscreenDialog: true,
      //   curve: Curves.easeIn,
      //   preventDuplicates: true,
      //   popGesture: true,
      //   transition: Transition.rightToLeft,
      // );
    }

    final url =
        Uri.parse('${Api.baseUrl}/auth/requestForgotPassword/$userEmail');

    final body = {};
    await http.post(url, body: body);

    setState(() {
      _secondsRemaining = 60;
      _timerComplete = false;
      startTimer();
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  Future<bool> otp() async {
    final url = Uri.parse(
        '${Api.baseUrl}/auth/verify-token/${pin1EC.text}${pin2EC.text}${pin3EC.text}${pin4EC.text}');

    final response = await http.get(url);
    try {
      Map resp = jsonDecode(response.body);
      bool res =
          response.statusCode == 200 && resp['message'].toString() == 'true';
      await prefs.setString('token', resp['otp']);
      return res;
    } catch (e) {
      return false;
    }
  }

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    bool res = await otp();

    setState(() {
      _validAuthCredentials = res;
    });
    if (res) {
      //Display snackBar
      myFixedSnackBar(
        context,
        "OTP Verified".toUpperCase(),
        kSuccessColor,
        const Duration(
          seconds: 2,
        ),
      );

      // Navigate to the new page
      Get.to(
        () => const ResetPassword(),
        routeName: 'ResetPassword',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
    } else {
      myFixedSnackBar(
        context,
        "Invalid OTP".toUpperCase(),
        kAccentColor,
        const Duration(
          seconds: 2,
        ),
      );
    }

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
        appBar: const MyAppBar(
          title: "",
          elevation: 0.0,
          actions: [],
          backgroundColor: kTransparentColor,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: LayoutGrid(
            columnSizes: breakPointDynamic(
              media.size.width,
              [1.fr],
              [1.fr],
              [1.fr, 1.fr],
              [1.fr, 1.fr],
            ),
            rowSizes: breakPointDynamic(
              media.size.width,
              [auto, 1.fr],
              [auto, 1.fr],
              [1.fr],
              [1.fr],
            ),
            children: [
              Column(
                children: [
                  Expanded(
                    child: () {
                      if (_validAuthCredentials) {
                        return ReusableAuthenticationFirstHalf(
                          title: "Verification",
                          subtitle:
                              "Please enter the code we sent to your email",
                          curves: Curves.easeInOut,
                          duration: const Duration(),
                          containerChild: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.solidCircleCheck,
                              color: kSuccessColor,
                              size: 80,
                            ),
                          ),
                          decoration: ShapeDecoration(
                              color: kPrimaryColor, shape: const OvalBorder()),
                          imageContainerHeight:
                              deviceType(media.size.width) > 2 ? 200 : 100,
                        );
                      } else {
                        return ReusableAuthenticationFirstHalf(
                          title: "Verification",
                          subtitle:
                              "Please enter the code we sent to your email",
                          curves: Curves.easeInOut,
                          duration: const Duration(),
                          containerChild: Center(
                            child: FaIcon(
                              FontAwesomeIcons.shieldHalved,
                              color: kSecondaryColor,
                              size: 80,
                            ),
                          ),
                          decoration: ShapeDecoration(
                              color: kPrimaryColor, shape: const OvalBorder()),
                          imageContainerHeight:
                              deviceType(media.size.width) > 2 ? 200 : 100,
                        );
                      }
                    }(),
                  ),
                ],
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
                    SizedBox(
                      width: media.size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              color: _timerComplete
                                  ? kAccentColor
                                  : kTextGreyColor,
                              fontSize: 15,
                              fontWeight: _timerComplete
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                            child: Text('Code'.toUpperCase()),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: _timerComplete ? _resendOTP : null,
                                child: AnimatedDefaultTextStyle(
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: _timerComplete
                                        ? kAccentColor
                                        : kTextGreyColor,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                  child: const Text("Resend"),
                                ),
                              ),
                              const Text(
                                "in ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: kTextBlackColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                formatTime(_secondsRemaining),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: _timerComplete
                                      ? kAccentColor
                                      : kSuccessColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    kSizedBox,
                    Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 90,
                            width: 68,
                            child: MyOTPTextFormField(
                              controller: pin1EC,
                              textInputAction: TextInputAction.next,
                              onSaved: (pin1) {},
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  pin1FN.requestFocus();
                                  return "";
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 90,
                            width: 68,
                            child: MyOTPTextFormField(
                              controller: pin2EC,
                              textInputAction: TextInputAction.next,
                              onSaved: (pin2) {},
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  pin2FN.requestFocus();
                                  return "";
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 90,
                            width: 70,
                            child: MyOTPTextFormField(
                              controller: pin3EC,
                              textInputAction: TextInputAction.next,
                              onSaved: (pin3) {},
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  pin3FN.requestFocus();
                                  return "";
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 90,
                            width: 68,
                            child: MyOTPTextFormField(
                              controller: pin4EC,
                              textInputAction: TextInputAction.done,
                              onSaved: (pin4) {},
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nearestScope;
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  pin4FN.requestFocus();
                                  return "";
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: kDefaultPadding * 2,
                    ),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: kAccentColor,
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
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: kAccentColor,
                              fixedSize: Size(media.size.width, 50),
                            ),
                            child: Text(
                              'Verify'.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kPrimaryColor,
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
    );
  }
}
