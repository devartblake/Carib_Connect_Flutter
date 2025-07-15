part of 'notifications_bloc.dart';

@immutable
abstract class NotificationsEvent {}

class LoadNotifications extends NotificationsEvent {}

class MarkNotificationAsRead extends NotificationsEvent {
  final String notificationId;
  MarkNotificationAsRead({required this.notificationId});
}

class ClearAllNotifications extends NotificationsEvent {}