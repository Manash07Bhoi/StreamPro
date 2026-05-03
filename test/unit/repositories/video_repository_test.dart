import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streampro/core/models/video_entity.dart';
import 'package:streampro/features/discover/data/repositories/video_repository.dart';
import 'dart:io';

void main() {
  late VideoRepository repository;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(VideoEntityAdapter());
    }
    await Hive.openBox<VideoEntity>('videos_box');
    repository = VideoRepository();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('VideoRepository', () {
    test('initializeSeedData creates exactly 60 videos', () async {
      await repository.initializeSeedData();
      final videos = repository.getVideos();
      expect(videos.length, 60);

      // Verify category distribution
      final actionCount = videos.where((v) => v.category == 'Action').length;
      final comedyCount = videos.where((v) => v.category == 'Comedy').length;
      final dramaCount = videos.where((v) => v.category == 'Drama').length;

      expect(actionCount, 10);
      expect(comedyCount, 8);
      expect(dramaCount, 8);
    });

    test('getVideosByCategory returns only videos matching that category', () async {
      await repository.initializeSeedData();
      final videos = await repository.getVideosByCategory('Action');

      expect(videos.length, 10);
      for (var video in videos) {
        expect(video.category, 'Action');
      }
    });

    test('searchVideos returns results for partial title match', () async {
      await repository.initializeSeedData();

      // Since seed titles are like "Premium Action Video 1"
      final results = await repository.searchVideos('Action Video 1');
      expect(results.length, 2); // Could be 1 or 10 depending on matching logic (e.g. 1 and 10) - Actually 10 will match "Action Video 10"
      expect(results.every((v) => v.title.toLowerCase().contains('action video 1')), true);
    });

    test('searchVideos excludes requiresAgeVerification videos when isAgeVerified is false', () async {
      await repository.initializeSeedData();

      // Artificially modify one video to require age verification
      final box = Hive.box<VideoEntity>('videos_box');
      final videoToModify = box.values.firstWhere((v) => v.title == 'Premium Action Video 1');
      final modifiedVideo = VideoEntity(
        id: videoToModify.id,
        title: videoToModify.title,
        thumbnailUrl: videoToModify.thumbnailUrl,
        duration: videoToModify.duration,
        durationSeconds: videoToModify.durationSeconds,
        embedCode: videoToModify.embedCode,
        category: videoToModify.category,
        description: videoToModify.description,
        channelName: videoToModify.channelName,
        channelAvatar: videoToModify.channelAvatar,
        viewCount: videoToModify.viewCount,
        likeCount: videoToModify.likeCount,
        dislikeCount: videoToModify.dislikeCount,
        uploadedAt: videoToModify.uploadedAt,
        tags: videoToModify.tags,
        isNew: videoToModify.isNew,
        isTrending: videoToModify.isTrending,
        isHD: videoToModify.isHD,
        isFeatured: videoToModify.isFeatured,
        contentRating: 'R',
        requiresAgeVerification: true,
        subtitleUrl: videoToModify.subtitleUrl,
        relatedVideoIds: videoToModify.relatedVideoIds,
        playlistPreviewUrl: videoToModify.playlistPreviewUrl,
        commentCount: videoToModify.commentCount,
        isDownloadable: videoToModify.isDownloadable,
      );
      await box.put(modifiedVideo.id, modifiedVideo);

      // Search without age restriction (should find it)
      final allResults = await repository.searchVideos('Premium Action Video 1', ageRestricted: false);
      expect(allResults.any((v) => v.id == modifiedVideo.id), true);

      // Search with age restriction (should NOT find it)
      final restrictedResults = await repository.searchVideos('Premium Action Video 1', ageRestricted: true);
      expect(restrictedResults.any((v) => v.id == modifiedVideo.id), false);
    });
  });
}
