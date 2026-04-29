import 'package:hive/hive.dart';

part 'like_record.g.dart';

@HiveType(typeId: 7)
class LikeRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String videoId;

  @HiveField(2)
  final String reaction;

  @HiveField(3)
  final String reactedAt;

  LikeRecord({
    required this.id,
    required this.videoId,
    required this.reaction,
    required this.reactedAt,
  });
}
