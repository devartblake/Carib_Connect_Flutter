import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 600)); // Simulate fetch
      // Replace with actual data fetching logic
      emit(ProfileLoaded(
        userName: "Current User Name",
        userEmail: "user@example.com",
        profileImageUrl: "https://via.placeholder.com/150", // Placeholder
      ));
    } catch (e) {
      emit(ProfileError(
          errorMessage: "Failed to load profile: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading()); // Or a specific ProfileUpdating state
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate update
      // Replace with actual update logic
      print("Updating profile: Name - ${event.newName}, Email - ${event.newEmail}");
      emit(ProfileUpdateSuccess());
      // Then reload the profile to show updated data
      add(LoadUserProfile());
    } catch (e) {
      emit(ProfileError(
          errorMessage: "Failed to update profile: ${e.toString()}"));
      // Optionally, re-emit previous ProfileLoaded state if available
    }
  }
}