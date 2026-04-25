import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/models/comment.dart';
import '../../../../core/models/video_entity.dart';
import 'dart:math';

class CommentRepository {
  final Box<Comment> _commentsBox = Hive.box<Comment>('comments_box');
  final Box<VideoEntity> _videoBox = Hive.box<VideoEntity>('videos_box');
  final _uuid = const Uuid();

  Future<void> seedCommentsIfNeeded() async {
    if (_commentsBox.isNotEmpty) return;

    final names = ['Alex Rivera', 'Jordan Kim', 'Taylor Brooks', 'Morgan Chen', 'Sam Patel', 'Casey Wilson', 'Drew Thompson', 'Blake Anderson', 'Quinn Martinez', 'Reese Garcia', 'Avery Johnson', 'Riley Lee', 'Finley Williams', 'Peyton Davis', 'Hayden Brown', 'Dakota Miller', 'Sydney Moore', 'Cameron Taylor', 'Kendall Jackson', 'Sage White'];
    final random = Random();

    for (var video in _videoBox.values) {
      int count = video.commentCount;
      for (int i = 0; i < count; i++) {
        final authorIndex = random.nextInt(names.length);
        final c = Comment(
          id: _uuid.v4(),
          videoId: video.id,
          authorName: names[authorIndex],
          authorAvatar: 'https://picsum.photos/seed/${authorIndex + 1}/100/100',
          text: 'This is a sample comment on ${video.title}. Pretty cool video!',
          postedAt: DateTime.now().subtract(Duration(days: random.nextInt(30))).toIso8601String(),
          likeCount: random.nextInt(100),
          isUserComment: false,
        );
        await _commentsBox.put(c.id, c);
      }
    }
  }
}
