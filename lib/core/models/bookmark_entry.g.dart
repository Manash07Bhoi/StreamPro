// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_entry.dart';

class BookmarkEntryAdapter extends TypeAdapter<BookmarkEntry> {
  @override
  final int typeId = 3;

  @override
  BookmarkEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookmarkEntry(
      id: fields[0] as String,
      videoId: fields[1] as String,
      savedAt: fields[2] as String,
      note: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookmarkEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.videoId)
      ..writeByte(2)
      ..write(obj.savedAt)
      ..writeByte(3)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
