import 'package:hive/hive.dart';

part 'watch_history_entry.g.dart';

@HiveType(typeId: 2)
class WatchHistoryEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String videoId;

  @HiveField(2)
  final String watchedAt;

  @HiveField(3)
  final int watchedDurationSeconds;

  @HiveField(4)
  final double progressPercent;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final int watchCount;

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
