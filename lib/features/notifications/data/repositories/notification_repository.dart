import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/app_notification.dart';
import 'package:uuid/uuid.dart';

class NotificationRepository {
  static const String notificationsBoxName = 'notifications_box';

  Future<void> seedNotificationsIfNeeded() async {
    final box = Hive.box<AppNotification>(notificationsBoxName);
    if (box.isNotEmpty) return;

    final Map<String, AppNotification> entries = {};

    final seedData = [
      AppNotification(
        id: const Uuid().v4(),
        type: 'system',
        title: 'Welcome to StreamPro!',
        body: 'Start exploring thousands of premium videos across every genre.',
        isRead: false,
        createdAt: DateTime.now().toIso8601String(),
      ),
      AppNotification(
        id: const Uuid().v4(),
        type: 'trending',
        title: '🔥 Hot Right Now',
        body: 'Check out today\'s top trending videos.',
        isRead: false,
        createdAt:
            DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        actionRoute: '/home', // Redirects to trending
      ),
      AppNotification(
        id: const Uuid().v4(),
        type: 'new_video',
        title: 'New Releases',
        body: 'Fresh content has just been added to your favorite categories.',
        isRead: false,
        createdAt:
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      ),
      AppNotification(
        id: const Uuid().v4(),
        type: 'reminder',
        title: 'Don\'t forget your downloads',
        body: 'You have videos ready to watch offline.',
        isRead: false,
        createdAt:
            DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        actionRoute: '/downloads',
      ),
      AppNotification(
        id: const Uuid().v4(),
        type: 'system',
        title: 'Complete your profile',
        body: 'Add an avatar and customize your interests.',
        isRead: true,
        createdAt:
            DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        actionRoute: '/profile',
      ),
    ];

    for (var n in seedData) {
      entries[n.id] = n;
    }

    await box.putAll(entries);
  }

  Future<void> addNotification(AppNotification notification) async {
    final box = Hive.box<AppNotification>(notificationsBoxName);
    await box.put(notification.id, notification);
  }

  List<AppNotification> getAllNotifications({int limit = 50}) {
    final box = Hive.box<AppNotification>(notificationsBoxName);
    final sorted = box.values.toList()
      ..sort((a, b) =>
          DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));
    return sorted.take(limit).toList();
  }

  Future<void> markAsRead(String notificationId) async {
    final box = Hive.box<AppNotification>(notificationsBoxName);
    final notification = box.get(notificationId);
    if (notification != null && !notification.isRead) {
      final updated = AppNotification(
        id: notification.id,
        type: notification.type,
        title: notification.title,
        body: notification.body,
        imageUrl: notification.imageUrl,
        actionRoute: notification.actionRoute,
        actionArg: notification.actionArg,
        isRead: true,
        createdAt: notification.createdAt,
      );
      await box.put(notificationId, updated);
    }
  }

  Future<void> markAllAsRead() async {
    final box = Hive.box<AppNotification>(notificationsBoxName);
    for (var notification in box.values) {
      if (!notification.isRead) {
        final updated = AppNotification(
          id: notification.id,
          type: notification.type,
          title: notification.title,
          body: notification.body,
          imageUrl: notification.imageUrl,
          actionRoute: notification.actionRoute,
          actionArg: notification.actionArg,
          isRead: true,
          createdAt: notification.createdAt,
        );
        await box.put(notification.id, updated);
      }
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final box = Hive.box<AppNotification>(notificationsBoxName);
    await box.delete(notificationId);
  }

  int getUnreadCount() {
    final box = Hive.box<AppNotification>(notificationsBoxName);
    return box.values.where((n) => !n.isRead).length;
  }
}
