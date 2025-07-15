import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notifications_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _NotificationsScreenView();
  }
}

class _NotificationsScreenView extends StatefulWidget {
  const _NotificationsScreenView();

  @override
  State<_NotificationsScreenView> createState() => _NotificationsScreenViewState();
}

class _NotificationsScreenViewState extends State<_NotificationsScreenView> {
  @override
  void initState() {
    super.initState();
    // Ensure BLoC is provided in GoRouter for this screen
    // context.read<NotificationsBloc>().add(LoadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NotificationsLoaded) {
          if (state.userNotifications.isEmpty) {
            return const Center(child: Text("No new notifications."));
          }
          return ListView.builder(
            itemCount: state.userNotifications.length,
            itemBuilder: (context, index) {
              final notification = state.userNotifications[index];
              return ListTile(
                leading: Icon(Icons.notifications_active_outlined, color: Theme.of(context).colorScheme.primary),
                title: Text(notification),
                subtitle: Text("Details for notification $index..."),
                trailing: IconButton(
                  icon: const Icon(Icons.mark_chat_read_outlined),
                  onPressed: () {
                    // context.read<NotificationsBloc>().add(MarkNotificationAsRead(notificationId: 'id_$index'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Marked '$notification' as read!")),
                    );
                  },
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Tapped on '$notification'")),
                  );
                },
              );
            },
          );
        } else if (state is NotificationsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${state.errorMessage}"),
                ElevatedButton(
                  onPressed: () => context.read<NotificationsBloc>().add(LoadNotifications()),
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }
        if (state is NotificationsInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<NotificationsBloc>().add(LoadNotifications());
          });
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(child: Text("Your Notifications"));
      },
    );
  }
}