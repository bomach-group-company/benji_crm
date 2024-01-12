import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  final String? url;
  final double imageHeight;
  final double radius;
  const MyImage({super.key, this.url, this.imageHeight = 90, this.radius = 10});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url == null
            ? ''
            : url!.startsWith("https")
                ? url!
                : baseImage + url!,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            Center(child: CupertinoActivityIndicator(color: kAccentColor)),
        errorWidget: (context, url, error) =>
            Icon(Icons.error, color: kAccentColor),
      ),
    );
  }
}
