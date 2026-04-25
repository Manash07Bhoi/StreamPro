// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_record.dart';

class LikeRecordAdapter extends TypeAdapter<LikeRecord> {
  @override
  final int typeId = 7;

  @override
  LikeRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LikeRecord(
      id: fields[0] as String,
      videoId: fields[1] as String,
      reaction: fields[2] as String,
      reactedAt: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LikeRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.videoId)
      ..writeByte(2)
      ..write(obj.reaction)
      ..writeByte(3)
      ..write(obj.reactedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LikeRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
