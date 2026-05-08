import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/download_record.dart';
import 'package:uuid/uuid.dart';

class DownloadRepository {
  static const String downloadsBoxName = 'downloads_box';

  Future<void> startDownload(String videoId, String quality) async {
    final box = Hive.box<DownloadRecord>(downloadsBoxName);

    final newEntry = DownloadRecord(
      id: const Uuid().v4(),
      videoId: videoId,
      status: 'downloading',
      progressPercent: 0.0,
      fileSizeBytes: 450 * 1024 * 1024, // Simulated 450 MB
      downloadedBytes: 0,
      startedAt: DateTime.now().toIso8601String(),
      quality: quality,
      isExpired: false,
      expiresAt: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
    );
    await box.put(newEntry.id, newEntry);
  }

  Future<void> pauseDownload(String downloadId) async {
    final box = Hive.box<DownloadRecord>(downloadsBoxName);
    final record = box.get(downloadId);
    if (record != null) {
      final updated = DownloadRecord(
        id: record.id,
        videoId: record.videoId,
        status: 'paused',
        progressPercent: record.progressPercent,
        fileSizeBytes: record.fileSizeBytes,
        downloadedBytes: record.downloadedBytes,
        startedAt: record.startedAt,
        completedAt: record.completedAt,
        localFilePath: record.localFilePath,
        quality: record.quality,
        isExpired: record.isExpired,
        expiresAt: record.expiresAt,
      );
      await box.put(downloadId, updated);
    }
  }

  Future<void> resumeDownload(String downloadId) async {
    final box = Hive.box<DownloadRecord>(downloadsBoxName);
    final record = box.get(downloadId);
    if (record != null) {
      final updated = DownloadRecord(
        id: record.id,
        videoId: record.videoId,
        status: 'downloading',
        progressPercent: record.progressPercent,
        fileSizeBytes: record.fileSizeBytes,
        downloadedBytes: record.downloadedBytes,
        startedAt: record.startedAt,
        completedAt: record.completedAt,
        localFilePath: record.localFilePath,
        quality: record.quality,
        isExpired: record.isExpired,
        expiresAt: record.expiresAt,
      );
      await box.put(downloadId, updated);
    }
  }

  Future<void> cancelDownload(String downloadId) async {
    await deleteDownload(downloadId);
  }

  Future<void> deleteDownload(String downloadId) async {
    final box = Hive.box<DownloadRecord>(downloadsBoxName);
    await box.delete(downloadId);
  }

  List<DownloadRecord> getAllDownloads() {
    final box = Hive.box<DownloadRecord>(downloadsBoxName);
    return box.values.toList()
      ..sort((a, b) =>
          DateTime.parse(b.startedAt).compareTo(DateTime.parse(a.startedAt)));
  }

  DownloadRecord? getDownloadForVideo(String videoId) {
    final box = Hive.box<DownloadRecord>(downloadsBoxName);
    try {
      return box.values.firstWhere((e) => e.videoId == videoId);
    } catch (e) {
      return null;
    }
  }

  int getTotalStorageUsedBytes() {
    final box = Hive.box<DownloadRecord>(downloadsBoxName);
    int total = 0;
    for (var record in box.values) {
      if (record.status == 'completed') {
        total += record.fileSizeBytes;
      }
    }
    return total;
  }

  Future<void> updateDownloadProgress(String downloadId, double progressPercent,
      int downloadedBytes, String status) async {
    final box = Hive.box<DownloadRecord>(downloadsBoxName);
    final record = box.get(downloadId);
    if (record != null) {
      final updated = DownloadRecord(
        id: record.id,
        videoId: record.videoId,
        status: status,
        progressPercent: progressPercent,
        fileSizeBytes: record.fileSizeBytes,
        downloadedBytes: downloadedBytes,
        startedAt: record.startedAt,
        completedAt: status == 'completed'
            ? DateTime.now().toIso8601String()
            : record.completedAt,
        localFilePath: status == 'completed'
            ? '/simulated/path/${record.videoId}.mp4'
            : record.localFilePath,
        quality: record.quality,
        isExpired: record.isExpired,
        expiresAt: record.expiresAt,
      );
      await box.put(downloadId, updated);
    }
  }
}
