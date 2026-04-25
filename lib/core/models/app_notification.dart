import 'package:hive/hive.dart';

part 'app_notification.g.dart';

@HiveType(typeId: 10)
class AppNotification extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String type;         // 'new_video' | 'trending' | 'system' | 'reminder'
  @HiveField(2) String title;
  @HiveField(3) String body;
  @HiveField(4) String? imageUrl;
  @HiveField(5) String? actionRoute;
  @HiveField(6) String? actionArg;
  @HiveField(7) bool isRead;
  @HiveField(8) String createdAt;

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
