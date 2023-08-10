// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/email_textformfield.dart';
import '../../src/common_widgets/my_fixed_snackBar.dart';
import '../../src/common_widgets/password_textformfield.dart';
import '../../src/common_widgets/reusable_authentication_firsthalf.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../splash_screens/login_splashscreen.dart';
import 'forgot_password.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //=========================== ALL VARIABBLES ====================================\\

  //=========================== CONTROLLERS ====================================\\

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //=========================== KEYS ====================================\\

  final _formKey = GlobalKey<FormState>();

  //=========================== BOOL VALUES ====================================\\
  bool isLoading = false;
  bool isChecked = false;
  var isObscured;

  //=========================== STYLE ====================================\\

  TextStyle myAccentFontStyle = TextStyle(
    color: kAccentColor,
  );

  //=========================== FOCUS NODES ====================================\\
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  //=========================== FUNCTIONS ====================================\\
  //Navigate to Signup
  void toSignupPage() => Get.offAll(
        () => const SignUp(),
        duration: const Duration(milliseconds: 500),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Signup",
        predicate: (route) => false,
        popGesture: true,
        transition: Transition.downToUp,
      );

  //Navigate to forgotPassword
  void toForgotPasswordPage() => Get.to(
        () => const ForgotPassword(),
        duration: const Duration(milliseconds: 500),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Forgot Password",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    // Simulating a delay of 3 seconds
    await Future.delayed(const Duration(seconds: 2));

    //Display snackBar
    myFixedSnackBar(
      context,
      "Login Successful".toUpperCase(),
      kSuccessColor,
      const Duration(seconds: 2),
    );

    // Navigate to the new page
    Get.off(
      () => const LoginSplashScreen(),
      duration: const Duration(seconds: 2),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      routeName: "Login processing",
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.fadeIn,
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
              ReusableAuthenticationFirstHalf(
                title: "Log In",
                subtitle: "Please log in to your existing account",
                decoration: ShapeDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/login/avatar-image.png"),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(43.50),
                  ),
                ),
                imageContainerHeight: 88,
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
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
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
                              textInputAction: TextInputAction.next,
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
                            kSizedBox,
                            const SizedBox(
                              child: Text(
                                'Password',
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
                              controller: passwordController,
                              passwordFocusNode: passwordFocusNode,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: isObscured,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                RegExp passwordPattern = RegExp(
                                  r'^.{8,}$',
                                );
                                if (value == null || value!.isEmpty) {
                                  passwordFocusNode.requestFocus();
                                  return "Enter your password";
                                } else if (!passwordPattern.hasMatch(value)) {
                                  return "Password must be at least 8 characters";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                passwordController.text = value;
                              },
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscured = !isObscured;
                                  });
                                },
                                icon: isObscured
                                    ? const Icon(
                                        Icons.visibility_off_rounded,
                                      )
                                    : Icon(
                                        Icons.visibility,
                                        color: kSecondaryColor,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      kHalfSizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: isChecked,
                                splashRadius: 50,
                                activeColor: kSecondaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    isChecked = newValue!;
                                  });
                                },
                              ),
                              const Text(
                                "Remember me ",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              toForgotPasswordPage();
                            },
                            child: Text(
                              "Forgot Password",
                              style: myAccentFontStyle,
                            ),
                          ),
                        ],
                      ),
                      kSizedBox,
                      isLoading
                          ? Center(
                              child: SpinKitChasingDots(
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
                                backgroundColor: kAccentColor,
                                maximumSize:
                                    Size(MediaQuery.of(context).size.width, 62),
                                minimumSize:
                                    Size(MediaQuery.of(context).size.width, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 10,
                                shadowColor: kDarkGreyColor,
                              ),
                              child: Text(
                                "Log in".toUpperCase(),
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
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Color(
                                0xFF646982,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              toSignupPage();
                            },
                            child: Text(
                              "Sign up",
                              style: myAccentFontStyle,
                            ),
                          ),
                        ],
                      ),
                      kHalfSizedBox,
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "Or log in with ",
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
                                    color: kLightGreyColor,
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
