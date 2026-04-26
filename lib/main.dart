import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/models/app_config.dart';
import 'core/di/injection.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/discover/presentation/blocs/video_list_bloc.dart';
import 'features/vpn/presentation/blocs/vpn_bloc.dart';
import 'core/models/video_entity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(AppConfigAdapter());
  Hive.registerAdapter(VideoEntityAdapter());

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => getIt<VideoListBloc>()..add(LoadVideosEvent())),
        BlocProvider(
            create: (_) => getIt<VpnBloc>()..add(AutoConnectVpnEvent())),
      ],
      child: MaterialApp(
        title: 'StreamPro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme, // App applies dark theme globally
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
