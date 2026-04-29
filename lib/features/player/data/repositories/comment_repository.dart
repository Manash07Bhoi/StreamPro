import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/comment.dart';
import '../../../../core/models/video_entity.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class CommentRepository {
  static const String commentsBoxName = 'comments_box';
  static const String videosBoxName = 'videos_box';

  Future<void> seedCommentsIfNeeded() async {
    final box = Hive.box<Comment>(commentsBoxName);
    if (box.isNotEmpty) return;

    final videoBox = Hive.box<VideoEntity>(videosBoxName);
    if (videoBox.isEmpty) return;

    final random = Random();
    final authors = [
      'Alex Rivera', 'Jordan Kim', 'Taylor Brooks', 'Morgan Chen', 'Sam Patel',
      'Casey Wilson', 'Drew Thompson', 'Blake Anderson', 'Quinn Martinez', 'Reese Garcia',
      'Avery Johnson', 'Riley Lee', 'Finley Williams', 'Peyton Davis', 'Hayden Brown',
      'Dakota Miller', 'Sydney Moore', 'Cameron Taylor', 'Kendall Jackson', 'Sage White'
    ];

    final sampleTexts = [
      "This is exactly what I was looking for!",
      "Great quality, thanks for sharing.",
      "I learned so much from this.",
      "Can't wait to see more content like this.",
      "The editing here is fantastic.",
      "This deserves way more views.",
      "Mind blown! 🤯",
      "I've watched this three times already.",
      "Could you make a part 2?",
      "Very insightful perspective."
    ];

    final Map<String, Comment> entries = {};

    for (var video in videoBox.values) {
      int count = random.nextInt(11) + 5; // 5 to 15 comments
      for (int i = 0; i < count; i++) {
        int authorIdx = random.nextInt(authors.length);
        String text = sampleTexts[random.nextInt(sampleTexts.length)];

        final comment = Comment(
          id: const Uuid().v4(),
          videoId: video.id,
          authorName: authors[authorIdx],
          authorAvatar: 'https://picsum.photos/seed/${authorIdx + 1}/100/100',
          text: text,
          postedAt: DateTime.now().subtract(Duration(days: random.nextInt(30), hours: random.nextInt(24))).toIso8601String(),
          likeCount: random.nextInt(50),
          isUserComment: false,
        );
        entries[comment.id] = comment;
      }
    }

    // Batch write to avoid main thread blockage
    await box.putAll(entries);
  }

  Future<Comment> addUserComment(String videoId, String text) async {
    final box = Hive.box<Comment>(commentsBoxName);

    final newComment = Comment(
      id: const Uuid().v4(),
      videoId: videoId,
      authorName: 'Guest User', // Placeholder until profile is wired in BLoC
      authorAvatar: '',
      text: text,
      postedAt: DateTime.now().toIso8601String(),
      likeCount: 0,
      isUserComment: true,
    );

    await box.put(newComment.id, newComment);
    return newComment;
  }

  Future<void> deleteUserComment(String commentId) async {
    final box = Hive.box<Comment>(commentsBoxName);
    final comment = box.get(commentId);
    if (comment != null && comment.isUserComment) {
      await box.delete(commentId);
    }
  }

  List<Comment> getCommentsForVideo(String videoId, {int limit = 30}) {
    final box = Hive.box<Comment>(commentsBoxName);
    final sorted = box.values.where((c) => c.videoId == videoId).toList()..sort((a, b) => DateTime.parse(b.postedAt).compareTo(DateTime.parse(a.postedAt)));
    return sorted.take(limit).toList();
  }

  int getCommentCount(String videoId) {
    final box = Hive.box<Comment>(commentsBoxName);
    return box.values.where((c) => c.videoId == videoId).length;
  }
}
