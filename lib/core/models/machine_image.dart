import 'package:flutter/material.dart';
import 'package:lift_log/core/services/api_services/app_settings_service.dart';
import 'package:lift_log/core/utils/target_muscle.dart';
import 'package:lift_log/core/widgets/app_cached_network_image.dart';

class MachineImage extends StatelessWidget {
  const MachineImage({
    super.key,
    this.imageUrl,
    this.targetMuscle,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String? imageUrl;
  final TargetMuscle? targetMuscle;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim().isNotEmpty == true
        ? imageUrl!.trim()
        : AppSettingsService.instance.targetMuscleImageUrl(targetMuscle);
    if (url == null || url.isEmpty) return const SizedBox.shrink();

    return AppCachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      errorWidget: const SizedBox.shrink(),
    );
  }
}
