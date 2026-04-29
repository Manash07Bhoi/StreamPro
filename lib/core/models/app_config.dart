import 'package:hive/hive.dart';

part 'app_config.g.dart';

@HiveType(typeId: 0)
class AppConfig extends HiveObject {
  @HiveField(0)
  bool isVpnEnabled = false;

  @HiveField(1)
  String lastConnectedCountry = 'US';

  @HiveField(2)
  String themeMode = 'dark';

  @HiveField(3)
  bool hasAcceptedAgeGate = false;

  @HiveField(4)
  bool hasAcceptedTerms = false;

  @HiveField(5)
  bool hasAcceptedPrivacy = false;

  @HiveField(6)
  bool isFirstLaunch = true;

  @HiveField(7)
  String videoQuality = 'auto';

  @HiveField(8)
  bool autoPlayEnabled = true;

  @HiveField(9)
  bool autoPlayNextEnabled = false;

  @HiveField(10)
  bool notificationsEnabled = true;

  @HiveField(11)
  String preferredLanguage = 'en';

  @HiveField(12)
  bool parentalControlEnabled = false;

  @HiveField(13)
  String parentalPin = '';

  @HiveField(14)
  double defaultBrightness = -1.0;

  @HiveField(15)
  double defaultVolume = 1.0;

  @HiveField(16)
  bool loopVideoEnabled = false;

  @HiveField(17)
  String onboardingCompletedAt = '';

  @HiveField(18)
  int totalWatchTimeSeconds = 0;

  @HiveField(19)
  bool showSubtitles = false;

  @HiveField(20)
  String appVersion = '';
}
