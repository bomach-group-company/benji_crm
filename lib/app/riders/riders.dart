// ignorFontWeight_for_file: unused_local_variable,

import 'package:benji_aggregator/controller/rider_history_controller.dart';
import 'package:benji_aggregator/src/components/my_liquid_refresh.dart';
import 'package:benji_aggregator/src/skeletons/riders_list_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/rider_controller.dart';
import '../../model/rider_model.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/custom_show_search.dart';
import '../../theme/colors.dart';
import 'riders_detail.dart';

class Riders extends StatefulWidget {
  final VoidCallback showNavigation;
  final VoidCallback hideNavigation;

  final Color appBarBackgroundColor;
  final Color appTitleColor;
  final Color appBarSearchIconColor;
  const Riders({
    super.key,
    required this.appBarBackgroundColor,
    required this.appTitleColor,
    required this.appBarSearchIconColor,
    required this.showNavigation,
    required this.hideNavigation,
  });

  @override
  State<Riders> createState() => _RidersState();
}

class _RidersState extends State<Riders> with SingleTickerProviderStateMixin {
  //===================== Initial State ==========================\\

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    scrollController.addListener(_scrollListener);
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward ||
          scrollController.position.pixels < 100) {
        widget.showNavigation();
      } else {
        widget.hideNavigation();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  //================================= ALL VARIABLES ==========================================\\
  bool _isScrollToTopBtnVisible = false;

  //============================================== CONTROLLERS =================================================\\
  final ScrollController scrollController = ScrollController();
  late AnimationController _animationController;

  //================================= FUNCTIONS ==========================================\\

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    await RiderController.instance.emptyRiderList();
    await RiderController.instance.getRiders();
  }

//============================= Scroll to Top ======================================//
  void _scrollToTop() {
    _animationController.reverse();
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels >= 100 &&
        _isScrollToTopBtnVisible != true) {
      setState(() {
        _isScrollToTopBtnVisible = true;
      });
    }
    if (scrollController.position.pixels < 100 &&
        _isScrollToTopBtnVisible == true) {
      setState(() {
        _isScrollToTopBtnVisible = false;
      });
    }

    if (RiderController.instance.loadedAll.value) {
      return;
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      await RiderController.instance.loadMore();
    }
  }

  //===================== Navigation ==========================\\

  toRidersDetailPage(RiderItem rider) {
    final riderHistory = Get.put(RiderHistoryController());
    riderHistory.setClickedRider(rider);
    return Get.to(
      () => RidersDetail(rider: rider),
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      routeName: "Rider Details",
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.downToUp,
    );
  }

  @override
  Widget build(BuildContext context) {
    void showSearchField() =>
        showSearch(context: context, delegate: CustomSearchDelegate());

    return MyLiquidRefresh(
      onRefresh: _handleRefresh,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: widget.appBarBackgroundColor,
          title: Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding),
            child: Text(
              "All Riders",
              style: TextStyle(
                fontSize: 20,
                color: widget.appTitleColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: showSearchField,
              tooltip: "Search",
              icon: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: widget.appBarSearchIconColor,
              ),
            ),
          ],
        ),
        floatingActionButton: _isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: _scrollToTop,
                mini: true,
                backgroundColor: kAccentColor,
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
          child: GetBuilder<RiderController>(initState: (state) async {
            await RiderController.instance.getRiders();
          }, builder: (controller) {
            return Scrollbar(
              controller: scrollController,
              radius: const Radius.circular(10),
              scrollbarOrientation: ScrollbarOrientation.right,
              child: ListView(
                controller: scrollController,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  bottom: kDefaultPadding,
                  right: kDefaultPadding,
                  left: kDefaultPadding,
                ),
                children: [
                  kSizedBox,
                  controller.isLoad.value && controller.riderList.isEmpty
                      // controller.isLoad.value
                      ? const RidersListSkeleton()
                      : ListView.separated(
                          separatorBuilder: (context, index) => kSizedBox,
                          itemCount: controller.riderList.length,
                          addAutomaticKeepAlives: true,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                onTap: () => toRidersDetailPage(
                                    controller.riderList[index]),
                                leading: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: kTransparentColor,
                                      backgroundImage: const AssetImage(
                                        "assets/images/profile/avatar-image.jpg",
                                      ),
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: "",
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                            color: kAccentColor,
                                          )),
                                          errorWidget: (context, url, error) =>
                                              FaIcon(
                                            FontAwesomeIcons.circleExclamation,
                                            color: kAccentColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Positioned(
                                    //   right: 10,
                                    //   bottom: 0,
                                    //   child: Container(
                                    //     height: 10,
                                    //     width: 10,
                                    //     decoration: const ShapeDecoration(
                                    //       color: kSuccessColor,
                                    //       shape: OvalBorder(),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${controller.riderList[index].firstName} ${controller.riderList[index].lastName}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    kHalfSizedBox,
                                    Text(
                                      controller.riderList[index].username,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  "${controller.riderList[index].tripCount} Trips Completed",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kTextGreyColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  kSizedBox,
                  RiderController.instance.isLoadMore.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: kAccentColor,
                          ),
                        )
                      : const SizedBox(),
                  RiderController.instance.loadedAll.value
                      ? Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          height: 10,
                          width: 10,
                          decoration: ShapeDecoration(
                              shape: const CircleBorder(),
                              color: kPageSkeletonColor),
                        )
                      : const SizedBox(),
                  kSizedBox,
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
