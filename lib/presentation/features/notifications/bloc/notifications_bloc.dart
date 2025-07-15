import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
  }

  Future<void> _onLoadNotifications(
      LoadNotifications event, Emitter<NotificationsState> emit) async {
    emit(NotificationsLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 700)); // Simulate fetch
      // Replace with actual data fetching logic
      emit(NotificationsLoaded(
          userNotifications: List.generate(
              5, (index) => "You have a new notification #${index + 1}")));
    } catch (e) {
      emit(NotificationsError(
          errorMessage: "Failed to load notifications: ${e.toString()}"));
    }
  }
}