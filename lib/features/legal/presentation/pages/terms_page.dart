import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/app_config.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<AppConfig>('app_config_box');
    AppConfig? config = box.isNotEmpty ? box.getAt(0) : null;
    final bool isFromGate = config == null || config.hasAcceptedTerms == false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        leading: isFromGate ? const SizedBox.shrink() : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last Updated: January 1, 2026', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 24),
            Text('Acceptance of Terms', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('By using StreamPro, you agree to these terms...', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
      bottomNavigationBar: isFromGate ? SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () async {
              if (config != null) {
                config!.hasAcceptedTerms = true;
                await config!.save();
              } else {
                config = AppConfig()..hasAcceptedTerms = true;
                await box.put(0, config!);
              }
              if (context.mounted) {
                context.pop();
              }
            },
            child: const Text('I Accept'),
          ),
        ),
      ) : null,
    );
  }
}
