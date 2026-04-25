import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/models/app_notification.dart';

class NotificationRepository {
  final Box<AppNotification> _box = Hive.box<AppNotification>('notifications_box');
  final _uuid = const Uuid();

  Future<void> seedNotificationsIfNeeded() async {
    if (_box.isNotEmpty) return;

    final notifications = [
      AppNotification(
        id: _uuid.v4(),
        type: 'system',
        title: 'Welcome to StreamPro!',
        body: 'Start exploring thousands of premium videos across every genre — completely free.',
        isRead: false,
        createdAt: DateTime.now().toIso8601String(),
      ),
      AppNotification(
        id: _uuid.v4(),
        type: 'trending',
        title: '🔥 Trending Now',
        body: 'Check out today\'s hottest videos in the Trending tab.',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      ),
      AppNotification(
        id: _uuid.v4(),
        type: 'new_video',
        title: 'New Content Added',
        body: 'We just added a bunch of new Action and Comedy videos.',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      ),
      AppNotification(
        id: _uuid.v4(),
        type: 'system',
        title: 'Personalize Your Feed',
        body: 'Don\'t forget to select your interests to get better recommendations.',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      ),
      AppNotification(
        id: _uuid.v4(),
        type: 'reminder',
        title: 'Watch Offline',
        body: 'Did you know you can download videos to watch later? Try it now.',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      ),
    ];

    for (var n in notifications) {
      await _box.put(n.id, n);
    }
  }
}
