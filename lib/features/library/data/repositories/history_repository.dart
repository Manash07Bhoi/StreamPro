import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/watch_history_entry.dart';
import 'package:uuid/uuid.dart';

class HistoryRepository {
  static const String historyBoxName = 'history_box';

  Future<void> addOrUpdateHistory(String videoId,
      {int watchedDurationSeconds = 0, double progressPercent = 0.0}) async {
    final box = Hive.box<WatchHistoryEntry>(historyBoxName);

    WatchHistoryEntry? existingEntry;
    try {
      existingEntry = box.values.firstWhere((e) => e.videoId == videoId);
    } catch (e) {
      existingEntry = null;
    }

    if (existingEntry != null) {
      final updatedEntry = WatchHistoryEntry(
        id: existingEntry.id,
        videoId: existingEntry.videoId,
        watchedAt: DateTime.now().toIso8601String(),
        watchedDurationSeconds: watchedDurationSeconds,
        progressPercent: progressPercent,
        isCompleted: progressPercent >= 0.9,
        watchCount: progressPercent >= 0.9 && !existingEntry.isCompleted
            ? existingEntry.watchCount + 1
            : existingEntry.watchCount,
      );
      await box.put(updatedEntry.id, updatedEntry);
    } else {
      final newEntry = WatchHistoryEntry(
        id: const Uuid().v4(),
        videoId: videoId,
        watchedAt: DateTime.now().toIso8601String(),
        watchedDurationSeconds: watchedDurationSeconds,
        progressPercent: progressPercent,
        isCompleted: progressPercent >= 0.9,
        watchCount: 1,
      );
      await box.put(newEntry.id, newEntry);
    }
  }

  List<WatchHistoryEntry> getHistory({int limit = 50, int offset = 0}) {
    final box = Hive.box<WatchHistoryEntry>(historyBoxName);
    final sorted = box.values.toList()
      ..sort((a, b) =>
          DateTime.parse(b.watchedAt).compareTo(DateTime.parse(a.watchedAt)));
    final start = offset;
    if (start >= sorted.length) return [];
    final end = (start + limit > sorted.length) ? sorted.length : start + limit;
    return sorted.sublist(start, end);
  }

  Future<void> removeFromHistory(String videoId) async {
    final box = Hive.box<WatchHistoryEntry>(historyBoxName);
    WatchHistoryEntry? entryToDelete;
    try {
      entryToDelete = box.values.firstWhere((e) => e.videoId == videoId);
    } catch (e) {
      entryToDelete = null;
    }
    if (entryToDelete != null) {
      await box.delete(entryToDelete.id);
    }
  }

  Future<void> clearAllHistory() async {
    final box = Hive.box<WatchHistoryEntry>(historyBoxName);
    await box.clear();
  }

  WatchHistoryEntry? getHistoryEntry(String videoId) {
    final box = Hive.box<WatchHistoryEntry>(historyBoxName);
    try {
      return box.values.firstWhere((e) => e.videoId == videoId);
    } catch (e) {
      return null;
    }
  }
}
