import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/src/skeletons/vendors_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../src/common_widgets/my_appbar.dart';
import '../../../theme/colors.dart';

class MyVendors extends StatefulWidget {
  const MyVendors({super.key});

  @override
  State<MyVendors> createState() => _MyVendorsState();
}

class _MyVendorsState extends State<MyVendors> {
  //=================================== ALL VARIABLES ====================================\\

  //===================== BOOL VALUES =======================\\
  late bool _loadingScreen;

  //=================================== CONTROLLERS ====================================\\
  final ScrollController _scrollController = ScrollController();

//==========================================================================================\\
  @override
  void initState() {
    _loadingScreen = true;
    Future.delayed(
      const Duration(seconds: 3),
      () => setState(
        () => _loadingScreen = false,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//==========================================================================================\\

  //============================================= FUNCTIONS ===============================================\\

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _loadingScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: kAccentColor,
      borderWidth: 5.0,
      backgroundColor: kPrimaryColor,
      height: 150,
      animSpeedFactor: 2,
      showChildOpacityTransition: false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: "My Vendors",
          elevation: 0.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        body: SafeArea(
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const VendorsListSkeleton();
              }
              if (snapshot.connectionState == ConnectionState.none) {
                const Center(
                  child: Text("Please connect to the internet"),
                );
              }
              // if (snapshot.connectionState == snapshot.requireData) {
              //   SpinKitDoubleBounce(color: kAccentColor);
              // }
              if (snapshot.connectionState == snapshot.error) {
                const Center(
                  child: Text("Error, Please try again later"),
                );
              }
              return _loadingScreen
                  ? const Padding(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: VendorsListSkeleton(),
                    )
                  : Scrollbar(
                      controller: _scrollController,
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(kDefaultPadding),
                        children: const [],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
