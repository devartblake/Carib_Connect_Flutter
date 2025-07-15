import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
// Import your LoginData, SignupData etc. - they are exported from carib_login.dart
import 'package:carib_connect/components/carib_login/carib_login.dart';
import 'package:carib_connect/data/models/user_model.dart';
import 'package:carib_connect/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository; // Inject your auth repository

  AuthBloc({required AuthRepository authRepository})
   : _authRepository = authRepository,
  super(AuthInitial()) {
  on<CheckAuthenticationStatus>(_onCheckAuthenticationStatus);
  on<LoginSubmitted>(_onLoginSubmitted);
  on<SignupSubmitted>(_onSignupSubmitted);
  on<RecoverPasswordSubmitted>(_onRecoverPasswordSubmitted);
  on<SocialLoginSubmitted>(_onSocialLoginSubmitted);
  on<AuthenticationSuccess>(_onAuthenticationSuccess);
  on<AuthenticationFailure>(_onAuthenticationFailure);
  on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthenticationStatus(
    CheckAuthenticationStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading(message: "Checking session..."));
    await Future.delayed(const Duration(seconds: 1)); // Simulate check
    try {
      final String? token = await _authRepository.getToken(); // Or similar check
      if (token != null) {
        // Optionally fetch user details if needed
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(token: token, userId: user.id, user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated(message: "Could not verify session."));
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading(message: "Logging in..."));
    await Future.delayed(const Duration(seconds: 2));
    try {
      final user = await _authRepository.login(event.loginData);
      if (user != null) {
        emit(AuthAuthenticated(token: await _authRepository.getToken() ?? "", userId: user.id, user: user));
      } else {
        emit(AuthError(errorMessage: "Invalid credentials."));
      }
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  Future<void> _onSignupSubmitted(
  SignupSubmitted event, Emitter<AuthState> emit) async {
  emit(AuthLoading(message: "Signing up..."));
  // Simulate API call
  await Future.delayed(const Duration(seconds: 2));
  try {
  // Add your actual signup logic here
  // String? error = await authRepository.signup(event.signupData);
  // If successful:
  print("Signup attempt with: ${event.signupData.name}, ${event.signupData.password}");
  // For flutter_login, onSignup typically returns null on success or an error string.
  // The BLoC can react to this. If your FlutterLogin's onSignup is this BLoC's method,
  // then the success/error handling might be slightly different.
  // Assuming direct call to BLoC event for now:
  if (event.signupData.name != null && event.signupData.password != null) {
  // For now, directly go to authenticated. In a real app, you might need email verification.
  add(AuthenticationSuccess(token: "fake_signup_token", userId: event.signupData.name!));
  } else {
  add(AuthenticationFailure(error: "Signup failed. Please check your details."));
  }
  } catch (e) {
  add(AuthenticationFailure(error: e.toString()));
  }
  }

  Future<void> _onRecoverPasswordSubmitted(
  RecoverPasswordSubmitted event, Emitter<AuthState> emit) async {
  emit(AuthLoading(message: "Sending recovery email..."));
  await Future.delayed(const Duration(seconds: 2));
  try {
  // Add your actual password recovery logic here
  // String? error = await authRepository.recoverPassword(event.name);
  // If successful:
  print("Password recovery attempt for: ${event.name}");
  emit(AuthPasswordRecoverySuccess(message: "Password recovery instructions sent to ${event.name}"));
  } catch (e) {
  emit(AuthError(errorMessage: "Password recovery failed: ${e.toString()}"));
  }
  }

  Future<void> _onSocialLoginSubmitted(
  SocialLoginSubmitted event, Emitter<AuthState> emit) async {
  emit(AuthLoading(message: "Connecting with ${event.provider}..."));
  await Future.delayed(const Duration(seconds: 2));
  try {
  // Add your actual social login logic here using the event.provider
  // String? error = await authRepository.socialLogin(event.provider);
  // If successful:
  print("Social login attempt with: ${event.provider}");
  add(AuthenticationSuccess(token: "fake_social_token", userId: "social_${event.provider}_user"));
  } catch (e) {
  add(AuthenticationFailure(error: "Social login failed: ${e.toString()}"));
  }
  }

  void _onAuthenticationSuccess(AuthenticationSuccess event, Emitter<AuthState> emit) {
  // await _authRepository.saveToken(event.token); // Save token
  // emit(AuthAuthenticated(token: event.token, userId: event.userId));
  }

  void _onAuthenticationFailure(AuthenticationFailure event, Emitter<AuthState> emit) {
  emit(AuthError(errorMessage: event.error));
  }

  Future<void> _onLogoutRequested(
  LogoutRequested event, Emitter<AuthState> emit) async {
  emit(AuthLoading(message: "Logging out..."));
  await Future.delayed(const Duration(milliseconds: 500));
  // await _authRepository.deleteToken(); // Clear token
  emit(AuthUnauthenticated());
  }
}