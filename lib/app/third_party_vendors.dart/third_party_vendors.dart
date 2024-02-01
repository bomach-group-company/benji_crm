import 'package:benji_aggregator/controller/vendor_controller.dart';
import 'package:benji_aggregator/src/skeletons/vendors_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/third_party_vendor_model.dart';
import '../../src/components/container/third_party_vendor_container.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../vendors/register_vendor.dart';
import 'third_party_vendor_detail_screen.dart';

class ThirdPartyVendors extends StatelessWidget {
  const ThirdPartyVendors({super.key});

//===================== Navigation ==========================\\

  void toVendorDetailPage(ThirdPartyVendorModel data) => Get.to(
        () => ThirdPartyVendorDetailPage(vendor: data),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "MyVendorDetailPage",
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
              controller.isLoad.value && controller.thirdPartyVendorList.isEmpty
                  ? const VendorsListSkeleton()
                  : ListView.separated(
                      separatorBuilder: (context, index) => kHalfSizedBox,
                      itemCount: controller.thirdPartyVendorList.length,
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
                          child: ThirdPartyVendorContainer(
                            onTap: () => toVendorDetailPage(
                              controller.thirdPartyVendorList[index],
                            ),
                            vendor: controller.thirdPartyVendorList[index],
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
