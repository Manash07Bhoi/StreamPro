import 'package:hive/hive.dart';

part 'download_record.g.dart';

@HiveType(typeId: 4)
class DownloadRecord extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String videoId;
  @HiveField(2) String status;              // 'queued' | 'downloading' | 'completed' | 'failed' | 'paused'
  @HiveField(3) double progressPercent;
  @HiveField(4) int fileSizeBytes;
  @HiveField(5) int downloadedBytes;
  @HiveField(6) String startedAt;
  @HiveField(7) String? completedAt;
  @HiveField(8) String? localFilePath;
  @HiveField(9) String quality;             // '1080p' | '720p' | '480p'
  @HiveField(10) bool isExpired;
  @HiveField(11) String expiresAt;

  DownloadRecord({
    required this.id,
    required this.videoId,
    required this.status,
    required this.progressPercent,
    required this.fileSizeBytes,
    required this.downloadedBytes,
    required this.startedAt,
    this.completedAt,
    this.localFilePath,
    required this.quality,
    required this.isExpired,
    required this.expiresAt,
  });
}
