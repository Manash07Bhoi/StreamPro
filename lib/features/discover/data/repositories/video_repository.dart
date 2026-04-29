import 'package:uuid/uuid.dart';
import '../../../../core/models/video_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

class VideoRepository {
  static const String videoBoxName = 'videos_box';

  List<VideoEntity> getVideos() {
    final box = Hive.box<VideoEntity>(videoBoxName);
    return box.values.toList();
  }

  Future<void> initializeSeedData() async {
    final box = Hive.box<VideoEntity>(videoBoxName);

    // Only populate if empty
    if (box.isEmpty) {
      final samples = _generateSampleVideos();
      final Map<String, VideoEntity> entries = {};
      for (var video in samples) {
        entries[video.id] = video;
      }
      await box.putAll(entries);
    }
  }

  Future<List<VideoEntity>> getAllVideos() async {
    final box = Hive.box<VideoEntity>(videoBoxName);
    return box.values.toList();
  }

  Future<List<VideoEntity>> getVideosByCategory(String category) async {
    final box = Hive.box<VideoEntity>(videoBoxName);
    return box.values.where((video) => video.category == category).toList();
  }

  Future<List<VideoEntity>> searchVideos(String query, {bool ageRestricted = false}) async {
    final box = Hive.box<VideoEntity>(videoBoxName);
    return box.values
        .where((video) {
          if (ageRestricted && video.requiresAgeVerification) {
            return false;
          }
          return video.title.toLowerCase().contains(query.toLowerCase());
        })
        .toList();
  }

  Future<List<VideoEntity>> getPaginatedVideos(int pageKey, int limit) async {
    final box = Hive.box<VideoEntity>(videoBoxName);
    final all = box.values.toList();
    final start = pageKey * limit;
    if (start >= all.length) return [];
    final end = (start + limit > all.length) ? all.length : start + limit;
    return all.sublist(start, end);
  }

  Future<List<VideoEntity>> getRelatedVideos(String category, String currentVideoId) async {
    final box = Hive.box<VideoEntity>(videoBoxName);
    return box.values.where((v) => v.category == category && v.id != currentVideoId).take(5).toList();
  }

  List<VideoEntity> _generateSampleVideos() {
    final List<VideoEntity> list = [];
    final categoryCounts = {'Action': 10, 'Comedy': 8, 'Drama': 8, 'Documentary': 7, 'Music': 7, 'Sports': 6, 'Technology': 7, 'Travel': 7};
    final random = Random();

    for (var entry in categoryCounts.entries) {
      String category = entry.key;
      int count = entry.value;

      for (int i = 0; i < count; i++) {
        final seed = list.length + 1;
        final durationSecs = random.nextInt(45 * 60 - 3 * 60) + 3 * 60; // 3 to 45 mins
        final minutes = durationSecs ~/ 60;
        final seconds = durationSecs % 60;

        list.add(VideoEntity(
          id: const Uuid().v4(),
          title: 'Premium $category Video ${i + 1}',
          thumbnailUrl: 'https://picsum.photos/seed/$seed/640/360',
          duration: '$minutes:${seconds.toString().padLeft(2, '0')}',
          durationSeconds: durationSecs,
          embedCode: '<iframe width="100%" height="100%" src="https://www.youtube.com/embed/dQw4w9WgXcQ?autoplay=1&controls=0" frameborder="0" allowfullscreen></iframe>',
          category: category,
          description: 'A compelling 1-2 sentence description of this $category video. Experience premium entertainment.',
          channelName: 'StreamPro $category',
          channelAvatar: 'https://picsum.photos/seed/channel_${category}_$i/100/100',
          viewCount: random.nextInt(9900000) + 100000, // 100k to 10M
          likeCount: random.nextInt(499000) + 1000,   // 1k to 500k
          dislikeCount: random.nextInt(4900) + 100,    // 100 to 5k
          uploadedAt: DateTime.now().subtract(Duration(days: random.nextInt(365) + 1)).toIso8601String(),
          tags: ['4K', 'HD', category],
          isNew: random.nextBool(),
          isTrending: random.nextBool(),
          isHD: random.nextBool(),
          isFeatured: seed <= 6, // first 6 are featured
          contentRating: random.nextBool() ? 'PG' : 'PG-13',
          requiresAgeVerification: false,
          subtitleUrl: '',
          relatedVideoIds: const [], // populated later if needed, or left empty
          playlistPreviewUrl: '',
          commentCount: random.nextInt(195) + 5, // 5 to 200
          isDownloadable: true,
        ));
      }
    }
    return list;
  }
}
