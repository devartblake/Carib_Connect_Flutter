import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

Size? getWidgetSize(GlobalKey key) {
  final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
  return renderBox?.size;
}

void showSuccessNotification(String title, String message, [Duration? duration]) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'success_channel',
      title: title,
      body: message,
      backgroundColor: Colors.green[600],
      color: Colors.white,
      notificationLayout: NotificationLayout.Default,
      icon: 'resource://drawable/res_success_icon', // Replace with your custom success icon if available
    ),
  );
}

void showErrorNotification(String title, String message) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'error_channel',
      title: title,
      body: message,
      backgroundColor: Colors.red[600],
      color: Colors.white,
      notificationLayout: NotificationLayout.Default,
      icon: 'resource://drawable/res_error_icon', // Replace with your custom error icon if available
    ),
  );
}

// Helper function to create unique IDs for notifications
int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}
