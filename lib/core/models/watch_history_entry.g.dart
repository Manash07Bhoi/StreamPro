// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_history_entry.dart';

class WatchHistoryEntryAdapter extends TypeAdapter<WatchHistoryEntry> {
  @override
  final int typeId = 2;

  @override
  WatchHistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchHistoryEntry(
      id: fields[0] as String,
      videoId: fields[1] as String,
      watchedAt: fields[2] as String,
      watchedDurationSeconds: fields[3] as int,
      progressPercent: fields[4] as double,
      isCompleted: fields[5] as bool,
      watchCount: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WatchHistoryEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.videoId)
      ..writeByte(2)
      ..write(obj.watchedAt)
      ..writeByte(3)
      ..write(obj.watchedDurationSeconds)
      ..writeByte(4)
      ..write(obj.progressPercent)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.watchCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchHistoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
