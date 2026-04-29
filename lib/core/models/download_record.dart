import 'package:hive/hive.dart';

part 'download_record.g.dart';

@HiveType(typeId: 4)
class DownloadRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String videoId;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final double progressPercent;

  @HiveField(4)
  final int fileSizeBytes;

  @HiveField(5)
  final int downloadedBytes;

  @HiveField(6)
  final String startedAt;

  @HiveField(7)
  final String? completedAt;

  @HiveField(8)
  final String? localFilePath;

  @HiveField(9)
  final String quality;

  @HiveField(10)
  final bool isExpired;

  @HiveField(11)
  final String expiresAt;

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
