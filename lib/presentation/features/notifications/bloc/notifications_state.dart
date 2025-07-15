part of 'notifications_bloc.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  // final List<NotificationModel> notifications; // Replace with your model
  final List<String> userNotifications; // Example data

  NotificationsLoaded({
    // required this.notifications
    required this.userNotifications,
  });
}

class NotificationsError extends NotificationsState {
  final String errorMessage;
  NotificationsError({required this.errorMessage});
}