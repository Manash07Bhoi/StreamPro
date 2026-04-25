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
      durationSeconds: fields[4] as int,
      embedCode: fields[5] as String,
      category: fields[6] as String,
      description: fields[7] as String,
      channelName: fields[8] as String,
      channelAvatar: fields[9] as String,
      viewCount: fields[10] as int,
      likeCount: fields[11] as int,
      dislikeCount: fields[12] as int,
      uploadedAt: fields[13] as String,
      tags: (fields[14] as List).cast<String>(),
      isNew: fields[15] as bool,
      isTrending: fields[16] as bool,
      isHD: fields[17] as bool,
      isFeatured: fields[18] as bool,
      contentRating: fields[19] as String,
      requiresAgeVerification: fields[20] as bool,
      subtitleUrl: fields[21] as String,
      relatedVideoIds: (fields[22] as List).cast<String>(),
      playlistPreviewUrl: fields[23] as String,
      commentCount: fields[24] as int,
      isDownloadable: fields[25] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, VideoEntity obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.thumbnailUrl)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.durationSeconds)
      ..writeByte(5)
      ..write(obj.embedCode)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.channelName)
      ..writeByte(9)
      ..write(obj.channelAvatar)
      ..writeByte(10)
      ..write(obj.viewCount)
      ..writeByte(11)
      ..write(obj.likeCount)
      ..writeByte(12)
      ..write(obj.dislikeCount)
      ..writeByte(13)
      ..write(obj.uploadedAt)
      ..writeByte(14)
      ..write(obj.tags)
      ..writeByte(15)
      ..write(obj.isNew)
      ..writeByte(16)
      ..write(obj.isTrending)
      ..writeByte(17)
      ..write(obj.isHD)
      ..writeByte(18)
      ..write(obj.isFeatured)
      ..writeByte(19)
      ..write(obj.contentRating)
      ..writeByte(20)
      ..write(obj.requiresAgeVerification)
      ..writeByte(21)
      ..write(obj.subtitleUrl)
      ..writeByte(22)
      ..write(obj.relatedVideoIds)
      ..writeByte(23)
      ..write(obj.playlistPreviewUrl)
      ..writeByte(24)
      ..write(obj.commentCount)
      ..writeByte(25)
      ..write(obj.isDownloadable);
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
