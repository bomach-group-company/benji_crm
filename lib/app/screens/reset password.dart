// ignore_for_file: file_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/my appbar.dart';
import '../../src/common_widgets/my fixed snackBar.dart';
import '../../src/common_widgets/password textformfield.dart';
import '../../src/common_widgets/reusable authentication first half.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import 'login.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  //=========================== ALL VARIABBLES ====================================\\

  //=========================== KEYS ====================================\\

  final _formKey = GlobalKey<FormState>();

  //=========================== CONTROLLERS ====================================\\

  TextEditingController userPasswordEC = TextEditingController();
  TextEditingController confirmPasswordEC = TextEditingController();

  //=========================== FOCUS NODES ====================================\\
  FocusNode userPasswordFN = FocusNode();
  FocusNode confirmPasswordFN = FocusNode();

  //=========================== BOOL VALUES====================================\\
  bool isLoading = false;
  bool isPWSuccess = false;
  var isObscured;

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
      "Password Reset successful",
      kSecondaryColor,
      const Duration(
        seconds: 2,
      ),
    );

    // Navigate to the new page
    Get.offAll(
      () => const Login(),
      duration: const Duration(milliseconds: 500),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      routeName: "Send OTP",
      predicate: (route) => false,
      popGesture: true,
      transition: Transition.rightToLeftWithFade,
    );

    setState(() {
      isLoading = false;
    });
  }

  //=========================== STATES ====================================\\

  @override
  void initState() {
    super.initState();
    isObscured = true;
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
                title: "Reset Password",
                subtitle:
                    "Just enter a new password here and you are good to go!",
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
                                'Enter New Password',
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
                            PasswordTextFormField(
                              controller: userPasswordEC,
                              passwordFocusNode: userPasswordFN,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: isObscured,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                RegExp passwordPattern = RegExp(
                                  r'^.{8,}$',
                                );
                                if (value == null || value!.isEmpty) {
                                  userPasswordFN.requestFocus();
                                  return "Enter your password";
                                } else if (!passwordPattern.hasMatch(value)) {
                                  userPasswordFN.requestFocus();
                                  return "Password must be at least 8 characters";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                userPasswordEC.text = value;
                              },
                              suffixIcon: const IconButton(
                                onPressed: null,
                                icon: Icon(null),
                              ),
                            ),
                            kSizedBox,
                            kHalfSizedBox,
                            FlutterPwValidator(
                              uppercaseCharCount: 1,
                              lowercaseCharCount: 1,
                              numericCharCount: 1,
                              controller: userPasswordEC,
                              width: 400,
                              height: 150,
                              minLength: 8,
                              onSuccess: () {
                                setState(() {
                                  isPWSuccess = true;
                                });
                                myFixedSnackBar(
                                  context,
                                  "Password matches requirement",
                                  kSuccessColor,
                                  const Duration(
                                    seconds: 1,
                                  ),
                                );
                              },
                              onFail: () {
                                setState(() {
                                  isPWSuccess = false;
                                });
                              },
                            ),
                            kSizedBox,
                            const SizedBox(
                              child: Text(
                                'Confirm Password',
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
                            PasswordTextFormField(
                              controller: confirmPasswordEC,
                              passwordFocusNode: confirmPasswordFN,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: isObscured,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                RegExp passwordPattern = RegExp(
                                  r'^.{8,}$',
                                );
                                if (value == null || value!.isEmpty) {
                                  confirmPasswordFN.requestFocus();
                                  return "Enter your password";
                                }
                                if (value != userPasswordEC.text) {
                                  confirmPasswordFN.requestFocus();
                                  return "Password does not match";
                                } else if (!passwordPattern.hasMatch(value)) {
                                  confirmPasswordFN.requestFocus();
                                  return "Password must be at least 8 characters";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                confirmPasswordEC.text = value;
                              },
                              suffixIcon: const IconButton(
                                onPressed: null,
                                icon: Icon(null),
                              ),
                            ),
                          ],
                        ),
                      ),
                      kSizedBox,
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
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: kAccentColor,
                                fixedSize: Size(media.size.width, 50),
                              ),
                              child: Text(
                                'Save'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                      kSizedBox,
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
