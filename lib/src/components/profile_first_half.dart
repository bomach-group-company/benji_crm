// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:benji_aggregator/app/others/withdrawal/select_account.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../theme/colors.dart';
import '../providers/constants.dart';

class ProfileFirstHalf extends StatefulWidget {
  final String availableBalance;
  const ProfileFirstHalf({
    super.key,
    required this.availableBalance,
  });

  @override
  State<ProfileFirstHalf> createState() => _ProfileFirstHalfState();
}

class _ProfileFirstHalfState extends State<ProfileFirstHalf> {
//======================================================= INITIAL STATE ================================================\\
  @override
  void initState() {
    super.initState();
    _isObscured = true;
  }

//======================================================= ALL VARIABLES ================================================\\
  var _isObscured;

//======================================================= FUNCTIONS ================================================\\
  void _toSelectAccount() => Get.to(
        () => const SelectAccountPage(),
        duration: const Duration(milliseconds: 500),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Select Account",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      decoration: ShapeDecoration(
        color: kAccentColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Available Balance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                icon: _isObscured
                    ? Icon(
                        Icons.visibility,
                        color: kPrimaryColor,
                      )
                    : Icon(
                        Icons.visibility_off_rounded,
                        color: kPrimaryColor,
                      ),
              ),
            ],
          ),
          kSizedBox,
          Text(
            _isObscured ? '₦${widget.availableBalance}' : 'XXXXXXXXX',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 40,
              fontFamily: 'Sen',
              fontWeight: FontWeight.w700,
            ),
          ),
          kSizedBox,
          InkWell(
            onTap: _toSelectAccount,
            child: Container(
              width: 100,
              height: 37,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0.50,
                    color: kPrimaryColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  'Withdraw',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: kDefaultPadding * 2,
          ),
        ],
      ),
    );
  }
}
