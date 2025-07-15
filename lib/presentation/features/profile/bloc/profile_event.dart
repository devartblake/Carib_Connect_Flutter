part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class LoadUserProfile extends ProfileEvent {}

class UpdateUserProfile extends ProfileEvent {
  // final UserProfileData newProfileData; // Replace with your model
  final String newName;
  final String newEmail;
  UpdateUserProfile({required this.newName, required this.newEmail});
}
