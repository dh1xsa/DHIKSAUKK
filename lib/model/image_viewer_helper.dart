import 'package:coba1/color.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageViewerHelper {
  ImageViewerHelper._();

  static Widget show({
    required BuildContext context,
    required String url,
    BoxFit? fit,
    double? radius,
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit ?? BoxFit.cover,
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.circular(radius ?? 8),
            image: DecorationImage(
              image: imageProvider,
              fit: fit ?? BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url) => Container(),
      errorWidget: (context, url, error) => const Icon(Icons.error_outline_outlined),
    );
  }
}
