// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:benji_aggregator/controller/login_controller.dart';
import 'package:benji_aggregator/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/common_widgets/email_textformfield.dart';
import '../../src/common_widgets/my_fixed_snackBar.dart';
import '../../src/common_widgets/password_textformfield.dart';
import '../../src/common_widgets/reusable_authentication_firsthalf.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../splash_screens/login_splashscreen.dart';
import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var login = Get.put(LoginController());
  //=========================== INITIAL STATE ====================================\\
  @override
  void initState() {
    super.initState();
    _isObscured = true;
  }

  //=========================== ALL VARIABBLES ====================================\\

  //=========================== CONTROLLERS ====================================\\

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //=========================== KEYS ====================================\\

  final _formKey = GlobalKey<FormState>();

  //=========================== BOOL VALUES ====================================\\

  bool isLoading = false;
  bool _isChecked = false;
  var _isObscured;

  //=========================== STYLE ====================================\\

  TextStyle myAccentFontStyle = TextStyle(
    color: kAccentColor,
  );

  //=========================== FOCUS NODES ====================================\\
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  //=========================== FUNCTIONS ====================================\\

  //Navigate to forgotPassword
  void _toForgotPasswordPage() => Get.to(
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
      routeName: "LoginSplashScreen",
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.fadeIn,
    );

    setState(() {
      isLoading = false;
    });
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
                curves: Curves.easeInOut,
                duration: Duration(milliseconds: 300),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.rightToBracket,
                    color: kSecondaryColor,
                    size: 80,
                    semanticLabel: "lock_icon",
                  ),
                ),
                decoration: ShapeDecoration(
                  color: kPrimaryColor,
                  shape: OvalBorder(),
                ),
                imageContainerHeight: 120,
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
                              obscureText: _isObscured,
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
                                    _isObscured = !_isObscured;
                                  });
                                },
                                icon: _isObscured
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
                                value: _isChecked,
                                splashRadius: 50,
                                activeColor: kSecondaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _isChecked = newValue!;
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
                              _toForgotPasswordPage();
                            },
                            child: Text(
                              "Forgot Password",
                              style: myAccentFontStyle,
                            ),
                          ),
                        ],
                      ),
                      kSizedBox,
                      GetBuilder<LoginController>(builder: (controller) {
                        return controller.isLoad.value
                            ? Center(
                                child: SpinKitChasingDots(
                                  color: kAccentColor,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: (() async {
                                  if (_formKey.currentState!.validate()) {
                                    SendLogin data = SendLogin(
                                        password: passwordController.text,
                                        username: emailController.text);

                                    await controller.runLoginTask(data);
                                  }
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kAccentColor,
                                  maximumSize: Size(
                                      MediaQuery.of(context).size.width, 62),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 60),
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
                              );
                      }),
                      kHalfSizedBox,
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
