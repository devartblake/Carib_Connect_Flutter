import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/common_widgets/main_layout.dart';
import '../../presentation/features/about/bloc/about_bloc.dart';
import '../../presentation/features/about/screens/about_screen.dart';
import '../../presentation/features/auth/screens/login_screen.dart';
import '../../presentation/features/feed/bloc/feed_bloc.dart';
import '../../presentation/features/feed/screens/feed_screen.dart';
import '../../presentation/features/home/bloc/home_bloc.dart';
import '../../presentation/features/notifications/bloc/notifications_bloc.dart';
import '../../presentation/features/notifications/screens/notifications_screen.dart';
import '../../presentation/features/profile/bloc/profile_bloc.dart';
import '../../presentation/features/profile/screens/profile_screen.dart';
import '../../presentation/screens/settings_screen.dart';
import 'package:carib_connect/presentation/features/home/screens/home_screen.dart';


final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return MainLayout(navigationShellBody: child);
      },
      routes: <RouteBase>[
        // --- Routes accessible primarily via BottomNavigationBar ---
        GoRoute(
          path: '/home',
          name: 'home', // Optional: for named routing
          builder: (BuildContext context, GoRouterState state) {
            // Provide HomeBloc specifically for the HomeScreen route
            return BlocProvider(
              create: (context) => HomeBloc() // ..add(LoadHomeData()), // Optionally add initial event here
              // If your HomeBloc has dependencies:
              // create: (context) => HomeBloc(
              //   getHomeDataUseCase: RepositoryProvider.of<GetHomeDataUseCase>(context), // Example
              // )..add(LoadHomeData()),
              ,child: const HomeScreen(),
            );
          },
        ),
        GoRoute(
          path: '/feed',
          name: 'feed',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (context) => FeedBloc(), // ..add(LoadFeedItems()),
              child: const FeedScreen(),
            );
          },
        ),
        GoRoute(
          path: '/notifications',
          name: 'notifications',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (context) => NotificationsBloc(), // ..add(LoadNotifications()),
              child: const NotificationsScreen(),
            );
          },
        ),
        // --- Routes accessible primarily via Drawer (or other means) ---
        // These will still be displayed within the MainLayout shell
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (context) => ProfileBloc(), // ..add(LoadUserProfile()),
              child: const ProfileScreen(),
            );
          },
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            // This is your existing SettingsScreen
            return const SettingsScreen(); // Replace with your actual screen
          },
        ),
        GoRoute(
          path: '/about',
          name: 'about',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (context) => AboutBloc()..add(LoadAppInfo()),
              child: const AboutScreen(),
            );
          },
        ),
      ],
    ),
    // --- Other top-level routes that DON'T use the MainLayout shell ---
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen(); // Replace with your actual screen
      },
    ),
    // ... other non-shell routes
  ],

  // Optional: Error page
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page Not Found')),
    body: Center(child: Text('Error: ${state.error}')),
  ),
);