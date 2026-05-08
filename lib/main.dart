import 'core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/injection.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/vpn/presentation/blocs/vpn_bloc.dart';
import 'features/profile/presentation/blocs/profile_bloc.dart';
import 'features/settings/presentation/blocs/settings_bloc.dart';
import 'features/notifications/presentation/blocs/notification_bloc.dart';
import 'core/blocs/connectivity_bloc.dart';
import 'features/player/presentation/blocs/pip_bloc.dart';
import 'core/widgets/connectivity_overlay.dart';
import 'features/discover/data/repositories/video_repository.dart';
import 'features/player/data/repositories/comment_repository.dart';
import 'features/notifications/data/repositories/notification_repository.dart';
import 'core/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive via DatabaseService
  final dbService = DatabaseService();
  await dbService.init();

  // 2. Setup DI
  await setupInjection();

  // 3. Initialize seed data (runs only if boxes are empty)
  final videoRepo = sl<VideoRepository>();
  if (videoRepo.getVideos().isEmpty) {
    await videoRepo.initializeSeedData();
  }
  await sl<CommentRepository>().seedCommentsIfNeeded();
  await sl<NotificationRepository>().seedNotificationsIfNeeded();

  // 4. Set System UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.colorBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
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
            create: (_) => sl<ConnectivityBloc>()..add(StartMonitoring())),
        BlocProvider(create: (_) => sl<VpnBloc>()..add(AutoConnectVpnEvent())),
        BlocProvider(
            create: (_) => sl<NotificationBloc>()..add(LoadNotifications())),
        BlocProvider(create: (_) => sl<SettingsBloc>()..add(LoadSettings())),
        BlocProvider(create: (_) => sl<ProfileBloc>()..add(LoadProfile())),
        BlocProvider(create: (_) => sl<PipBloc>()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (prev, curr) =>
            curr is SettingsLoaded || curr is SettingsActionSuccess,
        builder: (context, state) {
          return MaterialApp.router(
            title: 'StreamPro',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            routerConfig: appRouter,
            builder: (context, child) {
              return ConnectivityOverlay(
                  child: child ?? const SizedBox.shrink());
            },
          );
        },
      ),
    );
  }
}
