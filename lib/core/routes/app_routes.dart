import 'package:flutter/material.dart';

// Assuming screens are going to be implemented next
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/splash_page.dart';
import '../../features/player/presentation/pages/video_player_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String player = '/player';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case player:
        return MaterialPageRoute(builder: (_) => const VideoPlayerPage());
      case splash:
      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }
}
