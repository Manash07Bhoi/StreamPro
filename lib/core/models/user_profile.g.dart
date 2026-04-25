// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 9;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      displayName: fields[1] as String,
      avatarUrl: fields[2] as String?,
      customAvatarPath: fields[3] as String?,
      createdAt: fields[4] as String,
      membershipType: fields[5] as String,
      totalLikes: fields[6] as int,
      totalWatchedVideos: fields[7] as int,
      totalWatchTimeSeconds: fields[8] as int,
      favoriteCategory: fields[9] as String,
      interests: (fields[10] as List).cast<String>(),
      birthYear: fields[11] as String,
      isAgeVerified: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.avatarUrl)
      ..writeByte(3)
      ..write(obj.customAvatarPath)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.membershipType)
      ..writeByte(6)
      ..write(obj.totalLikes)
      ..writeByte(7)
      ..write(obj.totalWatchedVideos)
      ..writeByte(8)
      ..write(obj.totalWatchTimeSeconds)
      ..writeByte(9)
      ..write(obj.favoriteCategory)
      ..writeByte(10)
      ..write(obj.interests)
      ..writeByte(11)
      ..write(obj.birthYear)
      ..writeByte(12)
      ..write(obj.isAgeVerified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
