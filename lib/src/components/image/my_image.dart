import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class MyImage extends StatelessWidget {
  final String? url;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Alignment alignment;
  const MyImage(
      {super.key,
      this.height,
      this.width,
      this.url,
      this.fit = BoxFit.cover,
      this.alignment = Alignment.center});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url == null
          ? ''
          : url!.startsWith("https")
              ? url!
              : baseImage + url!,
      height: height,
      width: width,
      fit: fit,
      fadeInCurve: Curves.easeIn,
      fadeOutCurve: Curves.easeInOut,
      filterQuality: FilterQuality.high,
      alignment: alignment,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: CupertinoActivityIndicator(
        color: kAccentColor,
      )),
      errorWidget: (context, url, error) =>
          Image.asset('assets/images/products/placeholder_image.png'),
    );
  }
}
