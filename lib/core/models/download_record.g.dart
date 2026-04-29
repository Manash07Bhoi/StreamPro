// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadRecordAdapter extends TypeAdapter<DownloadRecord> {
  @override
  final int typeId = 4;

  @override
  DownloadRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadRecord(
      id: fields[0] as String,
      videoId: fields[1] as String,
      status: fields[2] as String,
      progressPercent: fields[3] as double,
      fileSizeBytes: fields[4] as int,
      downloadedBytes: fields[5] as int,
      startedAt: fields[6] as String,
      completedAt: fields[7] as String?,
      localFilePath: fields[8] as String?,
      quality: fields[9] as String,
      isExpired: fields[10] as bool,
      expiresAt: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadRecord obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.videoId)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.progressPercent)
      ..writeByte(4)
      ..write(obj.fileSizeBytes)
      ..writeByte(5)
      ..write(obj.downloadedBytes)
      ..writeByte(6)
      ..write(obj.startedAt)
      ..writeByte(7)
      ..write(obj.completedAt)
      ..writeByte(8)
      ..write(obj.localFilePath)
      ..writeByte(9)
      ..write(obj.quality)
      ..writeByte(10)
      ..write(obj.isExpired)
      ..writeByte(11)
      ..write(obj.expiresAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
