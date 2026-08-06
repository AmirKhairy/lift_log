import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/constants/app_constants.dart';
import 'package:lift_log/i18n/localization_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class LiftLogApp extends StatelessWidget {
  const LiftLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) {
        return AnimatedBuilder(
          animation: LocalizationService.instance,
          builder: (_, _) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,

              title: AppConstants.appName,
              theme: AppTheme.light,

              darkTheme: AppTheme.dark,

              themeMode: ThemeMode.system,

              routerConfig: appRouter,

              locale: LocalizationService.instance.locale,

              supportedLocales: AppConstants.locales,

              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          },
        );
      },
    );
  }
}
