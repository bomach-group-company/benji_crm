import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../model/package/delivery_item.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/card/empty.dart';
import '../../src/components/section/my_liquid_refresh.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../src/utils/constants.dart';
import '../../theme/colors.dart';
import '../riders/check_for_available_rider_for_package_delivery.dart';
import 'send_package.dart';

class PackagesDraft extends StatefulWidget {
  const PackagesDraft({super.key});

  @override
  State<PackagesDraft> createState() => _PackagesDraftState();
}

class _PackagesDraftState extends State<PackagesDraft>
    with SingleTickerProviderStateMixin {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();
    packages = getPackageData();
    scrollController.addListener(scrollListener);
  }

  late Future<List<DeliveryItem>> packages;
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool isScrollToTopBtnVisible = false;
  bool refreshing = false;

//================================================= CONTROLLERS ===================================================\\
  late TabController tabBarController;
  final scrollController = ScrollController();
//================================================= FUNCTIONS ===================================================\\

  Future<List<DeliveryItem>> getPackageData() async {
    List<DeliveryItem> packages =
        await getDeliveryItemsByClientAndPaymentStatus();
    return packages;
  }

  Future<void> handleRefresh() async {
    setState(() {
      refreshing = true;
    });
    setState(() {
      packages = getPackageData();
    });
    await Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        refreshing = false;
      });
    });
  }

  //===================== Scroll to Top ==========================\\
  Future<void> scrollToTop() async {
    await scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      isScrollToTopBtnVisible = false;
    });
  }

  Future<void> scrollListener() async {
    if (scrollController.position.pixels >= 100 &&
        isScrollToTopBtnVisible != true) {
      setState(() {
        isScrollToTopBtnVisible = true;
      });
    }
    if (scrollController.position.pixels < 100 &&
        isScrollToTopBtnVisible == true) {
      setState(() {
        isScrollToTopBtnVisible = false;
      });
    }
  }

//================================================= Navigation ===================================================\\

  void toPayment(DeliveryItem deliveryItem) {
    Get.to(
      () => CheckForAvailableRiderForPackageDelivery(
        packageId: deliveryItem.id,
        senderName: deliveryItem.senderName,
        senderPhoneNumber: deliveryItem.senderPhoneNumber,
        receiverName: deliveryItem.receiverName,
        receiverPhoneNumber: deliveryItem.receiverPhoneNumber,
        dropOff: deliveryItem.dropOffAddress,
        itemName: deliveryItem.itemName,
        itemQuantity: deliveryItem.itemQuantity.toString(),
        itemWeight: deliveryItem.itemWeight.toString(),
        itemValue: deliveryItem.itemValue.toString(),
        itemCategory: deliveryItem.itemCategory.id,
      ),
      routeName: 'check-for-available-rider',
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );

    // Get.to(
    //   () => PayForDelivery(
    //     packageId: deliveryItem.id,
    //     senderName: deliveryItem.senderName,
    //     senderPhoneNumber: deliveryItem.senderPhoneNumber,
    //     receiverName: deliveryItem.receiverName,
    //     receiverPhoneNumber: deliveryItem.receiverPhoneNumber,
    //     receiverLocation: deliveryItem.dropOffAddress,
    //     itemName: deliveryItem.itemName,
    //     itemQuantity: deliveryItem.itemQuantity.toString(),
    //     itemWeight: deliveryItem.itemWeight.toString(),
    //     itemValue: deliveryItem.itemValue.toString(),
    //     itemCategory: deliveryItem.itemCategory.id,
    //   ),
    //   routeName: 'PayForDelivery',
    //   duration: const Duration(milliseconds: 300),
    //   fullscreenDialog: true,
    //   curve: Curves.easeIn,
    //   preventDuplicates: true,
    //   popGesture: true,
    //   transition: Transition.rightToLeft,
    // );
  }

  void toSendPackageScreen() => Get.off(
        () => const SendPackage(),
        routeName: 'SendPackage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  //========================================================================\\

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MyLiquidRefresh(
      onRefresh: handleRefresh,
      child: Scaffold(
        appBar: MyAppBar(
          title: "My Draft Packages",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        floatingActionButton: isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: scrollToTop,
                mini: deviceType(media.width) > 2 ? false : true,
                backgroundColor: kAccentColor,
                foregroundColor: kPrimaryColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: const FaIcon(FontAwesomeIcons.chevronUp, size: 18),
              )
            : const SizedBox(),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                    // padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: refreshing
                        ? Center(
                            child: Column(
                              children: [
                                kSizedBox,
                                CircularProgressIndicator(color: kAccentColor),
                              ],
                            ),
                          )
                        : FutureBuilder(
                            future: packages,
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return SizedBox(
                                  width: media.width,
                                  child: Column(
                                    children: [
                                      snapshot.data!.isEmpty
                                          ? EmptyCard(
                                              emptyCardMessage:
                                                  "You don't have any packages yet",
                                              showButton: true,
                                              buttonTitle: "Send a package",
                                              onPressed: toSendPackageScreen,
                                            )
                                          : ListView.separated(
                                              reverse: true,
                                              separatorBuilder: (context,
                                                      index) =>
                                                  Divider(color: kGreyColor2),
                                              itemCount: snapshot.data!.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder: (context, index) =>
                                                  ListTile(
                                                onTap: () => toPayment(
                                                    snapshot.data![index]),
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                                enableFeedback: true,
                                                dense: true,
                                                leading: FaIcon(
                                                  FontAwesomeIcons.boxesStacked,
                                                  color: kAccentColor,
                                                ),
                                                title: Text(
                                                  snapshot
                                                      .data![index].itemName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    color: kTextBlackColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                subtitle: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                          text:
                                                              "Delivery fee:"),
                                                      const TextSpan(text: " "),
                                                      TextSpan(
                                                        text:
                                                            "₦${doubleFormattedText(snapshot.data![index].deliveryFee)}",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily: 'sen',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                trailing: FaIcon(
                                                  FontAwesomeIcons
                                                      .hourglassHalf,
                                                  color: kLoadingColor,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                );
                              }
                              return Center(
                                child: Column(
                                  children: [
                                    kSizedBox,
                                    CircularProgressIndicator(
                                      color: kAccentColor,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
