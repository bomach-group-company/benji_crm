import 'package:benji_aggregator/controller/login_controller.dart';
import 'package:benji_aggregator/controller/notification_controller.dart';
import 'package:benji_aggregator/controller/order_controller.dart';
import 'package:benji_aggregator/controller/rider_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
<<<<<<< HEAD
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'app/others/splash_screen.dart';
=======

>>>>>>> 5ae30100fdd3a739cc791f0ea3af5cb058fdd492
import 'app/overview/overview.dart';
import 'theme/app theme.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: kTransparentColor),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
<<<<<<< HEAD

  // Get.put(UserController());
  // Get.put(VendorController());
  // Get.put(NotificationController());
  // Get.put(RiderController());
  // Get.put(OrderController());
=======
  Get.put(UserController());
  Get.put(VendorController());
  Get.put(NotificationController());
  Get.put(RiderController());
>>>>>>> 5ae30100fdd3a739cc791f0ea3af5cb058fdd492
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeft,
      title: "Benji Aggregator",
      themeMode: ThemeMode.light,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
<<<<<<< HEAD
      home: SplashScreen(),
=======
      home: OverView(),
>>>>>>> 5ae30100fdd3a739cc791f0ea3af5cb058fdd492
    );
  }
}
