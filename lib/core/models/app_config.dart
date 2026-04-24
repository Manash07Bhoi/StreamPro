import 'package:hive/hive.dart';

part 'app_config.g.dart';

@HiveType(typeId: 0)
class AppConfig extends HiveObject {
  @HiveField(0)
  bool isVpnEnabled;

  @HiveField(1)
  String lastConnectedCountry;

  @HiveField(2)
  String themeMode;

  AppConfig({
    this.isVpnEnabled = false,
    this.lastConnectedCountry = '',
    this.themeMode = 'dark',
  });
}
