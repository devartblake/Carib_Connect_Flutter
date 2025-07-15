import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/feed_bloc.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeedScreenView();
  }
}

class _FeedScreenView extends StatefulWidget {
  const _FeedScreenView();

  @override
  State<_FeedScreenView> createState() => _FeedScreenViewState();
}

class _FeedScreenViewState extends State<_FeedScreenView> {
  @override
  void initState() {
    super.initState();
    // Ensure BLoC is provided in GoRouter for this screen
    // context.read<FeedBloc>().add(LoadFeedItems());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        if (state is FeedLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FeedLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<FeedBloc>().add(RefreshFeedItems());
            },
            child: ListView.builder(
              itemCount: state.feedPosts.length,
              itemBuilder: (context, index) {
                final post = state.feedPosts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.article_outlined, color: Theme.of(context).colorScheme.secondary),
                    title: Text(post),
                    subtitle: Text("Some details about post $index..."),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("$post tapped!")),
                      );
                    },
                  ),
                );
              },
            ),
          );
        } else if (state is FeedError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${state.errorMessage}"),
                ElevatedButton(
                  onPressed: () => context.read<FeedBloc>().add(LoadFeedItems()),
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }
        if (state is FeedInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<FeedBloc>().add(LoadFeedItems());
          });
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(child: Text("Welcome to your Feed!"));
      },
    );
  }
}