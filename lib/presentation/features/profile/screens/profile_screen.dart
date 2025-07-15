import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileScreenView();
  }
}

class _ProfileScreenView extends StatefulWidget {
  const _ProfileScreenView();

  @override
  State<_ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<_ProfileScreenView> {
  @override
  void initState() {
    super.initState();
    // Ensure BLoC is provided in GoRouter for this screen
    // context.read<ProfileBloc>().add(LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully!")),
          );
        } else if (state is ProfileError && ModalRoute.of(context)?.isCurrent == true) {
          // Show error only if it's not during an update success transition
          if (context.read<ProfileBloc>().state is! ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.errorMessage}")),
            );
          }
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading && state is! ProfileLoaded) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(state.profileImageUrl),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 16),
                Text(state.userName, style: Theme.of(context).textTheme.headlineSmall),
                Text(state.userEmail, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit Profile'),
                  onPressed: () {
                    // Example: Show a dialog to edit (or navigate to an edit screen)
                    // For simplicity, directly dispatching update event with placeholder data
                    context.read<ProfileBloc>().add(UpdateUserProfile(
                      newName: "Updated User Name",
                      newEmail: "updated.user@example.com",
                    ));
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reload Profile'),
                  onPressed: () {
                    context.read<ProfileBloc>().add(LoadUserProfile());
                  },
                ),
                // Add more profile details and options here
              ],
            ),
          );
        } else if (state is ProfileError && state is! ProfileLoaded) { // Only show error if not loaded
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error loading profile: ${state.errorMessage}"),
                ElevatedButton(
                  onPressed: () => context.read<ProfileBloc>().add(LoadUserProfile()),
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }
        if (state is ProfileInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ProfileBloc>().add(LoadUserProfile());
          });
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(child: Text("Your Profile"));
      },
    );
  }
}