import 'package:flutter/material.dart';

import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAccentColor,
        title: const Padding(
          padding: EdgeInsets.only(
            left: kDefaultPadding,
          ),
          child: Text(
            'My Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        elevation: 10.0,
      ),
    );
  }
}
