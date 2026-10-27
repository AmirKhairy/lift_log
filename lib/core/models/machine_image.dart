import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/app_assets.dart';
import 'package:lift_log/core/widgets/app_cached_network_image.dart';

class MachineImage extends StatelessWidget {
  const MachineImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim() ?? '';
    if (url.isEmpty) return _logo();

    return AppCachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      errorWidget: _logo(),
    );
  }

  Widget _logo() {
    return Image.asset(
      AppAssets.logo,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
