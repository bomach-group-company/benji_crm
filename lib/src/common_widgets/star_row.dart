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
  String? active = null;

  @override
  void initState() {
    active = widget.active;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: active == 'all'
                    ? kAccentColor
                    : Color(
                        0xFFA9AAB1,
                      ),
              ),
              backgroundColor: active == 'all' ? kAccentColor : Colors.white,
              foregroundColor:
                  active == 'all' ? Colors.white : Color(0xFFA9AAB1),
            ),
            onPressed: () {
              setState(() {
                active = 'all';
              });
            },
            child: Text(
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
                            color:
                                active == item ? kStarColor : Color(0xFFA9AAB1),
                          ),
                          foregroundColor:
                              active == item ? kStarColor : Color(0xFFA9AAB1),
                        ),
                        onPressed: () {
                          setState(() {
                            active = item;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 20,
                            ),
                            SizedBox(
                              width: kDefaultPadding * 0.2,
                            ),
                            Text(
                              '$item',
                              style: TextStyle(
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
