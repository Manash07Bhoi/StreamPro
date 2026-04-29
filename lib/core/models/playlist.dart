import 'package:hive/hive.dart';

part 'playlist.g.dart';

@HiveType(typeId: 5)
class Playlist extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String createdAt;

  @HiveField(4)
  final String updatedAt;

  @HiveField(5)
  final String coverVideoId;

  @HiveField(6)
  final int videoCount;

  @HiveField(7)
  final bool isPublic;

  @HiveField(8)
  final String color;

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
