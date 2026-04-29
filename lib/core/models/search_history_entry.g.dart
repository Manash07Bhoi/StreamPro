// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchHistoryEntryAdapter extends TypeAdapter<SearchHistoryEntry> {
  @override
  final int typeId = 11;

  @override
  SearchHistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchHistoryEntry(
      id: fields[0] as String,
      query: fields[1] as String,
      searchedAt: fields[2] as String,
      resultCount: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SearchHistoryEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.query)
      ..writeByte(2)
      ..write(obj.searchedAt)
      ..writeByte(3)
      ..write(obj.resultCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchHistoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
