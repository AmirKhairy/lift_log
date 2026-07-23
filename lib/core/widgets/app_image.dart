import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lift_log/core/widgets/loading.dart';

class AppImage extends StatelessWidget {
  const AppImage.network(
    this.url, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.radius = 16,
  }) : asset = null;

  const AppImage.asset(
    this.asset, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.radius = 16,
  }) : url = null;

  final String? url;
  final String? asset;

  final double? height;
  final double? width;
  final BoxFit fit;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(radius);

    if (asset != null) {
      return ClipRRect(
        borderRadius: border,
        child: Image.asset(asset!, width: width, height: height, fit: fit),
      );
    }

    return ClipRRect(
      borderRadius: border,
      child: CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, _) => const Loading(),
        errorWidget: (_, _, _) => const Icon(Icons.broken_image),
      ),
    );
  }
}
