import 'package:hive/hive.dart';

part 'bookmark_entry.g.dart';

@HiveType(typeId: 3)
class BookmarkEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String videoId;

  @HiveField(2)
  final String savedAt;

  @HiveField(3)
  final String? note;

  BookmarkEntry({
    required this.id,
    required this.videoId,
    required this.savedAt,
    this.note,
  });
}
