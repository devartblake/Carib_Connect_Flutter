part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

// Initial state, before any auth attempt or check
class AuthInitial extends AuthState {}

// State when authentication is in progress (e.g., network request)
class AuthLoading extends AuthState {
  final String? message; // Optional message like "Logging in..."
  AuthLoading({this.message});
}

// State when the user is successfully authenticated
class AuthAuthenticated extends AuthState {
  final UserModel user; // Replace with your actual User model
  final String token;
  final String userId;
  AuthAuthenticated({required this.token, required this.userId, required this.user});
}

// State when the user is not authenticated (e.g., after logout, or initial state if not logged in)
class AuthUnauthenticated extends AuthState {
  final String? message; // Optional message e.g. "Session expired"
  AuthUnauthenticated({this.message});
}

// State when an authentication attempt fails
class AuthError extends AuthState {
  final String errorMessage;
  AuthError({required this.errorMessage});
}

// State for password recovery (e.g., "Recovery email sent")
class AuthPasswordRecoverySuccess extends AuthState {
  final String message;
  AuthPasswordRecoverySuccess({required this.message});
}