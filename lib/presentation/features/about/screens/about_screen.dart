import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/about_bloc.dart'; // Import BLoC if used

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // If BLoC is used for AboutScreen:
    return BlocProvider(
      create: (context) => AboutBloc()..add(LoadAppInfo()),
      child: const _AboutScreenView(),
    );

    // If AboutScreen is static (no BLoC):
    // return const _AboutScreenStaticView();
  }
}

// --- View for BLoC-driven AboutScreen (if you need dynamic data) ---
class _AboutScreenView extends StatelessWidget {
  const _AboutScreenView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AboutBloc, AboutState>(
      builder: (context, state) {
        if (state is AboutLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AboutInfoLoaded) {
          return _buildAboutContent(
            context,
            appVersion: state.appVersion,
            developerInfo: state.developerInfo,
            contactEmail: state.contactEmail,
          );
        } else if (state is AboutError) {
          return Center(child: Text("Error: ${state.errorMessage}"));
        }
        if (state is AboutInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AboutBloc>().add(LoadAppInfo());
          });
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(child: Text("About Carib Connect"));
      },
    );
  }
}

// --- View for Static AboutScreen (no BLoC) ---
class _AboutScreenStaticView extends StatelessWidget {
  const _AboutScreenStaticView();

  @override
  Widget build(BuildContext context) {
    return _buildAboutContent(
      context,
      appVersion: "1.0.1 (Static)", // Hardcoded or from a const
      developerInfo: "Theoretical Minds Technologies",
      contactEmail: "contact@caribconnect.app",
    );
  }
}

// --- Shared content builder for About Screen ---
Widget _buildAboutContent(BuildContext context,
    {required String appVersion,
      required String developerInfo,
      required String contactEmail}) {
  return Scaffold( // Add Scaffold if not provided by ShellRoute's MainLayout for AppBar
    // appBar: AppBar(title: const Text("About Carib Connect")), // Only if not already in MainLayout
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: FlutterLogo(size: 80, style: FlutterLogoStyle.horizontal), // Or your app logo
          ),
          const SizedBox(height: 24),
          Text(
            'Carib Connect',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Version: $appVersion', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          Text(
            'Connecting the Caribbean and its Diaspora.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          const Text(
            'This application aims to bridge distances, foster community, and celebrate Caribbean culture worldwide. '
                'Connect with friends, family, and new acquaintances who share your heritage and interests.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 24),
          Text('Developed by: $developerInfo', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text('Contact: $contactEmail', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '© ${DateTime.now().year} Carib Connect. All rights reserved.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    ),
  );
}