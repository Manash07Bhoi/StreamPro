import 'package:hive/hive.dart';

part 'comment.g.dart';

@HiveType(typeId: 8)
class Comment extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String videoId;

  @HiveField(2)
  final String authorName;

  @HiveField(3)
  final String authorAvatar;

  @HiveField(4)
  final String text;

  @HiveField(5)
  final String postedAt;

  @HiveField(6)
  final int likeCount;

  @HiveField(7)
  final bool isUserComment;

  @HiveField(8)
  final String? parentId;

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
