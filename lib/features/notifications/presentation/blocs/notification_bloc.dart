import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/app_notification.dart';
import '../../data/repositories/notification_repository.dart';

// Events
abstract class NotificationEvent extends Equatable {}

class LoadNotifications extends NotificationEvent {
  @override
  List<Object> get props => [];
}

class MarkNotificationRead extends NotificationEvent {
  final String notificationId;
  MarkNotificationRead(this.notificationId);
  @override
  List<Object> get props => [notificationId];
}

class MarkAllNotificationsRead extends NotificationEvent {
  @override
  List<Object> get props => [];
}

class DeleteNotification extends NotificationEvent {
  final String notificationId;
  DeleteNotification(this.notificationId);
  @override
  List<Object> get props => [notificationId];
}

class AddNotification extends NotificationEvent {
  final AppNotification notification;
  AddNotification(this.notification);
  @override
  List<Object> get props => [notification];
}

// States
abstract class NotificationState extends Equatable {}

class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoading extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoaded extends NotificationState {
  final List<AppNotification> notifications;
  final int unreadCount;
  NotificationLoaded(this.notifications, this.unreadCount);
  @override
  List<Object> get props => [notifications, unreadCount];
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  NotificationBloc(this._repository) : super(NotificationInitial()) {
    on<LoadNotifications>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifications = _repository.getAllNotifications();
        final unreadCount = _repository.getUnreadCount();
        emit(NotificationLoaded(notifications, unreadCount));
      } catch (e) {
        emit(NotificationError('Failed to load notifications: $e'));
      }
    });

    on<MarkNotificationRead>((event, emit) async {
      try {
        await _repository.markAsRead(event.notificationId);
        final notifications = _repository.getAllNotifications();
        final unreadCount = _repository.getUnreadCount();
        emit(NotificationLoaded(notifications, unreadCount));
      } catch (e) {
        emit(NotificationError('Failed to mark notification as read: $e'));
      }
    });

    on<MarkAllNotificationsRead>((event, emit) async {
      try {
        await _repository.markAllAsRead();
        final notifications = _repository.getAllNotifications();
        final unreadCount = _repository.getUnreadCount();
        emit(NotificationLoaded(notifications, unreadCount));
      } catch (e) {
        emit(NotificationError('Failed to mark all notifications as read: $e'));
      }
    });

    on<DeleteNotification>((event, emit) async {
      try {
        await _repository.deleteNotification(event.notificationId);
        final notifications = _repository.getAllNotifications();
        final unreadCount = _repository.getUnreadCount();
        emit(NotificationLoaded(notifications, unreadCount));
      } catch (e) {
        emit(NotificationError('Failed to delete notification: $e'));
      }
    });

    on<AddNotification>((event, emit) async {
      try {
        await _repository.addNotification(event.notification);
        final notifications = _repository.getAllNotifications();
        final unreadCount = _repository.getUnreadCount();
        emit(NotificationLoaded(notifications, unreadCount));
      } catch (e) {
        emit(NotificationError('Failed to add notification: $e'));
      }
    });
  }
}
