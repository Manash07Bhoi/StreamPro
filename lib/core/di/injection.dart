import 'package:get_it/get_it.dart';

import '../../features/discover/data/repositories/video_repository.dart';
import '../../features/discover/presentation/blocs/video_list_bloc.dart';
import '../../features/vpn/presentation/blocs/vpn_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  // Repositories
  getIt.registerLazySingleton(() => VideoRepository());

  // BLoCs
  getIt.registerFactory(() => VideoListBloc(getIt<VideoRepository>()));
  getIt.registerFactory(() => VpnBloc());
}
