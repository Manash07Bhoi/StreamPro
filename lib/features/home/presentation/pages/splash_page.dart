import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/app_config.dart';
import '../../../../core/routes/app_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkInitialRoute();
  }

  Future<void> _checkInitialRoute() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!Hive.isBoxOpen('app_config_box')) {
      await Hive.openBox<AppConfig>('app_config_box');
    }
    final configBox = Hive.box<AppConfig>('app_config_box');

    if (configBox.isEmpty) {
      await configBox.put(0, AppConfig());
    }

    final config = configBox.getAt(0);

    if (config != null) {
      if (!config.hasAcceptedTerms || !config.hasAcceptedAgeGate || !config.hasAcceptedPrivacy) {
        if (mounted) context.go(AppRoutes.ageGate);
      } else if (config.isFirstLaunch) {
        if (mounted) context.go(AppRoutes.onboarding);
      } else {
        if (mounted) context.go(AppRoutes.home);
      }
    } else {
       if (mounted) context.go(AppRoutes.ageGate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
