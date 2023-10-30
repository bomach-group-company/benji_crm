import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';

class MyFutureBuilder extends StatelessWidget {
  final dynamic future;
  final Function child;
  const MyFutureBuilder({
    super.key,
    required this.future,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return child(snapshot.data);
        }
        if (snapshot.hasError) {
          return const Text(
            'An unexpected error occurred, please refresh',
          );
        }
        return Center(
          child: CircularProgressIndicator(color: kAccentColor),
        );
      },
    );
  }
}
