import 'package:hive/hive.dart';

part 'app_config.g.dart';

@HiveType(typeId: 0)
class AppConfig extends HiveObject {
  @HiveField(0) bool isVpnEnabled;           // Default: false
  @HiveField(1) String lastConnectedCountry; // Default: 'US'
  @HiveField(2) String themeMode;            // 'dark' | 'light' | 'system'. Default: 'dark'
  @HiveField(3) bool hasAcceptedAgeGate;     // Default: false
  @HiveField(4) bool hasAcceptedTerms;       // Default: false
  @HiveField(5) bool hasAcceptedPrivacy;     // Default: false
  @HiveField(6) bool isFirstLaunch;          // Default: true
  @HiveField(7) String videoQuality;         // 'auto' | '1080p' | '720p' | '480p' | '360p'. Default: 'auto'
  @HiveField(8) bool autoPlayEnabled;        // Default: true
  @HiveField(9) bool autoPlayNextEnabled;    // Default: false
  @HiveField(10) bool notificationsEnabled;  // Default: true
  @HiveField(11) String preferredLanguage;   // Default: 'en'
  @HiveField(12) bool parentalControlEnabled;// Default: false
  @HiveField(13) String parentalPin;         // 4-digit PIN, empty string if not set
  @HiveField(14) double defaultBrightness;   // 0.0–1.0. Default: -1.0 (system)
  @HiveField(15) double defaultVolume;       // 0.0–1.0. Default: 1.0
  @HiveField(16) bool loopVideoEnabled;      // Default: false
  @HiveField(17) String onboardingCompletedAt; // ISO8601 DateTime string
  @HiveField(18) int totalWatchTimeSeconds;  // Cumulative, for profile stats
  @HiveField(19) bool showSubtitles;         // Default: false
  @HiveField(20) String appVersion;          // Stored version to detect upgrades

  AppConfig({
    this.isVpnEnabled = false,
    this.lastConnectedCountry = 'US',
    this.themeMode = 'dark',
    this.hasAcceptedAgeGate = false,
    this.hasAcceptedTerms = false,
    this.hasAcceptedPrivacy = false,
    this.isFirstLaunch = true,
    this.videoQuality = 'auto',
    this.autoPlayEnabled = true,
    this.autoPlayNextEnabled = false,
    this.notificationsEnabled = true,
    this.preferredLanguage = 'en',
    this.parentalControlEnabled = false,
    this.parentalPin = '',
    this.defaultBrightness = -1.0,
    this.defaultVolume = 1.0,
    this.loopVideoEnabled = false,
    this.onboardingCompletedAt = '',
    this.totalWatchTimeSeconds = 0,
    this.showSubtitles = false,
    this.appVersion = '1.0.0',
  });
}
