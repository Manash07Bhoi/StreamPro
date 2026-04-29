import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../blocs/notification_bloc.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationBloc>()..add(LoadNotifications()),
      child: const _NotificationsPageContent(),
    );
  }
}

class _NotificationsPageContent extends StatelessWidget {
  const _NotificationsPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text('Notifications', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500)),
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationBloc>().add(MarkAllNotificationsRead());
            },
            child: const Text('Mark All Read', style: TextStyle(color: Color(0xFFC026D3), fontFamily: 'Poppins')),
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading || state is NotificationInitial) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFC026D3)));
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.notifications_off_outlined, size: 80, color: Color(0xFF242424)),
                    const SizedBox(height: 16),
                    const Text('All Caught Up!', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('No new notifications right now.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF9CA3AF))),
                  ],
                ),
              );
            }

            return ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(color: Color.fromRGBO(255, 255, 255, 0.05), height: 1),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key(notification.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    context.read<NotificationBloc>().add(DeleteNotification(notification.id));
                  },
                  background: Container(
                    color: const Color(0xFFEF4444),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    tileColor: notification.isRead ? const Color(0xFF0A0A0A) : const Color(0xFF1A1A1A),
                    leading: _buildIconForType(notification.type),
                    title: Text(
                      notification.title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          notification.body,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF9CA3AF)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatTimeAgo(notification.createdAt),
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                    trailing: notification.isRead
                        ? null
                        : Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3B82F6), // Unread dot
                              shape: BoxShape.circle,
                            ),
                          ),
                    onTap: () {
                      if (!notification.isRead) {
                        context.read<NotificationBloc>().add(MarkNotificationRead(notification.id));
                      }
                      if (notification.actionRoute != null) {
                        if (notification.actionArg != null) {
                          // Note: complex object passing via go_router might need extra state management if going to /player
                          // For now this handles basic string routes
                        } else {
                           context.push(notification.actionRoute!);
                        }
                      }
                    },
                  ),
                );
              },
            );
          } else if (state is NotificationError) {
             return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildIconForType(String type) {
    IconData iconData;
    List<Color> gradientColors;

    switch (type) {
      case 'new_video':
        iconData = Icons.play_arrow;
        gradientColors = [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)];
        break;
      case 'trending':
        iconData = Icons.local_fire_department;
        gradientColors = [const Color(0xFFF59E0B), const Color(0xFFD97706)];
        break;
      case 'reminder':
        iconData = Icons.download;
        gradientColors = [const Color(0xFF10B981), const Color(0xFF059669)];
        break;
      case 'system':
      default:
        iconData = Icons.info;
        gradientColors = [const Color(0xFFC026D3), const Color(0xFFDB2777)];
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: gradientColors),
      ),
      child: Icon(iconData, color: Colors.white, size: 20),
    );
  }

  String _formatTimeAgo(String isoTime) {
    final date = DateTime.parse(isoTime);
    final difference = DateTime.now().difference(date);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, yyyy').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
