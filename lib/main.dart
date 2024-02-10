import 'dart:io';

import 'package:benji_aggregator/controller/account_controller.dart';
import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/business_controller.dart';
import 'package:benji_aggregator/controller/category_controller.dart';
import 'package:benji_aggregator/controller/form_controller.dart';
import 'package:benji_aggregator/controller/latlng_detail_controller.dart';
import 'package:benji_aggregator/controller/notification_controller.dart';
import 'package:benji_aggregator/controller/order_controller.dart';
import 'package:benji_aggregator/controller/payment_controller.dart';
import 'package:benji_aggregator/controller/product_controller.dart';
import 'package:benji_aggregator/controller/profile_controller.dart';
import 'package:benji_aggregator/controller/rider_controller.dart';
import 'package:benji_aggregator/controller/rider_history_controller.dart';
import 'package:benji_aggregator/controller/send_package_controller.dart';
import 'package:benji_aggregator/controller/shopping_location_controller.dart';
import 'package:benji_aggregator/controller/url_launch_controller.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/controller/withdraw_controller.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/splash_screens/splash_screen.dart';
import 'controller/fcm_messaging_controller.dart';
import 'controller/login_controller.dart';
import 'controller/push_notifications_controller.dart';
import 'controller/reviews_controller.dart';
import 'controller/user_controller.dart';
import 'firebase_options.dart';
import 'theme/app theme.dart';

late SharedPreferences prefs;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: kTransparentColor),
  );
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.put(FcmMessagingController());

  Get.put(UserController());
  Get.put(LoginController());
  Get.put(NotificationController());
  Get.put(AccountController());
  Get.put(ProfileController());
  Get.put(RiderController());
  Get.put(VendorController());
  Get.put(WithdrawController());
  Get.put(OrderController());
  Get.put(LatLngDetailController());
  Get.put(FormController());
  Get.put(WithdrawController());
  Get.put(RiderController());
  Get.put(RiderHistoryController());
  Get.put(OrderController());
  Get.put(BusinessController());
  Get.put(ProductController());
  Get.put(PaymentController());
  Get.put(ApiProcessorController());
  Get.put(UrlLaunchController());
  Get.put(SendPackageController());
  Get.put(CategoryController());
  Get.put(ReviewsController());
  Get.put(ShoppingLocationController());

  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await PushNotificationController.initializeNotification();
    await FcmMessagingController.instance.handleFCM();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.rightToLeft,
        title: "Benji CRM",
        color: kPrimaryColor,
        navigatorKey: Get.key,
        themeMode: ThemeMode.light,
        darkTheme: AppTheme.darkTheme,
        theme: AppTheme.lightTheme,
        home: SplashScreen(),
      );
    }
    if (Platform.isIOS) {
      return GetCupertinoApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.rightToLeft,
        navigatorKey: Get.key,
        title: "Benji CRM",
        color: kPrimaryColor,
        theme: AppTheme.iOSDarkTheme,
        home: SplashScreen(),
      );
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeft,
      navigatorKey: Get.key,
      title: "Benji CRM",
      color: kPrimaryColor,
      themeMode: ThemeMode.light,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
    );
  }
}
