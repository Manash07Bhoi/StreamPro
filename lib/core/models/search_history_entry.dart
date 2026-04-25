import 'package:hive/hive.dart';

part 'search_history_entry.g.dart';

@HiveType(typeId: 11)
class SearchHistoryEntry extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String query;
  @HiveField(2) String searchedAt;
  @HiveField(3) int resultCount;

  SearchHistoryEntry({
    required this.id,
    required this.query,
    required this.searchedAt,
    required this.resultCount,
  });
}
