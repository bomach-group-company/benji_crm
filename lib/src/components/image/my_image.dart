import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  final String? url;
  const MyImage({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url == null ? '' : '$baseImage$url',
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          const Center(
              child: CupertinoActivityIndicator(
        color: kRedColor,
      )),
      errorWidget: (context, url, error) => Icon(
        Icons.error,
        color: kAccentColor,
      ),
    );
  }
}
