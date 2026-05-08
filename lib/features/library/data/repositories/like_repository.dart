import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/like_record.dart';
import 'package:uuid/uuid.dart';

class LikeRepository {
  static const String likesBoxName = 'likes_box';

  Future<void> setReaction(String videoId, String reaction) async {
    final box = Hive.box<LikeRecord>(likesBoxName);

    LikeRecord? existingRecord;
    try {
      existingRecord = box.values.firstWhere((e) => e.videoId == videoId);
    } catch (e) {
      existingRecord = null;
    }

    if (existingRecord != null) {
      final updated = LikeRecord(
        id: existingRecord.id,
        videoId: videoId,
        reaction: reaction,
        reactedAt: DateTime.now().toIso8601String(),
      );
      await box.put(updated.id, updated);
    } else {
      final newRecord = LikeRecord(
        id: const Uuid().v4(),
        videoId: videoId,
        reaction: reaction,
        reactedAt: DateTime.now().toIso8601String(),
      );
      await box.put(newRecord.id, newRecord);
    }
  }

  String getReaction(String videoId) {
    final box = Hive.box<LikeRecord>(likesBoxName);
    try {
      return box.values.firstWhere((e) => e.videoId == videoId).reaction;
    } catch (e) {
      return 'none';
    }
  }

  List<LikeRecord> getLikedVideos() {
    final box = Hive.box<LikeRecord>(likesBoxName);
    return box.values.where((r) => r.reaction == 'like').toList()
      ..sort((a, b) =>
          DateTime.parse(b.reactedAt).compareTo(DateTime.parse(a.reactedAt)));
  }

  int getLikeCount() {
    final box = Hive.box<LikeRecord>(likesBoxName);
    return box.values.where((r) => r.reaction == 'like').length;
  }
}
