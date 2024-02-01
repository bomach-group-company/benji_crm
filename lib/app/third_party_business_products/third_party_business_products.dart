// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';

import '../../controller/product_controller.dart';
import '../../model/business_model.dart';
import '../../model/product_model.dart';
import '../../src/components/card/empty.dart';
import '../../src/components/container/business_product_container.dart';
import '../../src/providers/constants.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../theme/colors.dart';
import 'view_third_party_product.dart';

class ThirdPartyBusinessProducts extends StatelessWidget {
  final BusinessModel business;

  ThirdPartyBusinessProducts({super.key, required this.business});

  late Future<Map<String, List<ProductModel>>> productAndSubCategoryName;

  // _getData() async {
  viewProduct(ProductModel product) {
    Get.to(
      () => ViewThirdPartyProduct(product: product),
      routeName: 'ViewThirdPartyProduct',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

//=================================== END =====================================\\
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      width: media.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetBuilder<ProductController>(
            init: ProductController(),
            initState: (state) =>
                ProductController.instance.getBusinessProducts(business.id),
            builder: (controller) {
              if (controller.products.isEmpty && controller.isLoad.value) {
                return Center(
                  child: CircularProgressIndicator(color: kAccentColor),
                );
              }
              if (controller.products.isEmpty) {
                return const EmptyCard(
                  emptyCardMessage: "You don't have any products",
                );
              }
              return LayoutGrid(
                rowGap: kDefaultPadding / 2,
                columnGap: kDefaultPadding / 2,
                columnSizes: breakPointDynamic(media.width, [1.fr],
                    [1.fr, 1.fr], [1.fr, 1.fr, 1.fr], [1.fr, 1.fr, 1.fr, 1.fr]),
                rowSizes: controller.products.isEmpty
                    ? [auto]
                    : List.generate(
                        controller.products.length, (index) => auto),
                children: (controller.products)
                    .map(
                      (item) => BusinessProductContainer(
                        onTap: () => viewProduct(item),
                        product: item,
                      ),
                    )
                    .toList(),
              );
            },
          ),
          kSizedBox,
        ],
      ),
    );
  }
}
