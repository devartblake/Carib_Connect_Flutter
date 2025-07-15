import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:carib_connect/components/fluid_nav_bar/fluid_nav_bar.dart';
import 'package:carib_connect/components/fluid_nav_bar/fluid_nav_bar_icon.dart';
import 'package:carib_connect/components/fluid_nav_bar/fluid_nav_bar_style.dart';
import '../../core/navigation/app_drawer.dart';

class MainLayout extends StatefulWidget {
  final Widget navigationShellBody;

  const MainLayout({super.key, required this.navigationShellBody});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // No need for _selectedIndex here if FluidNavBar handles its own internal state
  // and we rely on _calculateSelectedIndex to pass the correct defaultIndex.

  // Helper method to determine the selected index based on the current route
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/feed')) {
      return 1;
    }
    if (location.startsWith('/notifications')) {
      return 2;
    }
    // Add more cases for your routes corresponding to FluidNavBar items
    if (location.startsWith('/profile')) { // Example
      return 3;
    }
    return 0; // Default index
  }

  // This function will be passed to FluidNavBar's onChange callback
  void _onFluidNavBarChange(int selectedIndex, BuildContext context) {
    switch (selectedIndex) {
      case 0:
        GoRouter.of(context).go('/home');
        break;
      case 1:
        GoRouter.of(context).go('/feed');
        break;
      case 2:
        GoRouter.of(context).go('/notifications');
        break;
    // Add more cases as per your FluidNavBar items and routes
      case 3:
        GoRouter.of(context).go('/profile'); // Example
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the current index based on the route for FluidNavBar's defaultIndex
    final int currentRouteIndex = _calculateSelectedIndex(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carib Connect'),
        // ... other AppBar properties
      ),
      drawer: const AppDrawer(), // If you have a Drawer
      body: widget.navigationShellBody,
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(
            // Use icon parameter for IconData or svgPath for SVG assets
            icon: Icons.home_outlined, // Example with IconData
            selectedForegroundColor: Theme.of(context).colorScheme.primary,
            unselectedForegroundColor: Colors.grey,
            // backgroundColor: Colors.transparent, // Or your item bg color
            tooltip: 'Home',
          ),
          FluidNavBarIcon(
            icon: Icons.article_outlined, // Example with IconData
            selectedForegroundColor: Theme.of(context).colorScheme.primary,
            unselectedForegroundColor: Colors.grey,
            tooltip: 'Feed',
          ),
          FluidNavBarIcon(
            icon: Icons.notifications_none_outlined, // Example with IconData
            selectedForegroundColor: Theme.of(context).colorScheme.primary,
            unselectedForegroundColor: Colors.grey,
            tooltip: 'Alerts',
          ),
          // Add more FluidNavBarIcon instances as needed
          FluidNavBarIcon(
            icon: Icons.person_2_outlined,
            // svgPath: "assets/icons/profile.svg", // Example with SVG
            selectedForegroundColor: Theme.of(context).colorScheme.primary,
            unselectedForegroundColor: Colors.grey,
            tooltip: 'Profile',
          ),
        ],
        onChange: (selectedIndex) => _onFluidNavBarChange(selectedIndex, context),
        defaultIndex: currentRouteIndex, // Set the defaultIndex based on the current route
        animationFactor: 1.0,
        scaleFactor: 1.2,
        style: FluidNavBarStyle( // Optional: Customize your style
          barBackgroundColor: Theme.of(context).bottomAppBarTheme.color ?? Theme.of(context).colorScheme.surface,
          iconSelectedForegroundColor: Theme.of(context).colorScheme.primary,
          iconUnselectedForegroundColor: Colors.grey[600],
          iconBackgroundColor: Colors.grey[200], // Example
          borderRadius: 12.0,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        // itemBuilder: (icon, item) { // Optional custom item builder
        //   return item;
        // },
      ),
    );
  }
}
