import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class StarRow extends StatefulWidget {
  final String active;
  const StarRow({super.key, this.active = 'all'});

  @override
  State<StarRow> createState() => _StarRowState();
}

class _StarRowState extends State<StarRow> {
  final List<String> stars = ['5', '4', '3', '2', '1'];
  String? active;

  @override
  void initState() {
    active = widget.active;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: active == 'all'
                    ? kAccentColor
                    : const Color(
                        0xFFA9AAB1,
                      ),
              ),
              backgroundColor: active == 'all' ? kAccentColor : Colors.white,
              foregroundColor:
                  active == 'all' ? Colors.white : const Color(0xFFA9AAB1),
            ),
            onPressed: () {
              setState(() {
                active = 'all';
              });
            },
            child: const Text(
              'All',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Row(
            children: stars
                .map(
                  (item) => Row(
                    children: [
                      kHalfWidthSizedBox,
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: active == item
                                ? kStarColor
                                : const Color(0xFFA9AAB1),
                          ),
                          foregroundColor: active == item
                              ? kStarColor
                              : const Color(0xFFA9AAB1),
                        ),
                        onPressed: () {
                          setState(() {
                            active = item;
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 20,
                            ),
                            const SizedBox(
                              width: kDefaultPadding * 0.2,
                            ),
                            Text(
                              item,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          kHalfWidthSizedBox,
        ],
      ),
    );
  }
}
