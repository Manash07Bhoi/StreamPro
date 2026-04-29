// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistItemAdapter extends TypeAdapter<PlaylistItem> {
  @override
  final int typeId = 6;

  @override
  PlaylistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaylistItem(
      id: fields[0] as String,
      playlistId: fields[1] as String,
      videoId: fields[2] as String,
      position: fields[3] as int,
      addedAt: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlaylistItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.playlistId)
      ..writeByte(2)
      ..write(obj.videoId)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
