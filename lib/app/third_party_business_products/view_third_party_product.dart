// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../controller/form_controller.dart';
import '../../controller/product_controller.dart';
import '../../model/product_model.dart';
import '../../services/api_url.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/button/my_elevatedButton.dart';
import '../../src/components/image/my_image.dart';
import '../../src/components/responsive_widgets/padding.dart';
import '../../src/components/sheet/showModalBottomSheet.dart';
import '../../src/components/sheet/showModalBottomSheetTitleWithIcon.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../src/utils/constants.dart';
import '../../theme/colors.dart';
import 'change_third_party_product_image.dart';
import 'edit_third_party_product.dart';

class ViewThirdPartyProduct extends StatefulWidget {
  final ProductModel product;
  const ViewThirdPartyProduct({super.key, required this.product});

  @override
  State<ViewThirdPartyProduct> createState() => _ViewThirdPartyProductState();
}

class _ViewThirdPartyProductState extends State<ViewThirdPartyProduct> {
  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    log(widget.product.productImage);
    log("Product id: ${widget.product.id}");
    log("Sub category id: ${widget.product.subCategory.id}");
  }

  @override
  void dispose() {
    carouselController.stopAutoPlay();
    super.dispose();
  }

  bool deleteProductLoad = false;
  bool isScrollToTopBtnVisible = false;
  final scrollController = ScrollController();
  final carouselController = CarouselController();

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
    if (scrollController.position.pixels >= 200 &&
        isScrollToTopBtnVisible != true) {
      setState(() {
        isScrollToTopBtnVisible = true;
      });
    }
    if (scrollController.position.pixels < 200 &&
        isScrollToTopBtnVisible == true) {
      setState(() {
        isScrollToTopBtnVisible = false;
      });
    }
  }

  void deleteModal() => Get.defaultDialog(
        title: "You are about to delete:",
        titlePadding: const EdgeInsets.all(10),
        titleStyle: const TextStyle(
          fontSize: 18,
          color: kTextBlackColor,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.all(0),
        content: Text(
          widget.product.name,
          style: const TextStyle(
            color: kTextBlackColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        cancel: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            onPressed: Get.back,
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: kAccentColor.withOpacity(0.5),
              backgroundColor: kGreyColor1,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: kBlackColor.withOpacity(0.4),
              minimumSize: Size(MediaQuery.of(context).size.width, 60),
            ),
            child: Text(
              "Cancel".toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18,
                fontFamily: "Sen",
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        confirm: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: GetBuilder<FormController>(
            id: 'deleteProduct',
            builder: (controller) => MyElevatedButton(
              title: 'Delete',
              onPressed: deleteProduct,
              isLoading: controller.isLoad.value,
            ),
          ),
        ),
      );

  deleteProduct() async {
    setState(() {
      deleteProductLoad = true;
    });
    await FormController.instance.deleteAuth(
        Api.baseUrl + Api.deleteProduct + widget.product.id,
        'deleteProduct',
        'Error occured',
        'Deleted successfully');
    // final response = await http.delete(
    //   Uri.parse(Api.baseUrl + Api.deleteProduct + widget.product.id),
    //   headers: authHeader(),
    // );

    final status = FormController.instance.status;
    setState(() {
      deleteProductLoad = false;
    });
    consoleLog('${status.value} ooo');
    if (status.value != 200) {
      return;
    }
    ProductController.instance.reset();
    Get.close(1);
    // Get.offAll(
    //   () => const OverView(currentIndex: 2),
    //   routeName: 'OverView',
    //   duration: const Duration(milliseconds: 300),
    //   fullscreenDialog: true,
    //   curve: Curves.easeIn,
    //   popGesture: true,
    //   transition: Transition.rightToLeft,
    // );
  }

  editProduct() async {
    Navigator.pop(context);
    await Get.to(
      () => EditThirdPartyProduct(product: widget.product),
      routeName: 'EditThirdPartyProduct',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  changeProductImage() {
    Get.to(
      () => ChangeThirdPartyProductImage(product: widget.product),
      routeName: 'ChangeThirdPartyProductImage',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  Widget productOptions() {
    return MyResponsivePadding(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            const ShowModalBottomSheetTitleWithIcon(title: "Option"),
            kSizedBox,
            ListTile(
              onTap: editProduct,
              leading:
                  FaIcon(FontAwesomeIcons.pen, color: kAccentColor, size: 16),
              title: Text(
                'Edit',
                style: TextStyle(
                  color: kTextGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.32,
                ),
              ),
            ),
            ListTile(
              onTap: deleteModal,
              leading: FaIcon(FontAwesomeIcons.solidTrashCan,
                  color: kAccentColor, size: 16),
              title: Text(
                'Delete',
                style: TextStyle(
                  color: kTextGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return MyResponsivePadding(
      child: Scaffold(
        appBar: MyAppBar(
          title: "Product Detail",
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                ShowModalBottomSheet(
                  context,
                  20.0,
                  deviceType(media.width) >= 2
                      ? media.height * 0.6
                      : media.height * 0.4,
                  deviceType(media.width) >= 2
                      ? media.height * 0.5
                      : media.height * 0.3,
                  productOptions(),
                );
              },
              icon: FaIcon(
                FontAwesomeIcons.ellipsisVertical,
                color: kAccentColor,
                size: 18,
              ),
            ),
          ],
          backgroundColor: kPrimaryColor,
        ),
        floatingActionButton: isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: scrollToTop,
                mini: true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: const Icon(Icons.keyboard_arrow_up),
              )
            : const SizedBox(),
        body: Scrollbar(
          child: ListView(
            controller: scrollController,
            physics: const ScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            children: [
              FlutterCarousel.builder(
                options: CarouselOptions(
                  height:
                      deviceType(media.width) > 3 && deviceType(media.width) < 5
                          ? media.height * 0.5
                          : media.height * 0.42,
                  viewportFraction: 1.0,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.easeInOut,
                  enlargeCenterPage: true,
                  controller: carouselController,
                  onPageChanged: (index, value) {
                    setState(() {});
                  },
                  pageSnapping: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  scrollBehavior: const ScrollBehavior(),
                  pauseAutoPlayOnTouch: true,
                  pauseAutoPlayOnManualNavigate: true,
                  pauseAutoPlayInFiniteScroll: false,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  disableCenter: false,
                  showIndicator: true,
                  floatingIndicator: true,
                  slideIndicator: CircularSlideIndicator(
                    alignment: Alignment.bottomCenter,
                    currentIndicatorColor: kAccentColor,
                    indicatorBackgroundColor: kPrimaryColor,
                    indicatorRadius: 5,
                    padding: const EdgeInsets.all(10),
                  ),
                ),
                itemCount: widget.product.productImage.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: media.width,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    child: MyImage(url: widget.product.productImage),
                  ),
                ),
              ),
              TextButton(
                onPressed: changeProductImage,
                child: Text(
                  "Change product image",
                  style: TextStyle(
                    color: kAccentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              kSizedBox,
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: media.width,
                      padding: const EdgeInsets.all(kDefaultPadding),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFEF8F8),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 0.50,
                            color: Color(0xFFFDEDED),
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 24,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Product Name",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: kTextGreyColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              kHalfSizedBox,
                              SizedBox(
                                width: media.width / 2.3,
                                child: Text(
                                  widget.product.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Product price",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: kTextGreyColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              kHalfSizedBox,
                              SizedBox(
                                width: media.width / 3,
                                child: Text(
                                  "₦ ${doubleFormattedText(widget.product.price)}",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 22,
                                    fontFamily: 'sen',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    kSizedBox,
                    SizedBox(
                      width: media.width / 3,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Qty: ",
                              style: TextStyle(
                                color: kTextGreyColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: intFormattedText(
                                  widget.product.quantityAvailable),
                              style: const TextStyle(
                                color: kTextBlackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    kSizedBox,
                    Container(
                      width: media.width,
                      padding: const EdgeInsets.all(kDefaultPadding),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFEF8F8),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 0.50,
                            color: Color(0xFFFDEDED),
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 24,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Product Description",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: kTextGreyColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          kHalfSizedBox,
                          ReadMoreText(
                            widget.product.description,
                            callback: (value) {},
                            colorClickableText: kAccentColor,
                            moreStyle: TextStyle(color: kAccentColor),
                            lessStyle: TextStyle(color: kAccentColor),
                            delimiter: "...",
                            delimiterStyle: TextStyle(color: kAccentColor),
                            trimMode: TrimMode.Line,
                            trimLines: 4,
                          ),
                        ],
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
    );
  }
}
