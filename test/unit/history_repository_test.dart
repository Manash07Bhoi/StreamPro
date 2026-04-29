import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streampro/core/models/watch_history_entry.dart';
import 'package:streampro/features/library/data/repositories/history_repository.dart';
import 'dart:io';

void main() {
  late HistoryRepository repository;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(WatchHistoryEntryAdapter());
    }
    await Hive.openBox<WatchHistoryEntry>('history_box');
    repository = HistoryRepository();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('HistoryRepository', () {
    test('addOrUpdateHistory creates new entry if video not in history', () async {
      await repository.addOrUpdateHistory('vid_1', watchedDurationSeconds: 10, progressPercent: 0.1);
      final history = repository.getHistory();
      expect(history.length, 1);
      expect(history.first.videoId, 'vid_1');
      expect(history.first.watchedDurationSeconds, 10);
      expect(history.first.progressPercent, 0.1);
      expect(history.first.watchCount, 1);
    });

    test('addOrUpdateHistory updates existing entry on revisit', () async {
      await repository.addOrUpdateHistory('vid_1', watchedDurationSeconds: 10, progressPercent: 0.1);
      await repository.addOrUpdateHistory('vid_1', watchedDurationSeconds: 20, progressPercent: 0.2);
      final history = repository.getHistory();
      expect(history.length, 1);
      expect(history.first.watchedDurationSeconds, 20);
      expect(history.first.progressPercent, 0.2);
    });

    test('clearAllHistory empties the history box', () async {
      await repository.addOrUpdateHistory('vid_1');
      await repository.addOrUpdateHistory('vid_2');
      expect(repository.getHistory().length, 2);

      await repository.clearAllHistory();
      expect(repository.getHistory().length, 0);
    });
  });
}
