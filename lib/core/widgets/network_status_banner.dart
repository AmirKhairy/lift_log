import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/services/network_service.dart';
import 'package:lift_log/core/theme/app_colors.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class NetworkStatusBanner extends StatefulWidget {
  const NetworkStatusBanner({super.key});

  @override
  State<NetworkStatusBanner> createState() => NetworkStatusBannerState();
}

class NetworkStatusBannerState extends State<NetworkStatusBanner> {
  Timer? _restoredTimer;
  bool _showRestored = false;
  bool? _previousStatus;

  @override
  void initState() {
    super.initState();
    NetworkService.instance.addListener(_handleStatusChanged);
  }

  void _handleStatusChanged() {
    final currentStatus = NetworkService.instance.isConnected;

    if (currentStatus == true && _previousStatus == false) {
      _restoredTimer?.cancel();
      setState(() => _showRestored = true);
      _restoredTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showRestored = false);
      });
    }

    _previousStatus = currentStatus;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _restoredTimer?.cancel();
    NetworkService.instance.removeListener(_handleStatusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisconnected = NetworkService.instance.isConnected == false;

    if (!isDisconnected && !_showRestored) return const SizedBox.shrink();

    final isRestored = !isDisconnected && _showRestored;
    final backgroundColor = isRestored ? AppColors.success : AppColors.error;
    final message = isRestored ? 'network_restored'.tr : 'network_offline'.tr;
    final icon = isRestored ? Icons.wifi_rounded : Icons.wifi_off_rounded;

    return SafeArea(
      bottom: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: backgroundColor,
          elevation: 4,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.surfaceLight, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppText(
                      message,
                      fontWeight: FontWeight.w600,
                      color: AppColors.surfaceLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
