import 'package:benji_aggregator/app/vendors/my_vendor_detail.dart';
import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/model/my_vendor_model.dart';
import 'package:benji_aggregator/src/components/container/myvendor_container.dart';
import 'package:benji_aggregator/src/skeletons/vendors_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import 'register_vendor.dart';

class MyVendors extends StatelessWidget {
  const MyVendors({
    super.key,
  });

//===================== Navigation ==========================\\

  void toBusinessDetailPage(MyVendorModel data) => Get.to(
        () => MyVendorDetailPage(vendor: data),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "VendorDetails",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );
  void toAddVendor() => Get.to(
        () => const RegisterVendor(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "RegisterVendor",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorController>(
      builder: (controller) {
        return SizedBox(
          child: Column(
            children: [
              controller.isLoad.value && controller.vendorMyList.isEmpty
                  ? const VendorsListSkeleton()
                  : ListView.separated(
                      separatorBuilder: (context, index) => kHalfSizedBox,
                      itemCount: controller.vendorMyList.length,
                      addAutomaticKeepAlives: true,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => InkWell(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: ShapeDecoration(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
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
                          child: MyVendorContainer(
                            onTap: () => toBusinessDetailPage(
                              controller.vendorMyList[index],
                            ),
                            vendor: controller.vendorMyList[index],
                          ),
                        ),
                      ),
                    ),
              kSizedBox,
              GetBuilder<VendorController>(
                builder: (controller) => Column(
                  children: [
                    controller.isLoadMoreMyVendor.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: kAccentColor,
                            ),
                          )
                        : const SizedBox(),
                    controller.loadedAllMyVendor.value
                        ? Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            height: 10,
                            width: 10,
                            decoration: ShapeDecoration(
                                shape: const CircleBorder(),
                                color: kPageSkeletonColor),
                          )
                        : const SizedBox(),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
