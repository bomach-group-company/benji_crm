import 'dart:async';

import 'package:benji_aggregator/src/common_widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class CallPage extends StatefulWidget {
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
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
//============================================= INITIAL STATE AND DISPOSE =========================================\\
  @override
  void initState() {
    _phoneConnecting = true;
    _phoneRinging = false;
    _callConnected = false;
    _callDropped = false;

    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_callConnected) {
        setState(() {
          _callDuration++;
        });
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _phoneConnecting = false;
        _phoneRinging = true;
      });
    });

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _phoneRinging = false;
        _callConnected = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _callTimer.cancel();
    super.dispose();
  }

//============================================= ALL VARAIBLES =========================================\\
  late bool _phoneConnecting;
  late bool _phoneRinging;
  late bool _callConnected;
  late bool _callDropped;
  int _callDuration = 0;
  late Timer _callTimer;
//============================================= CONTROLLERS =========================================\\

//============================================= FUNCTIONS =========================================\\

  String _formatDuration() {
    int minutes = _callDuration ~/ 60;
    int seconds = _callDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _totalCallDuration() {
    int minutes = _callDuration ~/ 60;
    int seconds = _callDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _endCallFunc() async {
    setState(() {
      _callConnected = false;
      _callDropped = true;
    });

    //Cause a delay before popping context
    await Future.delayed(const Duration(seconds: 1));
    //Pop context
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "",
        elevation: 0,
        actions: const [],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
      ),
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
                        image: AssetImage("assets/images/${widget.userImage}"),
                        fit: BoxFit.cover,
                      ),
                      shape: const OvalBorder(),
                    ),
                  ),
                  kSizedBox,
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      color: kTextBlackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.40,
                    ),
                  ),
                  kSizedBox,
                  Text(
                    widget.userPhoneNumber,
                    style: const TextStyle(
                      color: kTextBlackColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 0.40,
                    ),
                  ),
                  kSizedBox,
                  if (_phoneConnecting)
                    Text(
                      "Connecting...",
                      style: TextStyle(
                        color: kLoadingColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.32,
                      ),
                    ),
                  if (_phoneRinging)
                    Text(
                      "Ringing...",
                      style: TextStyle(
                        color: kAccentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.32,
                      ),
                    ),
                  if (_callConnected)
                    Column(
                      children: [
                        const Text(
                          "Call connected",
                          style: TextStyle(
                            color: kSuccessColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.32,
                          ),
                        ),
                        kSizedBox,
                        Text(_formatDuration()),
                      ],
                    ),
                  if (_callDropped)
                    Text(
                      "Call ended",
                      style: TextStyle(
                        color: kAccentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.32,
                      ),
                    ),
                  kSizedBox,
                  if (_callDropped)
                    Text(
                      _totalCallDuration(),
                      style: TextStyle(color: kAccentColor),
                    ),
                  const SizedBox(height: kDefaultPadding * 8),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFDD5D5),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 0.40, color: Color(0xFFD4DAF0)),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: IconButton(
                      splashRadius: 40,
                      onPressed: _endCallFunc,
                      icon: Icon(
                        Icons.call_end,
                        color: kAccentColor,
                      ),
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
