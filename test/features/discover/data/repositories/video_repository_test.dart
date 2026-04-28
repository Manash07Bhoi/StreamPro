import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:streampro/core/models/video_entity.dart';
import 'package:streampro/features/discover/data/repositories/video_repository.dart';

void main() {
  late VideoRepository repository;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(VideoEntityAdapter());
    }
    repository = VideoRepository();
  });

  tearDown(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('initSampleData & getAllVideos', () {
    test('initSampleData populates exactly 30 videos when box is empty', () async {
      await repository.initSampleData();
      final videos = await repository.getAllVideos();
      expect(videos.length, 30);
      expect(videos.first.id, 'vid_1');
      expect(videos.last.id, 'vid_30');
    });

    test('initSampleData does not add more videos if box is already populated', () async {
      await repository.initSampleData(); // First init
      await repository.initSampleData(); // Second init
      final videos = await repository.getAllVideos();
      expect(videos.length, 30);
    });

    test('getAllVideos returns empty list when no data', () async {
      final videos = await repository.getAllVideos();
      expect(videos, isEmpty);
    });
  });

  group('getVideosByCategory & searchVideos', () {
    setUp(() async {
      await repository.initSampleData();
    });

    test('getVideosByCategory returns only videos matching category', () async {
      const category = 'Action';
      final videos = await repository.getVideosByCategory(category);
      expect(videos.every((v) => v.category == category), isTrue);
      expect(videos, isNotEmpty);
    });

    test('getVideosByCategory returns empty list for non-existent category', () async {
      final videos = await repository.getVideosByCategory('NonExistent');
      expect(videos, isEmpty);
    });

    test('searchVideos returns videos matching query (case-insensitive)', () async {
      final videos = await repository.searchVideos('premium');
      expect(videos.length, 30); // All generated titles contain 'Premium'

      final actionVideos = await repository.searchVideos('action');
      expect(actionVideos.every((v) => v.title.toLowerCase().contains('action')), isTrue);
      expect(actionVideos, isNotEmpty);
    });

    test('searchVideos returns empty list when no match', () async {
      final videos = await repository.searchVideos('xyz123');
      expect(videos, isEmpty);
    });
  });

  group('getVideosPaged', () {
    setUp(() async {
      await repository.initSampleData();
    });

    test('returns first 10 videos for page 0 and limit 10', () async {
      final videos = await repository.getVideosPaged(0, 10);
      expect(videos.length, 10);
      expect(videos.first.id, 'vid_1');
      expect(videos.last.id, 'vid_10');
    });

    test('returns correct videos for second page', () async {
      final videos = await repository.getVideosPaged(1, 10);
      expect(videos.length, 10);
      expect(videos.first.id, 'vid_11');
      expect(videos.last.id, 'vid_20');
    });

    test('returns remaining videos for last page', () async {
      final videos = await repository.getVideosPaged(2, 12); // Total 30. Page 0: 0-11, Page 1: 12-23, Page 2: 24-29 (length 6)
      expect(videos.length, 6);
    });

    test('returns empty list for out-of-bounds page', () async {
      final videos = await repository.getVideosPaged(3, 10);
      expect(videos, isEmpty);
    });
  });

  group('History Management', () {
    final video1 = VideoEntity(
      id: 'v1',
      title: 'T1',
      thumbnailUrl: 'U1',
      duration: 'D1',
      embedCode: 'E1',
      category: 'C1',
    );
    final video2 = VideoEntity(
      id: 'v2',
      title: 'T2',
      thumbnailUrl: 'U2',
      duration: 'D2',
      embedCode: 'E2',
      category: 'C2',
    );

    test('addToHistory adds video and getHistory returns it', () async {
      await repository.addToHistory(video1);
      final history = await repository.getHistory();
      expect(history.length, 1);
      expect(history.first.id, 'v1');
    });

    test('addToHistory moves existing video to top (LIFO)', () async {
      await repository.addToHistory(video1);
      await repository.addToHistory(video2);

      var history = await repository.getHistory();
      expect(history[0].id, 'v2');
      expect(history[1].id, 'v1');

      await repository.addToHistory(video1); // Move v1 to top
      history = await repository.getHistory();
      expect(history[0].id, 'v1');
      expect(history[1].id, 'v2');
      expect(history.length, 2);
    });

    test('getHistory returns empty list when no history', () async {
      final history = await repository.getHistory();
      expect(history, isEmpty);
    });
  });

  group('Bookmarks Management', () {
    final video1 = VideoEntity(
      id: 'v1',
      title: 'T1',
      thumbnailUrl: 'U1',
      duration: 'D1',
      embedCode: 'E1',
      category: 'C1',
    );

    test('toggleBookmark adds and removes video', () async {
      expect(await repository.isBookmarked('v1'), isFalse);

      await repository.toggleBookmark(video1);
      expect(await repository.isBookmarked('v1'), isTrue);
      var bookmarks = await repository.getBookmarks();
      expect(bookmarks.length, 1);
      expect(bookmarks.first.id, 'v1');

      await repository.toggleBookmark(video1);
      expect(await repository.isBookmarked('v1'), isFalse);
      bookmarks = await repository.getBookmarks();
      expect(bookmarks, isEmpty);
    });

    test('getBookmarks returns videos in reversed order', () async {
      final video2 = VideoEntity(
        id: 'v2',
        title: 'T2',
        thumbnailUrl: 'U2',
        duration: 'D2',
        embedCode: 'E2',
        category: 'C2',
      );

      await repository.toggleBookmark(video1);
      await repository.toggleBookmark(video2);

      final bookmarks = await repository.getBookmarks();
      expect(bookmarks[0].id, 'v2');
      expect(bookmarks[1].id, 'v1');
    });

    test('getBookmarks returns empty list when no bookmarks', () async {
      final bookmarks = await repository.getBookmarks();
      expect(bookmarks, isEmpty);
    });
  });
}
