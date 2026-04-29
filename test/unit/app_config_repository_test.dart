import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streampro/core/models/app_config.dart';
import 'package:streampro/features/settings/data/repositories/app_config_repository.dart';
import 'dart:io';

void main() {
  late AppConfigRepository repository;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AppConfigAdapter());
    }
    await Hive.openBox<AppConfig>('app_config_box');
    repository = AppConfigRepository();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('AppConfigRepository', () {
    test('getConfig returns correct defaults on first run', () {
      final config = repository.getConfig();
      expect(config.isFirstLaunch, true);
      expect(config.hasAcceptedTerms, false);
      expect(config.hasAcceptedPrivacy, false);
      expect(config.hasAcceptedAgeGate, false);
      expect(config.themeMode, 'dark');
      expect(config.videoQuality, 'auto');
    });
  });
}
