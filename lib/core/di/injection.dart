import 'package:get_it/get_it.dart';

import '../../features/discover/data/repositories/video_repository.dart';
import '../../features/discover/data/repositories/search_history_repository.dart';
import '../../features/library/data/repositories/history_repository.dart';
import '../../features/library/data/repositories/bookmark_repository.dart';
import '../../features/library/data/repositories/download_repository.dart';
import '../../features/library/data/repositories/playlist_repository.dart';
import '../../features/library/data/repositories/like_repository.dart';
import '../../features/player/data/repositories/comment_repository.dart';
import '../../features/notifications/data/repositories/notification_repository.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import '../../features/settings/data/repositories/app_config_repository.dart';

import '../../features/discover/presentation/blocs/video_list_bloc.dart';
import '../../features/vpn/presentation/blocs/vpn_bloc.dart';
import '../../features/profile/presentation/blocs/profile_bloc.dart';
import '../../features/library/presentation/blocs/playlist_bloc.dart';
import '../../features/library/presentation/blocs/download_bloc.dart';
import '../../features/notifications/presentation/blocs/notification_bloc.dart';
import '../../features/settings/presentation/blocs/settings_bloc.dart';
import '../../features/home/presentation/blocs/home_feed_bloc.dart';
import '../../features/trending/presentation/blocs/trending_bloc.dart';
import '../../features/discover/presentation/blocs/search_bloc.dart';
import '../../features/player/presentation/blocs/player_bloc.dart';
import '../../features/player/presentation/blocs/comment_bloc.dart';
import '../../features/player/presentation/blocs/pip_bloc.dart';
import '../../features/player/data/datasources/brightness_channel.dart';
import '../../features/player/data/datasources/volume_channel.dart';

import '../../core/services/database_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/blocs/connectivity_bloc.dart';

final sl = GetIt.instance; // Re-naming to sl (service locator) as requested by PRD, but keeping getIt for compatibility if needed.
final getIt = sl;

Future<void> setupInjection() async {
  // === SERVICES (Singletons) ===
  sl.registerLazySingleton<DatabaseService>(() => DatabaseService());
  sl.registerLazySingleton<BrightnessChannel>(() => BrightnessChannel());
  sl.registerLazySingleton<VolumeChannel>(() => VolumeChannel());
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // === REPOSITORIES (Lazy Singletons) ===
  sl.registerLazySingleton<VideoRepository>(() => VideoRepository());
  sl.registerLazySingleton<PlaylistRepository>(() => PlaylistRepository());
  sl.registerLazySingleton<DownloadRepository>(() => DownloadRepository());
  sl.registerLazySingleton<LikeRepository>(() => LikeRepository());
  sl.registerLazySingleton<CommentRepository>(() => CommentRepository());
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepository());
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepository());
  sl.registerLazySingleton<SearchHistoryRepository>(() => SearchHistoryRepository());
  sl.registerLazySingleton<AppConfigRepository>(() => AppConfigRepository());
  sl.registerLazySingleton<HistoryRepository>(() => HistoryRepository());
  sl.registerLazySingleton<BookmarkRepository>(() => BookmarkRepository());

  // === BLoCs ===
  sl.registerFactory(() => VideoListBloc(sl<VideoRepository>()));
  sl.registerFactory(() => VpnBloc());
  sl.registerFactory(() => ProfileBloc(sl<ProfileRepository>()));
  sl.registerFactory(() => PlaylistBloc(sl<PlaylistRepository>()));
  sl.registerFactory(() => DownloadBloc(sl<DownloadRepository>()));
  sl.registerFactory(() => NotificationBloc(sl<NotificationRepository>()));

  sl.registerLazySingleton<SettingsBloc>(() => SettingsBloc(sl()));
  sl.registerFactory<HomeFeedBloc>(() => HomeFeedBloc(sl(), sl(), sl()));
  sl.registerFactory<TrendingBloc>(() => TrendingBloc(sl()));
  sl.registerFactory<SearchBloc>(() => SearchBloc(sl(), sl()));

  sl.registerFactory<PlayerBloc>(() => PlayerBloc(sl(), sl(), sl()));
  sl.registerFactory<CommentBloc>(() => CommentBloc(sl()));
  sl.registerLazySingleton<PipBloc>(() => PipBloc());
  sl.registerLazySingleton<ConnectivityBloc>(() => ConnectivityBloc(sl()));
}
