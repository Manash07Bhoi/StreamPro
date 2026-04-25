// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

class CommentAdapter extends TypeAdapter<Comment> {
  @override
  final int typeId = 8;

  @override
  Comment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Comment(
      id: fields[0] as String,
      videoId: fields[1] as String,
      authorName: fields[2] as String,
      authorAvatar: fields[3] as String,
      text: fields[4] as String,
      postedAt: fields[5] as String,
      likeCount: fields[6] as int,
      isUserComment: fields[7] as bool,
      parentId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Comment obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.videoId)
      ..writeByte(2)
      ..write(obj.authorName)
      ..writeByte(3)
      ..write(obj.authorAvatar)
      ..writeByte(4)
      ..write(obj.text)
      ..writeByte(5)
      ..write(obj.postedAt)
      ..writeByte(6)
      ..write(obj.likeCount)
      ..writeByte(7)
      ..write(obj.isUserComment)
      ..writeByte(8)
      ..write(obj.parentId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
