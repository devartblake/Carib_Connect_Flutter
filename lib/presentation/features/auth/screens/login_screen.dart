import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carib_connect/components/carib_login/carib_login.dart';
import '../bloc/auth_bloc.dart'; // Ensure this path is correct

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Define callbacks that will dispatch events to AuthBloc
  Future<String?> _onLogin(BuildContext context, LoginData data) {
    // Dispatch event to AuthBloc
    context.read<AuthBloc>().add(LoginSubmitted(loginData: data));
    // FlutterLogin expects a Future<String?>.
    // Returning null indicates to FlutterLogin that the submission was "accepted"
    // by the callback, and it should proceed with its internal animations.
    // Error handling and UI updates (like snack bars or loading) are managed by AuthBloc's state.
    return Future.value(null);
  }

  Future<String?> _onSignup(BuildContext context, SignupData data) {
    context.read<AuthBloc>().add(SignupSubmitted(signupData: data));
    return Future.value(null);
  }

  Future<String?> _onRecoverPassword(BuildContext context, String name) {
    context.read<AuthBloc>().add(RecoverPasswordSubmitted(name: name)); // Assuming event takes email
    return Future.value(null);
  }

  // Example for social login providers
  List<LoginProvider> _getLoginProviders(BuildContext context) {
    return [
      LoginProvider(
        icon: Icons.g_mobiledata, // Replace with actual Google icon
        label: 'Google',
        callback: () async {
          context.read<AuthBloc>().add(SocialLoginSubmitted(provider: 'Google'));
          return Future.value(null); // BLoC handles state
        },
      ),
      // LoginProvider(
      //   icon: FontAwesomeIcons.facebookF,
      //   label: 'Facebook',
      //   callback: () async {
      //     context.read<AuthBloc>().add(SocialLoginSubmitted(provider: 'Facebook'));
      //     return Future.value(null);
      //   },
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        // Listen for specific states to show SnackBars or other non-navigational feedback
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          } else if (state is AuthPasswordRecoverySuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.blue, // Or your theme's info color
                ),
              );
          }
          // No need to handle AuthAuthenticated for navigation here,
          // GoRouter's redirect logic will take care of it.
          // You could still show a "Welcome" SnackBar from here if desired,
          // but often it's better to show it on the screen you navigate *to*.
        },
        // BlocBuilder handles showing the loading overlay or the login form
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // Check if the current state indicates a loading operation relevant to the login screen
            final bool isLoading = state is AuthLoading &&
                (state.previousEvent is LoginSubmitted ||
                    state.previousEvent is SignupSubmitted ||
                    state.previousEvent is RecoverPasswordSubmitted ||
                    state.previousEvent is SocialLoginSubmitted);

            if (isLoading) {
              return Stack(
                children: [
                  _buildFlutterLoginWidget(context), // Keep form visible underneath
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            state.message ?? "Processing...",
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            // Otherwise, just show the FlutterLogin widget
            return _buildFlutterLoginWidget(context);
          },
        ),
      ),
    );
  }

  Widget _buildFlutterLoginWidget(BuildContext context) {
    return FlutterLogin(
      title: 'Carib Connect',
      logo: 'assets/images/logo/app_launcher_icon.png', // Ensure this asset exists
      onLogin: (data) => _onLogin(context, data),
      onSignup: (data) => _onSignup(context, data),
      onRecoverPassword: (name) => _onRecoverPassword(context, name),
      messages: LoginMessages(
        userHint: 'Email', // More specific if it's always email
        passwordHint: 'Password',
        confirmPasswordHint: 'Confirm Password',
        loginButton: 'LOG IN',
        signupButton: 'REGISTER',
        forgotPasswordButton: 'Forgot password?',
        recoverPasswordButton: 'SEND RESET LINK',
        goBackButton: 'BACK',
        recoverPasswordIntro: 'Enter your email to receive a password reset link.',
        // recoverPasswordDescription: 'An email will be sent with instructions.', // Often not needed if intro is clear
        // flushbarPosition: FlushbarPosition.TOP, // Example using a property of carib_login's LoginMessages
      ),
      loginProviders: _getLoginProviders(context),
      onSubmitAnimationCompleted: () {
        // This callback is from FlutterLogin after its internal animations complete.
        // AuthBloc state changes and GoRouter's redirect will handle navigation if login was successful.
        // No explicit navigation needed here.
      },
      // theme: LoginTheme(...), // Customize your LoginTheme
      // userType: LoginUserType.email,
      // userValidator: (value) { ... },
      // passwordValidator: (value) { ... },
    );
  }
}

extension on AuthLoading {
  get previousEvent => null;
}