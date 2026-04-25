import 'package:hive/hive.dart';

part 'comment.g.dart';

@HiveType(typeId: 8)
class Comment extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String videoId;
  @HiveField(2) String authorName;
  @HiveField(3) String authorAvatar;
  @HiveField(4) String text;
  @HiveField(5) String postedAt;
  @HiveField(6) int likeCount;
  @HiveField(7) bool isUserComment;
  @HiveField(8) String? parentId;

  Comment({
    required this.id,
    required this.videoId,
    required this.authorName,
    required this.authorAvatar,
    required this.text,
    required this.postedAt,
    required this.likeCount,
    required this.isUserComment,
    this.parentId,
  });
}
