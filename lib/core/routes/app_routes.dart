import 'package:flutter/material.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/splash_page.dart';
import '../../features/player/presentation/pages/video_player_page.dart';
import '../../features/vpn/presentation/pages/vpn_status_screen.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/category/presentation/pages/category_feed_page.dart';
import '../models/video_entity.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String player = '/player';
  static const String vpn = '/vpn';
  static const String settings = '/settings';
  static const String category = '/category';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.player:
        final video = settings.arguments as VideoEntity?;
        if (video != null) {
          return MaterialPageRoute(
            builder: (_) => VideoPlayerPage(video: video),
          );
        }
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Error: No Video Data'))),
        );
      case AppRoutes.vpn:
        return MaterialPageRoute(builder: (_) => const VpnStatusScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case AppRoutes.category:
        final cat = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => CategoryFeedPage(category: cat ?? 'Category'),
        );
      case AppRoutes.splash:
      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }
}
