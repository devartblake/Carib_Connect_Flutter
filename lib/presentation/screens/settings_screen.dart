import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carib_connect/core/theme/app_theme.dart';
import 'package:carib_connect/core/services/theme_notifier.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // saveBackgroundIndex is not related to theme, keep if needed for other settings
  // Future<void> saveBackgroundIndex(int index) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('background_index', index);
  // }

  @override
  Widget build(BuildContext context) {
    // Use 'watch' if you want the SettingsScreen to rebuild when themeNotifier changes
    // (e.g., if another part of the app changes the theme).
    // Use 'read' if you only want to call methods on it and the RadioListTile
    // will manage its own visual state based on groupValue.
    // For this case, 'watch' is safer to ensure groupValue is always current.
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Theme Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Radio buttons for selecting theme type
          ...ThemeType.values.map((themeType) {
            return RadioListTile<ThemeType>(
              title: Text(themeType.name[0].toUpperCase() + themeType.name.substring(1)), // Capitalize name
              value: themeType,
              groupValue: themeNotifier.currentThemeType, // Use getter from notifier
              onChanged: (ThemeType? newTheme) {
                if (newTheme != null) {
                  // Call the method on ThemeNotifier
                  themeNotifier.setThemeType(newTheme);
                }
              },
            );
          }),
          const SizedBox(height: 10),
          // Switch for Dark Mode
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeNotifier.currentAppTheme.isDark, // Access isDark from currentAppTheme
              onChanged: (bool isDark) {
                themeNotifier.toggleDarkMode();
              },
            ),
          ),
          const Divider(),
          const Text(
            'More Settings (Coming Soon)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Language'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Placeholder
            },
          ),
          ListTile(
            title: const Text('Account'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Placeholder
            },
          ),
        ],
      ),
    );
  }
}