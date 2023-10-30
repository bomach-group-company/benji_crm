import 'package:benji_aggregator/src/components/my_elevatedButton.dart';
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
      builder: (context) => Scrollbar(
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(kDefaultPadding),
              child: SizedBox(
                width: media.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Business Types",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: type
                              .map(
                                (e) => InkWell(
                                  onTap: () async {
                                    Get.back(result: e);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(e.name),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                        MyElevatedButton(
                            title: "Get Business Types", onPressed: () {})
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
}
