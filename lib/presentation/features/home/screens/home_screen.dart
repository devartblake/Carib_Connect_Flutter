import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart'; // Adjust path if needed

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // If HomeBloc is not already provided higher up in the widget tree
    // (e.g., in your GoRouter route builder or main.dart),
    // you would provide it here or in the route builder.
    // For simplicity, assuming it's provided above or will be.
    // If not, wrap with BlocProvider:
    // return BlocProvider(
    //   create: (context) => HomeBloc()..add(LoadHomeData()),
    //   child: _HomeScreenView(),
    // );

    // If HomeBloc is already provided by GoRouter or a higher-level provider:
    return const _HomeScreenView();
  }
}

class _HomeScreenView extends StatefulWidget {
  const _HomeScreenView();

  @override
  State<_HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<_HomeScreenView> {
  @override
  void initState() {
    super.initState();
    // Dispatch initial event to load data if not handled by BlocProvider's create
    // Or if you want to load data every time the screen is initialized
    // Ensure HomeBloc is accessible here, typically via context.read<HomeBloc>()
    // if BlocProvider is set up correctly.
    // This is often done in BlocProvider's `create` or the GoRouter builder.
    // If LoadHomeData is not dispatched yet, do it here:
    // context.read<HomeBloc>().add(LoadHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading && state is! HomeLoaded) { // Show loader only if not already loaded
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(RefreshHomeData());
              // Optionally, wait for the state to change if needed
              // await context.read<HomeBloc>().stream.firstWhere((s) => s is HomeLoaded || s is HomeError);
            },
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  state.welcomeMessage,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Text(
                  "Today's Features:",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                ...state.featuredItems.map((item) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.star, color: Theme.of(context).colorScheme.secondary),
                    title: Text(item),
                    onTap: () {
                      // Handle item tap, perhaps navigate or show details
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("$item tapped!")),
                      );
                    },
                  ),
                )),
                // Add more UI elements based on your home screen design
              ],
            ),
          );
        } else if (state is HomeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${state.errorMessage}"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(LoadHomeData());
                  },
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }
        // Fallback for HomeInitial or other unhandled states
        // You might want to dispatch LoadHomeData here if it's HomeInitial
        // This ensures data loading starts if the BLoC is in its initial state when the widget builds.
        if (state is HomeInitial) {
          // Important: Dispatch event to load data if in initial state
          // This often happens if the BlocProvider is just created without immediately adding an event
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<HomeBloc>().add(LoadHomeData());
          });
          return const Center(child: CircularProgressIndicator()); // Show loading while initial event processes
        }
        return const Center(child: Text("Welcome! Initializing..."));
      },
    );
  }
}