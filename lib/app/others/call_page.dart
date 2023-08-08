import 'package:flutter/material.dart';

import '../../src/common_widgets/my_appbar.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class CallPage extends StatelessWidget {
  final String userName;
  final String userImage;
  final String userPhoneNumber;
  const CallPage(
      {Key? key,
      required this.userName,
      required this.userImage,
      required this.userPhoneNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: MyAppBar(
          title: "Call",
          elevation: 0.0,
          actions: [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(kDefaultPadding),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: ShapeDecoration(
                      color: kPageSkeletonColor,
                      image: DecorationImage(
                        image: AssetImage("assets/images/${userImage}"),
                        fit: BoxFit.cover,
                      ),
                      shape: const OvalBorder(),
                    ),
                  ),
                  kSizedBox,
                  Text(
                    userName,
                    style: TextStyle(
                      color: kTextBlackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.40,
                    ),
                  ),
                  kSizedBox,
                  Text(
                    userPhoneNumber,
                    style: TextStyle(
                      color: kTextBlackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.40,
                    ),
                  ),
                  kSizedBox,
                  Text(
                    "Ringing...",
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.32,
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding * 5),
                  SizedBox(
                    width: 160,
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFDD5D5),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 0.40, color: Color(0xFFD4DAF0)),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: IconButton(
                            splashRadius: 30,
                            onPressed: () {},
                            icon: Icon(
                              Icons.close,
                              color: kAccentColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 48,
                          width: 48,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEDF0FD),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 0.40, color: Color(0xFFD4DAF0)),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: IconButton(
                            splashRadius: 30,
                            onPressed: () {},
                            icon: Icon(
                              Icons.phone,
                              color: kSecondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
