import 'package:hive/hive.dart';

part 'playlist_item.g.dart';

@HiveType(typeId: 6)
class PlaylistItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String playlistId;

  @HiveField(2)
  final String videoId;

  @HiveField(3)
  final int position;

  @HiveField(4)
  final String addedAt;

  PlaylistItem({
    required this.id,
    required this.playlistId,
    required this.videoId,
    required this.position,
    required this.addedAt,
  });
}
