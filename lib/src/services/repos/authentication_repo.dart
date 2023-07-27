// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../app/dashboard/dashboard.dart';
import '../../../app/splash screens/startup splash screen.dart';
import 'signup_email_password_failure.dart';

class AuthenticationRepo extends GetxController {
  static AuthenticationRepo get instance => Get.find();

  //Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();

    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const StartupSplashscreen())
        : Get.offAll(() => const Dashboard());
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser.value != null
          ? Get.offAll(() => const Dashboard())
          : Get.offAll(() => const StartupSplashscreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignupWithEmailAndPasswordFailure.code(e.code);
      print("FIRBASE AUTH EXCEPTION - ${ex.message}");
      throw ex;
    } catch (_) {
      const ex = SignupWithEmailAndPasswordFailure();
      print("EXCEPTION - ${ex.message}");
      throw ex;
    }
  }

  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (_) {}
  }

  Future<void> logout() async => await _auth.signOut();
}
