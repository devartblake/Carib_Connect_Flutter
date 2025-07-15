part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

// Event when the user attempts to login using email/password
class LoginSubmitted extends AuthEvent {
  final LoginData loginData; // From your 'carib_login.dart' exports
  LoginSubmitted({required this.loginData});
}

// Event when the user attempts to sign up
class SignupSubmitted extends AuthEvent {
  final SignupData signupData; // From your 'carib_login.dart' exports
  SignupSubmitted({required this.signupData});
}

// Event when the user attempts to recover password
class RecoverPasswordSubmitted extends AuthEvent {
  final String name; // Or email, depending on what your widget provides
  RecoverPasswordSubmitted({required this.name});
}

// Event for social login providers (example with a generic provider type)
class SocialLoginSubmitted extends AuthEvent {
  final String provider; // e.g., "Google", "Facebook" - adapt as needed
  SocialLoginSubmitted({required this.provider});
}

// Event when authentication succeeds and we have a user
class AuthenticationSuccess extends AuthEvent {
  // final UserModel user; // Replace with your actual User model
  final String token; // Example: JWT token
  final String userId;
  AuthenticationSuccess({required this.token, required this.userId});
}

// Event when an authentication error occurs
class AuthenticationFailure extends AuthEvent {
  final String error;
  AuthenticationFailure({required this.error});
}

// Event to logout
class LogoutRequested extends AuthEvent {}

// Event to check initial authentication status (e.g., on app start)
class CheckAuthenticationStatus extends AuthEvent {}