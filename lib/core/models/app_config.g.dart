// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppConfigAdapter extends TypeAdapter<AppConfig> {
  @override
  final int typeId = 0;

  @override
  AppConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppConfig(
      isVpnEnabled: fields[0] as bool,
      lastConnectedCountry: fields[1] as String,
      themeMode: fields[2] as String,
      hasAcceptedAgeGate: fields[3] as bool,
      hasAcceptedTerms: fields[4] as bool,
      hasAcceptedPrivacy: fields[5] as bool,
      isFirstLaunch: fields[6] as bool,
      videoQuality: fields[7] as String,
      autoPlayEnabled: fields[8] as bool,
      autoPlayNextEnabled: fields[9] as bool,
      notificationsEnabled: fields[10] as bool,
      preferredLanguage: fields[11] as String,
      parentalControlEnabled: fields[12] as bool,
      parentalPin: fields[13] as String,
      defaultBrightness: fields[14] as double,
      defaultVolume: fields[15] as double,
      loopVideoEnabled: fields[16] as bool,
      onboardingCompletedAt: fields[17] as String,
      totalWatchTimeSeconds: fields[18] as int,
      showSubtitles: fields[19] as bool,
      appVersion: fields[20] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppConfig obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.isVpnEnabled)
      ..writeByte(1)
      ..write(obj.lastConnectedCountry)
      ..writeByte(2)
      ..write(obj.themeMode)
      ..writeByte(3)
      ..write(obj.hasAcceptedAgeGate)
      ..writeByte(4)
      ..write(obj.hasAcceptedTerms)
      ..writeByte(5)
      ..write(obj.hasAcceptedPrivacy)
      ..writeByte(6)
      ..write(obj.isFirstLaunch)
      ..writeByte(7)
      ..write(obj.videoQuality)
      ..writeByte(8)
      ..write(obj.autoPlayEnabled)
      ..writeByte(9)
      ..write(obj.autoPlayNextEnabled)
      ..writeByte(10)
      ..write(obj.notificationsEnabled)
      ..writeByte(11)
      ..write(obj.preferredLanguage)
      ..writeByte(12)
      ..write(obj.parentalControlEnabled)
      ..writeByte(13)
      ..write(obj.parentalPin)
      ..writeByte(14)
      ..write(obj.defaultBrightness)
      ..writeByte(15)
      ..write(obj.defaultVolume)
      ..writeByte(16)
      ..write(obj.loopVideoEnabled)
      ..writeByte(17)
      ..write(obj.onboardingCompletedAt)
      ..writeByte(18)
      ..write(obj.totalWatchTimeSeconds)
      ..writeByte(19)
      ..write(obj.showSubtitles)
      ..writeByte(20)
      ..write(obj.appVersion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
