import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/database_service.dart';
import 'features/discover/presentation/blocs/video_list_bloc.dart';
import 'features/vpn/presentation/blocs/vpn_bloc.dart';
import 'features/discover/data/repositories/video_repository.dart';
import 'features/player/data/repositories/comment_repository.dart';
import 'features/notifications/data/repositories/notification_repository.dart';
import 'features/profile/data/repositories/profile_repository.dart';
import 'core/widgets/connectivity_overlay.dart';
import 'core/blocs/connectivity_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive
  final dbService = DatabaseService();
  await dbService.init();

  // 2. Setup DI
  await setupInjection();

  // 3. Initialize seed data
  await getIt<VideoRepository>().initializeSeedData();
  // TODO: We can't inject CommentRepository, NotificationRepository, ProfileRepository yet as they are not in injection.dart
  // For now, let's instantiate them manually to seed.
  await CommentRepository().seedCommentsIfNeeded();
  await NotificationRepository().seedNotificationsIfNeeded();
  await ProfileRepository().initializeProfileIfNeeded();

  // 4. Configure system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.backgroundColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // 5. Set preferred orientations
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
            create: (_) => ConnectivityBloc(Connectivity())..add(StartMonitoring())),
        BlocProvider(
            create: (_) => getIt<VideoListBloc>()..add(LoadVideosEvent())),
        BlocProvider(
            create: (_) => getIt<VpnBloc>()..add(AutoConnectVpnEvent())),
      ],
      child: MaterialApp.router(
        title: 'StreamPro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: appRouter,
        builder: (context, child) {
          return ConnectivityOverlay(child: child ?? const SizedBox());
        },
      ),
    );
  }
}
