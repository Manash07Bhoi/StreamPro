import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/app_config.dart';

class AppConfigRepository {
  static const String appConfigBoxName = 'app_config_box';

  AppConfig getConfig() {
    final box = Hive.box<AppConfig>(appConfigBoxName);
    if (box.isEmpty) {
      final config = AppConfig();
      box.put('config', config);
      return config;
    }
    return box.get('config')!;
  }

  Future<void> saveConfig(AppConfig config) async {
    final box = Hive.box<AppConfig>(appConfigBoxName);
    await box.put('config', config);
  }

  Future<void> updateField<T>(String field, T value) async {
    final config = getConfig();
    switch (field) {
      case 'isVpnEnabled':
        config.isVpnEnabled = value as bool;
        break;
      case 'lastConnectedCountry':
        config.lastConnectedCountry = value as String;
        break;
      case 'themeMode':
        config.themeMode = value as String;
        break;
      case 'hasAcceptedAgeGate':
        config.hasAcceptedAgeGate = value as bool;
        break;
      case 'hasAcceptedTerms':
        config.hasAcceptedTerms = value as bool;
        break;
      case 'hasAcceptedPrivacy':
        config.hasAcceptedPrivacy = value as bool;
        break;
      case 'isFirstLaunch':
        config.isFirstLaunch = value as bool;
        break;
      case 'videoQuality':
        config.videoQuality = value as String;
        break;
      case 'autoPlayEnabled':
        config.autoPlayEnabled = value as bool;
        break;
      case 'autoPlayNextEnabled':
        config.autoPlayNextEnabled = value as bool;
        break;
      case 'notificationsEnabled':
        config.notificationsEnabled = value as bool;
        break;
      case 'preferredLanguage':
        config.preferredLanguage = value as String;
        break;
      case 'parentalControlEnabled':
        config.parentalControlEnabled = value as bool;
        break;
      case 'parentalPin':
        config.parentalPin = value as String;
        break;
      case 'defaultBrightness':
        config.defaultBrightness = value as double;
        break;
      case 'defaultVolume':
        config.defaultVolume = value as double;
        break;
      case 'loopVideoEnabled':
        config.loopVideoEnabled = value as bool;
        break;
      case 'onboardingCompletedAt':
        config.onboardingCompletedAt = value as String;
        break;
      case 'totalWatchTimeSeconds':
        config.totalWatchTimeSeconds = value as int;
        break;
      case 'showSubtitles':
        config.showSubtitles = value as bool;
        break;
      case 'appVersion':
        config.appVersion = value as String;
        break;
    }
    await saveConfig(config);
  }

  Future<void> resetToDefaults() async {
    final box = Hive.box<AppConfig>(appConfigBoxName);
    await box.put('config', AppConfig());
  }
}
