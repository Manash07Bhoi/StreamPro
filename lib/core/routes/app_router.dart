import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/splash_page.dart';
import '../../features/player/presentation/pages/video_player_page.dart';
import '../../features/vpn/presentation/pages/vpn_status_screen.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/category/presentation/pages/category_feed_page.dart';
import '../../features/age_gate/presentation/pages/age_gate_page.dart';
import '../../features/legal/presentation/pages/terms_page.dart';
import '../../features/legal/presentation/pages/privacy_policy_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/category/presentation/pages/category_grid_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/downloads/presentation/pages/downloads_page.dart';
import '../../features/playlists/presentation/pages/playlists_page.dart';
import '../../features/playlists/presentation/pages/playlist_detail_page.dart';
import '../../features/liked/presentation/pages/liked_videos_page.dart';
import '../../features/help/presentation/pages/help_faq_page.dart';
import '../../features/help/presentation/pages/about_page.dart';
import '../models/video_entity.dart';
import '../di/injection.dart';
import '../../features/settings/data/repositories/app_config_repository.dart';

// Import placeholders for screens not yet implemented but defined in PRD
import 'route_placeholders.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final config = sl<AppConfigRepository>().getConfig();
    final isOnSplash = state.matchedLocation == AppRoutes.splash;
    final isOnLegal = state.matchedLocation == '/age-gate' ||
        state.matchedLocation == '/terms' ||
        state.matchedLocation == '/privacy';

    // If first time user hits any deep link, gate them first
    if (!config.hasAcceptedTerms && !isOnLegal && !isOnSplash) {
      return '/age-gate';
    }
    return null;
  },
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (c, s) => const SplashPage()),
    GoRoute(path: '/age-gate', builder: (c, s) => const AgeGatePage()),
    GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingPage()),
    GoRoute(path: '/terms', builder: (c, s) => const TermsPage()),
    GoRoute(path: '/privacy', builder: (c, s) => const PrivacyPolicyPage()),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (c, s) => _fadeTransition(s, const HomePage()),
      routes: [],
    ),
    GoRoute(
      path: AppRoutes.player,
      pageBuilder: (c, s) {
        final video = s.extra as VideoEntity?;
        if (video != null) {
          return _fadeTransition(s, VideoPlayerPage(video: video));
        }
        return _fadeTransition(s, const Scaffold(body: Center(child: Text('Error: No Video Data'))));
      },
    ),
    GoRoute(path: AppRoutes.vpn, builder: (c, s) => const VpnStatusScreen()),
    GoRoute(path: '/categories', builder: (c, s) => const CategoryGridPage()),
    GoRoute(
      path: '/category/:id',
      builder: (c, s) {
        final categoryName = s.pathParameters['id']!;
        return CategoryFeedPage(category: categoryName);
      },
    ),
    GoRoute(path: '/profile', builder: (c, s) => const ProfilePage()),
    GoRoute(path: '/profile/edit', builder: (c, s) => const EditProfilePage()),
    GoRoute(path: '/notifications', builder: (c, s) => const NotificationsPage()),
    GoRoute(path: '/downloads', builder: (c, s) => const DownloadsPage()),
    GoRoute(path: '/playlists', builder: (c, s) => const PlaylistsPage()),
    GoRoute(
      path: '/playlists/:id',
      builder: (c, s) {
        final playlistId = s.pathParameters['id']!;
        return PlaylistDetailPage(playlistId: playlistId);
      },
    ),
    GoRoute(path: '/liked', builder: (c, s) => const LikedVideosPage()),
    GoRoute(path: AppRoutes.settings, builder: (c, s) => const SettingsPage()),
    GoRoute(path: '/settings/playback', builder: (c, s) => const PlaceholderPage(title: 'Playback Settings')),
    GoRoute(path: '/settings/parental', builder: (c, s) => const PlaceholderPage(title: 'Parental Control')),
    GoRoute(path: '/help', builder: (c, s) => const HelpFaqPage()),
    GoRoute(path: '/about', builder: (c, s) => const AboutPage()),
    GoRoute(path: '/cast', builder: (c, s) => const PlaceholderPage(title: 'Cast')),
  ],
  errorBuilder: (context, state) => const Scaffold(body: Center(child: Text('Not Found'))),
);

CustomTransitionPage<void> _fadeTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
    transitionDuration: const Duration(milliseconds: 300),
  );
}
