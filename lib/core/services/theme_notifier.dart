import 'package:flutter/material.dart';
import 'package:carib_connect/core/theme/app_theme.dart'; // Assuming this is the correct path
import 'package:geolocator/geolocator.dart'; // Keep if location-based theming is still desired

class ThemeNotifier with ChangeNotifier {
  // No longer need _themeKey as AppTheme handles persistence

  // The ThemeNotifier now just holds a reference to the ThemeData
  // and gets the current ThemeType from AppTheme directly.
  ThemeData _currentThemeData = AppTheme.currentThemeData;
  ThemeData get currentThemeData => _currentThemeData;

  // Getter to expose the current AppTheme instance for UI (e.g., in SettingsScreen)
  AppTheme get currentAppTheme => AppTheme.current;
  ThemeType get currentThemeType => AppTheme.currentThemeType; // For SettingsScreen's groupValue

  /// Updates the current theme by calling AppTheme.setTheme
  /// and notifies listeners.
  Future<void> setThemeType(ThemeType themeType) async {
    // AppTheme.setTheme now handles persistence and returns the new ThemeData
    final newThemeData = await AppTheme.setTheme(themeType);
    _currentThemeData = newThemeData;
    notifyListeners(); // Notify listeners that the theme data has changed
  }

  /// Toggles dark mode using AppTheme and notifies listeners.
  Future<void> toggleDarkMode() async {
    final newThemeData = await AppTheme.toggleDarkMode();
    _currentThemeData = newThemeData;
    notifyListeners();
  }

  /// Load theme. This is now simplified as AppTheme.initialize() handles it.
  /// This method might not be explicitly needed if AppTheme.initialize
  /// is called correctly in main.dart and ThemeNotifier is initialized afterwards.
  /// However, it can be used to ensure the notifier is synchronized after AppTheme is ready.
  void syncTheme() {
    _currentThemeData = AppTheme.currentThemeData;
    // No need to notifyListeners() here if this is called during initialization
    // before the UI is built. If called later, then notify.
  }


  /// Update theme based on location - This can still exist if you want this functionality.
  /// It will now call the updated `setThemeType` which uses AppTheme.
  Future<void> updateThemeBasedOnLocation(Position position) async {
    try {
      debugPrint(
          "Received location: lat=${position.latitude}, long=${position.longitude}");
      ThemeType themeType;

      // Refined mapping of coordinates to themes
      if (position.latitude >= 17.7 &&
          position.latitude <= 18.5 &&
          position.longitude >= -78.4 &&
          position.longitude <= -76.2) {
        themeType = ThemeType.jamaica;
      } else if (position.latitude >= 10.3 &&
          position.latitude <= 10.85 &&
          position.longitude >= -61.6 &&
          position.longitude <= -60.9) {
        themeType = ThemeType.trinidad;
      } else if (position.latitude >= 23.7 &&
          position.latitude <= 26.7 &&
          position.longitude >= -78.5 &&
          position.longitude <= -74.5) {
        themeType = ThemeType.bahamas;
      } else {
        themeType = AppTheme.currentThemeType; // Or ThemeType.main
      }

      debugPrint("Setting theme based on location: $themeType");
      // Only set if different to avoid unnecessary updates
      if (themeType != AppTheme.currentThemeType) {
        await setThemeType(themeType);
      }
    } catch (e) {
      debugPrint("Error updating theme based on location: $e");
      // Fallback or maintain current theme
      // await setThemeType(AppTheme.currentThemeType); // Or ThemeType.main
    }
  }
}