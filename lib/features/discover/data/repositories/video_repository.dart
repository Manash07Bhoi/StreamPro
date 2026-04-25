import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/models/video_entity.dart';
import 'dart:math';

class VideoRepository {
  final Box<VideoEntity> _box = Hive.box<VideoEntity>('videos_box');
  final _uuid = const Uuid();

  Future<void> initializeSeedData() async {
    if (_box.isNotEmpty) return;

    final random = Random();

    final Map<String, int> categoryCounts = {
      'Action': 10,
      'Comedy': 8,
      'Drama': 8,
      'Documentary': 7,
      'Music': 7,
      'Sports': 6,
      'Technology': 7,
      'Travel': 7,
    };

    final List<VideoEntity> videos = [];

    categoryCounts.forEach((category, count) {
      for (int i = 0; i < count; i++) {
        final durationSecs = random.nextInt(2500) + 180;
        final mins = durationSecs ~/ 60;
        final secs = durationSecs % 60;
        final durationStr = '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

        final v = VideoEntity(
          id: _uuid.v4(),
          title: 'Sample $category Video ${i + 1}',
          thumbnailUrl: 'https://picsum.photos/seed/${_uuid.v4()}/640/360',
          duration: durationStr,
          durationSeconds: durationSecs,
          embedCode: '<iframe width="100%" height="100%" src="https://www.youtube.com/embed/dQw4w9WgXcQ?autoplay=1&controls=0" frameborder="0" allowfullscreen></iframe>',
          category: category,
          description: 'A compelling 1-2 sentence description of this video. Learn more about $category.',
          channelName: 'StreamPro $category',
          channelAvatar: 'https://picsum.photos/seed/${_uuid.v4()}/100/100',
          viewCount: random.nextInt(9900000) + 100000,
          likeCount: random.nextInt(499000) + 1000,
          dislikeCount: random.nextInt(4900) + 100,
          uploadedAt: DateTime.now().subtract(Duration(days: random.nextInt(365))).toIso8601String(),
          tags: ['4K', 'HDR', category],
          isNew: random.nextBool(),
          isTrending: random.nextDouble() > 0.7,
          isHD: random.nextBool(),
          isFeatured: videos.length < 6, // first 6 overall are featured
          contentRating: random.nextBool() ? 'PG-13' : 'G',
          requiresAgeVerification: false,
          subtitleUrl: '',
          relatedVideoIds: [],
          playlistPreviewUrl: '',
          commentCount: random.nextInt(11) + 5, // 5 to 15
          isDownloadable: true,
        );
        videos.add(v);
      }
    });

    // Shuffle the videos to mix featured/new ones
    videos.shuffle(random);

    // Assign featured to the first 6 after shuffle? Or just keep original.
    // The PRD says "isFeatured == true, up to 6 items". Let's explicitly set 6 to true, others false.
    for (int i = 0; i < videos.length; i++) {
       videos[i].isFeatured = i < 6;
    }

    for (var v in videos) {
      v.relatedVideoIds = videos.where((ov) => ov.category == v.category && ov.id != v.id).take(5).map((ov) => ov.id).toList();
      await _box.put(v.id, v);
    }
  }

  List<VideoEntity> getAllVideos() {
    return _box.values.toList();
  }

  VideoEntity? getVideoById(String id) {
    return _box.get(id);
  }

  List<VideoEntity> getPaginatedVideos({int limit = 10, int offset = 0}) {
    return _box.values.skip(offset).take(limit).toList();
  }

  List<VideoEntity> getVideosPaged({int limit = 10, int offset = 0}) {
    return getPaginatedVideos(limit: limit, offset: offset);
  }

  List<VideoEntity> getVideosByCategory(String category) {
     return _box.values.where((v) => v.category.toLowerCase() == category.toLowerCase()).toList();
  }

  List<VideoEntity> searchVideos(String query) {
     final q = query.toLowerCase();
     return _box.values.where((v) => v.title.toLowerCase().contains(q) || v.description.toLowerCase().contains(q)).toList();
  }

  // Stubs for old methods
  List<VideoEntity> getHistory() {
     return [];
  }
  List<VideoEntity> getBookmarks() {
     return [];
  }
  Future<void> addToHistory(VideoEntity video) async {}
  bool isBookmarked(String videoId) { return false; }
  Future<void> toggleBookmark(String videoId) async {}
}
