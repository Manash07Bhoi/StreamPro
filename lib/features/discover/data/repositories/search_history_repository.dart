import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/search_history_entry.dart';
import 'package:uuid/uuid.dart';

class SearchHistoryRepository {
  static const String searchHistoryBoxName = 'search_history_box';

  Future<void> addSearchQuery(String query, int resultCount) async {
    final box = Hive.box<SearchHistoryEntry>(searchHistoryBoxName);

    // Deduplicate: remove if already exists (case-insensitive)
    final existingIds = box.values
        .where((e) => e.query.toLowerCase() == query.toLowerCase())
        .map((e) => e.id)
        .toList();
    for (var id in existingIds) {
      await box.delete(id);
    }

    final newEntry = SearchHistoryEntry(
      id: const Uuid().v4(),
      query: query,
      searchedAt: DateTime.now().toIso8601String(),
      resultCount: resultCount,
    );
    await box.put(newEntry.id, newEntry);
  }

  List<SearchHistoryEntry> getRecentSearches({int limit = 10}) {
    final box = Hive.box<SearchHistoryEntry>(searchHistoryBoxName);
    final sorted = box.values.toList()
      ..sort((a, b) =>
          DateTime.parse(b.searchedAt).compareTo(DateTime.parse(a.searchedAt)));
    return sorted.take(limit).toList();
  }

  Future<void> removeSearch(String id) async {
    final box = Hive.box<SearchHistoryEntry>(searchHistoryBoxName);
    await box.delete(id);
  }

  Future<void> clearSearchHistory() async {
    final box = Hive.box<SearchHistoryEntry>(searchHistoryBoxName);
    await box.clear();
  }
}
