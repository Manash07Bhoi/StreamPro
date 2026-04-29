import 'package:hive/hive.dart';

part 'search_history_entry.g.dart';

@HiveType(typeId: 11)
class SearchHistoryEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String query;

  @HiveField(2)
  final String searchedAt;

  @HiveField(3)
  final int resultCount;

  SearchHistoryEntry({
    required this.id,
    required this.query,
    required this.searchedAt,
    required this.resultCount,
  });
}
