import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/models/app_update_config.dart';
import 'package:lift_log/core/utils/app_assets.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({super.key, required this.config});

  final AppUpdateConfig config;

  Future<void> _openStore(BuildContext context) async {
    final launched = await launchUrl(
      Uri.parse(config.storeUrl),
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('update_link_error'.tr)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeArea: true,
      padding: const EdgeInsets.all(24),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(AppAssets.logo, width: 80, height: 80),
              ),
              const SizedBox(height: 28),
              AppText(
                'update_required'.tr,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              AppText(
                'update_required_description'.tr,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () => _openStore(context),
                icon: const Icon(Icons.download_rounded),
                label: Text('update_now'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
