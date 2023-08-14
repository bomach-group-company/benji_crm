import 'package:benji_aggregator/src/common_widgets/my_appbar.dart';
import 'package:flutter/material.dart';

import '../../../src/providers/constants.dart';
import '../../../theme/colors.dart';

class WithdrawHistoryPage extends StatefulWidget {
  const WithdrawHistoryPage({Key? key}) : super(key: key);

  @override
  State<WithdrawHistoryPage> createState() => _WithdrawHistoryPageState();
}

class _WithdrawHistoryPageState extends State<WithdrawHistoryPage> {
//===================================== ALL VARIABLES =========================================\\

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateTime = formatDateAndTime(now);
    final media = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: kPrimaryColor,
      appBar: MyAppBar(
        title: "Withdrawal History",
        elevation: 0.0,
        actions: [],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kDefaultPadding / 2,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey.shade400,
                    spreadRadius: 2,
                    // offset: Offset(1, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NGN 20,000',
                        style: TextStyle(
                          color: Color(0xFFEC2623),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '21/03/2023 | 12:19 pm',
                        style: TextStyle(
                          color: Color(0xFFA9AAB1),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  kSizedBox,
                  Text(
                    'Access Bank ...9876',
                    style: TextStyle(
                      color: Color(0xFF131514),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
