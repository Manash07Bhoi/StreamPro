import 'package:hive/hive.dart';

part 'app_notification.g.dart';

@HiveType(typeId: 10)
class AppNotification extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String body;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final String? actionRoute;

  @HiveField(6)
  final String? actionArg;

  @HiveField(7)
  final bool isRead;

  @HiveField(8)
  final String createdAt;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.imageUrl,
    this.actionRoute,
    this.actionArg,
    required this.isRead,
    required this.createdAt,
  });
}
