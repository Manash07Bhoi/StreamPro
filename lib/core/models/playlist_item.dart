import 'package:hive/hive.dart';

part 'playlist_item.g.dart';

@HiveType(typeId: 6)
class PlaylistItem extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String playlistId;
  @HiveField(2) String videoId;
  @HiveField(3) int position;
  @HiveField(4) String addedAt;

  PlaylistItem({
    required this.id,
    required this.playlistId,
    required this.videoId,
    required this.position,
    required this.addedAt,
  });
}
