import "../../features/settings/presentation/pages/playback_settings_page.dart";
import "../../features/settings/presentation/pages/parental_control_page.dart";
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/home/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/age_gate/presentation/pages/age_gate_page.dart';
import '../../features/legal/presentation/pages/terms_page.dart';
import '../../features/legal/presentation/pages/privacy_policy_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/category/presentation/pages/category_grid_page.dart';
import '../../features/category/presentation/pages/category_feed_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/downloads/presentation/pages/downloads_page.dart';
import '../../features/playlists/presentation/pages/playlists_page.dart';
import '../../features/playlists/presentation/pages/playlist_detail_page.dart';
import '../../features/liked/presentation/pages/liked_videos_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/help/presentation/pages/help_faq_page.dart';
import '../../features/help/presentation/pages/about_page.dart';
import '../../features/cast/presentation/pages/cast_page.dart';
import '../../features/vpn/presentation/pages/vpn_status_screen.dart';
import '../../features/player/presentation/pages/video_player_page.dart';
import '../models/app_config.dart';
import '../models/video_entity.dart';

class AppRoutes {
  static const String splash = '/';
  static const String ageGate = '/age-gate';
  static const String onboarding = '/onboarding';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String home = '/home';
  static const String player = '/player';
  static const String vpn = '/vpn';
  static const String categories = '/categories';
  static const String category = '/category/:id';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String notifications = '/notifications';
  static const String downloads = '/downloads';
  static const String playlists = '/playlists';
  static const String playlistDetail = '/playlists/:id';
  static const String liked = '/liked';
  static const String settings = '/settings';
  static const String settingsPlayback = '/settings/playback';
  static const String settingsParental = '/settings/parental';
  static const String help = '/help';
  static const String about = '/about';
  static const String cast = '/cast';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: (context, state) {
    if (!Hive.isBoxOpen('app_config_box')) return null;
    final box = Hive.box<AppConfig>('app_config_box');
    if (box.isEmpty) return null;

    final config = box.getAt(0);
    if (config == null) return null;

    final isOnSplash = state.matchedLocation == AppRoutes.splash;
    final isOnLegal = state.matchedLocation == AppRoutes.ageGate ||
        state.matchedLocation == AppRoutes.terms ||
        state.matchedLocation == AppRoutes.privacy;

    if (!config.hasAcceptedTerms && !isOnLegal && !isOnSplash) {
      return AppRoutes.ageGate;
    }
    return null;
  },
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashPage()),
    GoRoute(path: AppRoutes.ageGate, builder: (context, state) => const AgeGatePage()),
    GoRoute(path: AppRoutes.onboarding, builder: (context, state) => const OnboardingPage()),
    GoRoute(path: AppRoutes.terms, builder: (context, state) => const TermsPage()),
    GoRoute(path: AppRoutes.privacy, builder: (context, state) => const PrivacyPolicyPage()),
    GoRoute(path: AppRoutes.home, builder: (context, state) => const HomePage()),
    GoRoute(
      path: AppRoutes.player,
      builder: (context, state) {
        final video = state.extra as VideoEntity?;
        // If deep linked without extra, maybe redirect or load from id. For now fallback.
        if (video == null) return const Scaffold(body: Center(child: Text('Video missing')));
        return VideoPlayerPage(video: video);
      },
    ),
    GoRoute(path: AppRoutes.vpn, builder: (context, state) => const VpnStatusScreen()),
    GoRoute(path: AppRoutes.categories, builder: (context, state) => const CategoryGridPage()),
    GoRoute(
      path: AppRoutes.category,
      builder: (context, state) {
        final categoryId = state.pathParameters['id'] ?? 'Unknown';
        return CategoryFeedPage(categoryName: categoryId);
      },
    ),
    GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfilePage()),
    GoRoute(path: AppRoutes.profileEdit, builder: (context, state) => const EditProfilePage()),
    GoRoute(path: AppRoutes.notifications, builder: (context, state) => const NotificationsPage()),
    GoRoute(path: AppRoutes.downloads, builder: (context, state) => const DownloadsPage()),
    GoRoute(path: AppRoutes.playlists, builder: (context, state) => const PlaylistsPage()),
    GoRoute(
      path: AppRoutes.playlistDetail,
      builder: (context, state) {
        final playlistId = state.pathParameters['id'] ?? '';
        return PlaylistDetailPage(playlistId: playlistId);
      },
    ),
    GoRoute(path: AppRoutes.liked, builder: (context, state) => const LikedVideosPage()),
    GoRoute(path: AppRoutes.settings, builder: (context, state) => const SettingsPage()),
    GoRoute(
      path: AppRoutes.settingsPlayback,
      builder: (context, state) => const PlaybackSettingsPage(), // To be implemented later
    ),
    GoRoute(
      path: AppRoutes.settingsParental,
      builder: (context, state) => const ParentalControlPage(), // To be implemented later
    ),
    GoRoute(path: AppRoutes.help, builder: (context, state) => const HelpFaqPage()),
    GoRoute(path: AppRoutes.about, builder: (context, state) => const AboutPage()),
    GoRoute(path: AppRoutes.cast, builder: (context, state) => const CastPage()),
  ],
);
