import 'package:hive/hive.dart';

part 'bookmark_entry.g.dart';

@HiveType(typeId: 3)
class BookmarkEntry extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String videoId;
  @HiveField(2) String savedAt;
  @HiveField(3) String? note;

  BookmarkEntry({
    required this.id,
    required this.videoId,
    required this.savedAt,
    this.note,
  });
}
