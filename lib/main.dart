import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

import 'app/overview/overview.dart';
import 'theme/app theme.dart';
import 'theme/colors.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeft,
      title: "Benji Aggregator",
      color: kSecondaryColor,
      themeMode: ThemeMode.light,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      home: OverView(),
      // home: RidersDetail(
      //     ridersImage: "jerry_emmanuel",
      //     ridersName: "Jerry Emmanuel",
      //     ridersPhoneNumber: "08032300044",
      //     noOfTrips: 238,
      //     onlineIndicator: Container(
      //       height: 20,
      //       width: 20,
      //       decoration: const ShapeDecoration(
      //         color: kSuccessColor,
      //         shape: OvalBorder(),
      //       ),
      //     ))
      // home: VendorDetailsPage(
      //   vendorCoverImage: "ntachi-osa",
      //   vendorName: "Ntachi Osa",
      //   vendorRating: 4.5,
      //   vendorActiveStatus: "Online",
      //   vendorActiveStatusColor: kSuccessColor,
      // ),
      // home: Vendors(
      //   showNavigation: () {},
      //   hideNavigation: () {},
      //   appBarBackgroundColor: kPrimaryColor,
      //   appTitleColor: kTextBlackColor,
      //   appBarSearchIconColor: kAccentColor,
      // ),
    );
  }
}
