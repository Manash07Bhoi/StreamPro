import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/bookmark_entry.dart';
import 'package:uuid/uuid.dart';

class BookmarkRepository {
  static const String bookmarksBoxName = 'bookmarks_box';

  Future<void> addBookmark(String videoId, {String? note}) async {
    final box = Hive.box<BookmarkEntry>(bookmarksBoxName);
    if (!isBookmarked(videoId)) {
      final newEntry = BookmarkEntry(
        id: const Uuid().v4(),
        videoId: videoId,
        savedAt: DateTime.now().toIso8601String(),
        note: note,
      );
      await box.put(newEntry.id, newEntry);
    }
  }

  Future<void> removeBookmark(String videoId) async {
    final box = Hive.box<BookmarkEntry>(bookmarksBoxName);
    BookmarkEntry? entryToDelete;
    try {
      entryToDelete = box.values.firstWhere((e) => e.videoId == videoId);
    } catch (e) {
      entryToDelete = null;
    }
    if (entryToDelete != null) {
      await box.delete(entryToDelete.id);
    }
  }

  bool isBookmarked(String videoId) {
    final box = Hive.box<BookmarkEntry>(bookmarksBoxName);
    try {
      box.values.firstWhere((e) => e.videoId == videoId);
      return true;
    } catch (e) {
      return false;
    }
  }

  List<BookmarkEntry> getBookmarks({int limit = 50, int offset = 0}) {
    final box = Hive.box<BookmarkEntry>(bookmarksBoxName);
    final sorted = box.values.toList()..sort((a, b) => DateTime.parse(b.savedAt).compareTo(DateTime.parse(a.savedAt)));
    final start = offset;
    if (start >= sorted.length) return [];
    final end = (start + limit > sorted.length) ? sorted.length : start + limit;
    return sorted.sublist(start, end);
  }

  Future<void> clearAllBookmarks() async {
    final box = Hive.box<BookmarkEntry>(bookmarksBoxName);
    await box.clear();
  }
}
