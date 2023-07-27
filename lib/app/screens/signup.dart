// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../src/common_widgets/email textformfield.dart';
import '../../src/common_widgets/my fixed snackBar.dart';
import '../../src/common_widgets/my intl phonefield.dart';
import '../../src/common_widgets/name textformfield.dart';
import '../../src/common_widgets/password textformfield.dart';
import '../../src/common_widgets/reusable authentication first half.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/signup controller.dart';
import '../../theme/colors.dart';
import '../splash screens/signup splash screen.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //=========================== ALL VARIABBLES ====================================\\

  //=========================== CONTROLLER ====================================\\
  final controller = Get.put(SignupController());

  //=========================== KEYS ====================================\\
  final _formKey = GlobalKey<FormState>();

  //=========================== BOOL VALUES ====================================\\
  bool isLoading = false;
  bool isChecked = false;
  bool isPWSuccess = false;
  var isObscured;

  //=========================== FOCUS NODES ====================================\\
  FocusNode userFirstNameFN = FocusNode();
  FocusNode userLastNameFN = FocusNode();
  FocusNode userPhoneNumberFN = FocusNode();
  FocusNode userEmailFN = FocusNode();
  FocusNode userPasswordFN = FocusNode();

  //=========================== FUNCTIONS ====================================\\
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    // Simulating a delay of 2 seconds
    Future.delayed(const Duration(seconds: 2));

    // SignupController.instance.registerUser(
    //   controller.userEmailEC.text.trim(),
    //   controller.userPasswordEC.text.trim(),
    // );
    //Display snackBar
    myFixedSnackBar(
      context,
      "Signup Successful".toUpperCase(),
      kSuccessColor,
      const Duration(seconds: 2),
    );

    // Navigate to the new page
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SignUpSplashScreen()),
      (route) => false,
    );

    setState(() {
      isLoading = false;
    });
  }

  //=========================== INITIAL STATE ====================================\\
  @override
  void initState() {
    super.initState();
    isObscured = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              const ReusableAuthenticationFirstHalf(
                title: "Sign up",
                subtitle: "Please sign up to get started",
                decoration: BoxDecoration(),
                imageContainerHeight: 0,
              ),
              kSizedBox,
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    top: kDefaultPadding / 2,
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                        24,
                      ),
                      topRight: Radius.circular(
                        24,
                      ),
                    ),
                    color: kPrimaryColor,
                  ),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              child: Text(
                                'First Name',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(
                                    0xFF31343D,
                                  ),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            kHalfSizedBox,
                            NameTextFormField(
                              controller: controller.userFirstNameEC,
                              validator: (value) {
                                RegExp userNamePattern = RegExp(
                                  r'^.{3,}$', //Min. of 3 characters
                                );
                                if (value == null || value!.isEmpty) {
                                  userFirstNameFN.requestFocus();
                                  return "Enter your first name";
                                } else if (!userNamePattern.hasMatch(value)) {
                                  userFirstNameFN.requestFocus();
                                  return "Name must be at least 3 characters";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                controller.userFirstNameEC.text = value;
                              },
                              textInputAction: TextInputAction.next,
                              nameFocusNode: userFirstNameFN,
                              hintText: "Enter first name",
                            ),
                            kSizedBox,
                            const SizedBox(
                              child: Text(
                                'Last Name',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(
                                    0xFF31343D,
                                  ),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            kHalfSizedBox,
                            NameTextFormField(
                              controller: controller.userLastNameEC,
                              validator: (value) {
                                RegExp userNamePattern = RegExp(
                                  r'^.{3,}$', //Min. of 3 characters
                                );
                                if (value == null || value!.isEmpty) {
                                  userLastNameFN.requestFocus();
                                  return "Enter your last name";
                                } else if (!userNamePattern.hasMatch(value)) {
                                  userLastNameFN.requestFocus();
                                  return "Name must be at least 3 characters";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                controller.userLastNameEC.text = value;
                              },
                              textInputAction: TextInputAction.next,
                              nameFocusNode: userLastNameFN,
                              hintText: "Enter last name",
                            ),
                            kSizedBox,
                            const SizedBox(
                              child: Text(
                                'Email',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(
                                    0xFF31343D,
                                  ),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            kHalfSizedBox,
                            EmailTextFormField(
                              controller: controller.userEmailEC,
                              emailFocusNode: userEmailFN,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                RegExp emailPattern = RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                                );
                                if (value == null || value!.isEmpty) {
                                  userEmailFN.requestFocus();
                                  return "Enter your email address";
                                } else if (!emailPattern.hasMatch(value)) {
                                  userEmailFN.requestFocus();
                                  return "Please enter a valid email address";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                controller.userEmailEC.text = value;
                              },
                            ),
                            kSizedBox,
                            const SizedBox(
                              child: Text(
                                'Phone Number',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(
                                    0xFF31343D,
                                  ),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            kHalfSizedBox,
                            MyIntlPhoneField(
                              controller: controller.userPhoneNumberEC,
                              initialCountryCode: "NG",
                              invalidNumberMessage: "Invalid Phone Number",
                              dropdownIconPosition: IconPosition.trailing,
                              showCountryFlag: true,
                              showDropdownIcon: true,
                              dropdownIcon: Icon(
                                Icons.arrow_drop_down_rounded,
                                color: kAccentColor,
                              ),
                              validator: (value) {
                                if (value.isBlank) {
                                  return "Enter your phone number";
                                }
                              },
                              onSaved: (value) {
                                controller.userPhoneNumberEC.text = value!;
                              },
                              textInputAction: TextInputAction.next,
                              focusNode: userPhoneNumberFN,
                            ),
                            kSizedBox,
                            const SizedBox(
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  color: Color(
                                    0xFF31343D,
                                  ),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            kHalfSizedBox,
                            PasswordTextFormField(
                              controller: controller.userPasswordEC,
                              passwordFocusNode: userPasswordFN,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: isObscured,
                              textInputAction: TextInputAction.done,
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
                                controller.userPasswordEC.text = value;
                              },
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscured = !isObscured;
                                  });
                                },
                                icon: isObscured
                                    ? const Icon(
                                        Icons.visibility,
                                      )
                                    : Icon(
                                        Icons.visibility_off_rounded,
                                        color: kSecondaryColor,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      kHalfSizedBox,
                      FlutterPwValidator(
                        uppercaseCharCount: 1,
                        lowercaseCharCount: 1,
                        numericCharCount: 1,
                        controller: controller.userPasswordEC,
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
                                backgroundColor: kAccentColor,
                                maximumSize: Size(
                                  MediaQuery.of(context).size.width,
                                  62,
                                ),
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width,
                                  60,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    16,
                                  ),
                                ),
                                elevation: 10,
                                shadowColor: kDarkGreyColor,
                              ),
                              child: Text(
                                "Sign up".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                      kHalfSizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Color(
                                0xFF646982,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            },
                            child: Text(
                              "Log in",
                              style: TextStyle(color: kAccentColor),
                            ),
                          ),
                        ],
                      ),
                      kHalfSizedBox,
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "Or sign up with ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(
                                  0xFF646982,
                                ),
                              ),
                            ),
                            kSizedBox,
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {},
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                  border: Border.all(
                                    color: kGreyColor1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/images/icons/google-signup-icon.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Google",
                                      style: TextStyle(
                                        color: kTextBlackColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            kSizedBox,
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
