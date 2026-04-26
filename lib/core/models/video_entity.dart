import 'package:hive/hive.dart';

part 'video_entity.g.dart';

@HiveType(typeId: 1)
class VideoEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String thumbnailUrl;

  @HiveField(3)
  final String duration;

  @HiveField(4)
  final String embedCode;

  @HiveField(5)
  final String category;

  VideoEntity({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.embedCode,
    required this.category,
  });
}
