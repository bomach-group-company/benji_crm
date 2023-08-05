// ignore_for_file: unused_local_variable

import 'package:benji_aggregator/src/providers/custom%20show%20search.dart';
import 'package:benji_aggregator/src/skeletons/page_skeleton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../src/common_widgets/my_appbar.dart';
import '../../../theme/colors.dart';

class SimilarProductsPage extends StatefulWidget {
  const SimilarProductsPage({
    super.key,
  });

  @override
  State<SimilarProductsPage> createState() => _SimilarProductsPageState();
}

class _SimilarProductsPageState extends State<SimilarProductsPage>
    with SingleTickerProviderStateMixin {
  //=================================== ALL VARIABLES ====================================\\
//===================== BOOL VALUES =======================\\
  // bool isLoading = false;
  late bool _loadingScreen;

  //=================================== CONTROLLERS ====================================\\
  final ScrollController _scrollController = ScrollController();

//===================== KEYS =======================\\
  // final _formKey = GlobalKey<FormState>();

//======================================================================================\\
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

//==========================================================================================\\

//===================== FUNCTIONS =======================\\

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

  //=================================== Show Popup Menu =====================================\\
  //Show popup menu
  void showPopupMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    const position = RelativeRect.fromLTRB(10, 60, 0, 0);

    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        const PopupMenuItem<String>(
          value: 'nothing',
          child: Text('nothing'),
        ),
      ],
    ).then((value) {
      // Handle the selected value from the popup menu
      if (value != null) {
        switch (value) {
          case 'nothing':
            () {};
            break;
        }
      }
    });
  }

  //===================== Navigation ==========================\\

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

//====================================================================================\\

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
          title: "Similar Products",
          elevation: 0.0,
          backgroundColor: kPrimaryColor,
          toolbarHeight: 40,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: Icon(
                Icons.search,
                color: kAccentColor,
              ),
            ),
            IconButton(
              onPressed: () => showPopupMenu(context),
              icon: Icon(
                Icons.more_vert,
                color: kAccentColor,
              ),
            ),
          ],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: FutureBuilder(builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              Center(child: SpinKitDoubleBounce(color: kAccentColor));
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
                ? Center(child: SpinKitDoubleBounce(color: kAccentColor))
                : Scrollbar(
                    controller: _scrollController,
                    radius: const Radius.circular(10),
                    scrollbarOrientation: ScrollbarOrientation.right,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      dragStartBehavior: DragStartBehavior.down,
                      itemCount: 30,
                      itemBuilder: (context, index) =>
                          const PageSkeleton(height: 60, width: 60),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 60,
                      ),
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
