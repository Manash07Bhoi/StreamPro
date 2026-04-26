// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoEntityAdapter extends TypeAdapter<VideoEntity> {
  @override
  final int typeId = 1;

  @override
  VideoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoEntity(
      id: fields[0] as String,
      title: fields[1] as String,
      thumbnailUrl: fields[2] as String,
      duration: fields[3] as String,
      embedCode: fields[4] as String,
      category: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.thumbnailUrl)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.embedCode)
      ..writeByte(5)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
