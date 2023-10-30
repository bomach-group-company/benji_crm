import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/business_type_model.dart';
import '../../src/providers/constants.dart';

Future shopTypeModal(BuildContext context, List<BusinessType> type) async {
  final scrollController = ScrollController();
  var media = MediaQuery.of(context).size;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    anchorPoint: const Offset(0, 10),
    barrierColor: kBlackColor.withOpacity(0.8),
    backgroundColor: kPrimaryColor,
    showDragHandle: true,
    isDismissible: true,
    elevation: 20,
    enableDrag: true,
    constraints: BoxConstraints(maxHeight: media.height),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Business Types".toUpperCase(),
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Scrollbar(
            child: ListView.separated(
              itemCount: type.length,
              shrinkWrap: true,
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(kDefaultPadding),
              separatorBuilder: (BuildContext context, int index) =>
                  kHalfSizedBox,
              itemBuilder: (BuildContext context, int index) {
                int adjustedIndex = index + 1;
                return InkWell(
                  onTap: () async {
                    Get.back(result: type[index]);
                  },
                  mouseCursor: SystemMouseCursors.click,
                  enableFeedback: true,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: media.width,
                    height: 40,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "($adjustedIndex) ${type[index].name}",
                      style: TextStyle(
                        color: kTextGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // MyElevatedButton(
          //   title: "Get Categories",
          //   onPressed: () => CategoryController.instance.getCategory(),
          // ),
        ],
      ),
    ),
  );
}
