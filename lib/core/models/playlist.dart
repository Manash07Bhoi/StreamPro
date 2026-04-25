import 'package:hive/hive.dart';

part 'playlist.g.dart';

@HiveType(typeId: 5)
class Playlist extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) String? description;
  @HiveField(3) String createdAt;
  @HiveField(4) String updatedAt;
  @HiveField(5) String coverVideoId;
  @HiveField(6) int videoCount;
  @HiveField(7) bool isPublic;
  @HiveField(8) String color;

  Playlist({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.coverVideoId,
    required this.videoCount,
    required this.isPublic,
    required this.color,
  });
}
