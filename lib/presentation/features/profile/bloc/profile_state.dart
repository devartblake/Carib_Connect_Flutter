part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  // final UserProfileModel userProfile; // Replace with your model
  final String userName;
  final String userEmail;
  final String profileImageUrl;

  ProfileLoaded({
    // required this.userProfile,
    required this.userName,
    required this.userEmail,
    required this.profileImageUrl,
  });
}

class ProfileError extends ProfileState {
  final String errorMessage;
  ProfileError({required this.errorMessage});
}

class ProfileUpdateSuccess extends ProfileState {} // After a successful update