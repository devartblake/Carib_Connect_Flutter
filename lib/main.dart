// main.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // For BlocProvider
import 'package:provider/provider.dart';       // For ThemeNotifier if still used at this level
import 'package:go_router/go_router.dart';     // For GoRouter
import 'package:carib_connect/core/env.dart'; // Your Env class'

// Core Services & Theme
import 'package:carib_connect/core/services/theme_notifier.dart'; // Your ThemeNotifier
import 'package:carib_connect/core/theme/app_theme.dart';       // Your AppTheme

// Navigation & Main Layout
import 'package:carib_connect/presentation/common_widgets/main_layout.dart'; // Your MainLayout

// Feature BLoCs (Import all BLoCs needed by your routes)
import 'package:carib_connect/presentation/features/home/bloc/home_bloc.dart';
import 'package:carib_connect/presentation/features/feed/bloc/feed_bloc.dart';
import 'package:carib_connect/presentation/features/notifications/bloc/notifications_bloc.dart';
import 'package:carib_connect/presentation/features/profile/bloc/profile_bloc.dart';
import 'package:carib_connect/presentation/features/about/bloc/about_bloc.dart'; // If About uses a BLoC
import 'package:carib_connect/core/services/secure_storage_service.dart';
import 'package:carib_connect/data/data_sources/local/auth_local_data_source.dart';
import 'package:carib_connect/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:carib_connect/data/repositories/auth_repository_impl.dart';
import 'package:carib_connect/domain/repositories/auth_repository.dart';
import 'package:carib_connect/presentation/features/auth/bloc/auth_bloc.dart';
import 'package:http/http.dart' as http;

// Feature Screens (Import all Screens)
import 'package:carib_connect/presentation/features/home/screens/home_screen.dart';
import 'package:carib_connect/presentation/features/feed/screens/feed_screen.dart';
import 'package:carib_connect/presentation/features/notifications/screens/notifications_screen.dart';
import 'package:carib_connect/presentation/features/profile/screens/profile_screen.dart';
import 'package:carib_connect/presentation/features/about/screens/about_screen.dart';
import 'package:carib_connect/presentation/screens/settings_screen.dart';
import 'package:carib_connect/presentation/features/auth/screens/login_screen.dart';

// --- Router Configuration ---
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

// We will initialize _router inside main() or where AuthBloc is available
late GoRouter _router;

// A listenable that notifies when the auth state changes
class AuthStateListenable extends ValueNotifier<AuthState> {
  late final StreamSubscription<AuthState> _subscription;

  AuthStateListenable(AuthBloc authBloc) : super(authBloc.state) {
    _subscription = authBloc.stream.listen((state) {
      value = state;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // flutter_native_splash will be shown until Flutter is initialized.
  // No need to call removeAfter from here if we handle initial screen logic properly.

  // Load environment variables FIRST
  await Env.load();

  await AppTheme.initialize();
  final themeNotifier = ThemeNotifier()..syncTheme();

  final SecureStorageService secureStorageService = SecureStorageService();
  final AuthLocalDataSource authLocalDataSource = AuthLocalDataSourceImpl(secureStorageService: secureStorageService);
  final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSourceImpl(client: http.Client());
  final AuthRepository authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
  );

  // Initialize AuthBloc and add the initial event to check auth status
  final authBloc = AuthBloc(authRepository: authRepository)..add(CheckAuthenticationStatus());

  // Create the listenable for GoRouter's refreshListenable
  final authStateListenable = AuthStateListenable(authBloc);

  _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    // initialLocation will be handled by the redirect logic based on auth state
    debugLogDiagnostics: true,
    refreshListenable: authStateListenable, // Important for reacting to auth changes
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return MainLayout(navigationShellBody: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (BuildContext context, GoRouterState state) {
              return BlocProvider(
                create: (context) => HomeBloc()..add(LoadHomeData()),
                child: const HomeScreen(),
              );
            },
          ),
          GoRoute(path: '/feed', name: 'feed', /* ... */ builder: (_, __) => BlocProvider(create: (_) => FeedBloc()..add(LoadFeedItems()), child: const FeedScreen())),
          GoRoute(path: '/notifications', name: 'notifications', /* ... */ builder: (_, __) => BlocProvider(create: (_) => NotificationsBloc()..add(LoadNotifications()), child: const NotificationsScreen())),
          GoRoute(path: '/profile', name: 'profile', /* ... */ builder: (_, __) => BlocProvider(create: (_) => ProfileBloc()..add(LoadUserProfile()), child: const ProfileScreen())),
          GoRoute(path: '/settings', name: 'settings', /* ... */ builder: (_, __) => const SettingsScreen()),
          GoRoute(path: '/about', name: 'about', /* ... */ builder: (_, __) => BlocProvider(create: (_) => AboutBloc()..add(LoadAppInfo()), child: const AboutScreen())),
        ],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          // No need to provide AuthBloc here again if it's already provided globally
          return const LoginScreen();
        },
      ),
      // Optional: A dedicated splash/loading screen if you need more complex async init
      // GoRoute(
      //   path: '/loading',
      //   name: 'loading',
      //   builder: (context, state) => const Scaffold(body: Center(child: CircularProgressIndicator())),
      // ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state; // Get current auth state

      // While AuthBloc is checking (AuthInitial or AuthLoading)
      // you might want to show a loading screen or let the native splash persist.
      // If flutter_native_splash is good enough, no explicit loading route is needed here.
      if (authState is AuthInitial || (authState is AuthLoading && state.matchedLocation != '/loading')) {
        // If you have a specific /loading route, you can redirect there.
        // Otherwise, returning null keeps the user on the current route (or native splash initially).
        // Consider if you want a Dart loading screen or rely on native splash + initial check.
        // For a seamless experience with native splash, returning null while loading is fine
        // as long as the initial check is quick.
        // If CheckAuthenticationStatus takes time, redirect to a '/loading' route.
        // return state.matchedLocation == '/loading' ? null : '/loading';
        return null; // Let native splash show or stay on current route
      }

      final isAuthenticated = authState is AuthAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoggingIn) {
        return '/login'; // If not authenticated and not on login, go to login
      }
      if (isAuthenticated && isLoggingIn) {
        return '/home'; // If authenticated and on login (e.g., after successful login), go to home
      }

      return null; // No redirect needed
    },
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text('Error: ${state.error?.message ?? 'Route not found'}\nPath: ${state.uri}'),
      ),
    ),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        // Provide AuthBloc globally so it's accessible by GoRouter's redirect
        // and by the LoginScreen or other widgets that might need it.
        BlocProvider<AuthBloc>.value(value: authBloc),
      ],
      child: ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => themeNotifier,
        child: MyApp(authBloc: authBloc), // Pass authBloc if MyApp needs it directly, otherwise it can get from context
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc; // Keep if MyApp directly uses it, else remove

  const MyApp({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeNotifier>(context).currentThemeData;

    // Use a BlocBuilder or BlocListener here if MyApp needs to react to AuthState
    // for things other than routing (which GoRouter handles).
    // For now, GoRouter handles the initial screen decision.

    return MaterialApp.router(
      title: 'Carib Connect',
      theme: themeData,
      routerConfig: _router, // Use the routerConfig
      debugShowCheckedModeBanner: false,
    );
  }
}

// Optional: A simple BLoC observer for debugging
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    debugPrint('onChange(${bloc.runtimeType}, $change)');
  }
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}