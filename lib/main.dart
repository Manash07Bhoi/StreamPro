import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/models/app_config.dart';
import 'core/di/injection.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(AppConfigAdapter());

  // Setup DI
  await setupInjection();

  // Set System UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.backgroundColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const StreamProApp());
}

class StreamProApp extends StatelessWidget {
  const StreamProApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We will add MultiBlocProvider here later when BLoCs are created
    return MaterialApp(
      title: 'StreamPro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // App applies dark theme globally
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
