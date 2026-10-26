import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/context_extension.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/utils/app_radius.dart';

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xl),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: context.theme.colorScheme.surface,
          elevation: 0,
          indicatorColor: context.theme.colorScheme.surface,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(
                color: context.theme.colorScheme.primary,
                size: 24.sp,
              );
            }

            return IconThemeData(
              color: context.theme.colorScheme.onSurface.withValues(alpha: 0.5),
              size: 24.sp,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                color: context.theme.colorScheme.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                textBaseline: TextBaseline.alphabetic,
              );
            }

            return TextStyle(
              color: context.theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              textBaseline: TextBaseline.alphabetic,
            );
          }),
        ),
        child: NavigationBar(
          height: 80.h,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: selectedIndex,
          labelPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          onDestinationSelected: onDestinationSelected,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: 'home'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.precision_manufacturing_outlined),
              selectedIcon: const Icon(Icons.precision_manufacturing),
              label: 'machines'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.play_circle_outline),
              selectedIcon: const Icon(Icons.play_circle),
              label: 'videos'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: 'profile'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
