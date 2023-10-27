import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../model/business_type_model.dart';

Future shopTypeModal(BuildContext context, List<BusinessType> type) async {
  var media = MediaQuery.of(context).size;
  return showModalBottomSheet(
      context: context,
      // isScrollControlled: true,

      backgroundColor: kPrimaryColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: SizedBox(
              height: media.height * 0.4,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Business Type",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: type
                              .map(
                                (e) => InkWell(
                                  onTap: () async {
                                    Navigator.pop(context, e);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(e.name ?? ""),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
}

class ItemWeight {
  String item;
  bool selected;
  int id;
  ItemWeight({required this.item, required this.selected, required this.id});
}
