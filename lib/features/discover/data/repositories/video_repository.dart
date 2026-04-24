import '../../../../core/models/video_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class VideoRepository {
  static const String videoBoxName = 'videos_box';

  Future<void> initSampleData() async {
    final box = await Hive.openBox<VideoEntity>(videoBoxName);

    // Only populate if empty
    if (box.isEmpty) {
      final samples = _generateSampleVideos();
      for (var video in samples) {
        await box.put(video.id, video);
      }
    }
  }

  Future<List<VideoEntity>> getAllVideos() async {
    final box = await Hive.openBox<VideoEntity>(videoBoxName);
    return box.values.toList();
  }

  Future<List<VideoEntity>> getVideosByCategory(String category) async {
    final box = await Hive.openBox<VideoEntity>(videoBoxName);
    return box.values.where((video) => video.category == category).toList();
  }

  Future<List<VideoEntity>> searchVideos(String query) async {
    final box = await Hive.openBox<VideoEntity>(videoBoxName);
    return box.values
        .where((video) => video.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<VideoEntity> _generateSampleVideos() {
    final List<VideoEntity> list = [];
    final categories = ['Action', 'Comedy', 'Drama', 'Sci-Fi', 'Thriller'];

    for (int i = 1; i <= 30; i++) {
      String category = categories[i % categories.length];
      list.add(VideoEntity(
        id: 'vid_$i',
        title: 'Premium $category Video $i',
        // using picsum for random placeholder images
        thumbnailUrl: 'https://picsum.photos/seed/$i/600/400',
        duration: '${(10 + i % 5)}:${(10 + i * 2) % 60}',
        // dummy iframe for demonstration
        embedCode: '<iframe width="100%" height="100%" src="https://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allowfullscreen></iframe>',
        category: category,
      ));
    }
    return list;
  }
}
