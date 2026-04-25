import 'package:hive/hive.dart';

part 'watch_history_entry.g.dart';

@HiveType(typeId: 2)
class WatchHistoryEntry extends HiveObject {
  @HiveField(0) String id;               // UUID v4
  @HiveField(1) String videoId;          // Foreign key
  @HiveField(2) String watchedAt;        // ISO8601 DateTime string
  @HiveField(3) int watchedDurationSeconds;
  @HiveField(4) double progressPercent;  // 0.0-1.0
  @HiveField(5) bool isCompleted;        // progressPercent >= 0.9
  @HiveField(6) int watchCount;

  WatchHistoryEntry({
    required this.id,
    required this.videoId,
    required this.watchedAt,
    required this.watchedDurationSeconds,
    required this.progressPercent,
    required this.isCompleted,
    required this.watchCount,
  });
}
