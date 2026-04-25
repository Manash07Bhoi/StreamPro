import 'package:hive/hive.dart';

part 'like_record.g.dart';

@HiveType(typeId: 7)
class LikeRecord extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String videoId;
  @HiveField(2) String reaction;     // 'like' | 'dislike' | 'none'
  @HiveField(3) String reactedAt;

  LikeRecord({
    required this.id,
    required this.videoId,
    required this.reaction,
    required this.reactedAt,
  });
}
