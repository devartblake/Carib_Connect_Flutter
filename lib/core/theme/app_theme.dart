// core/theme/app_theme.dart
import 'package:carib_connect/core/theme/theme_type_adapter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Assuming ColorUtils is still relevant and in the correct path
// If not used in this file directly, you can remove it.
// import 'package:carib_connect/_internal/utils/color_utils.dart';

// Key for storing the theme type in Hive
const String kThemePersistenceKey = 'app_theme_type';

// Part directive for Hive generator (if you generate adapters for other classes in this file)
// part 'app_theme.g.dart'; // Only if you have @HiveType classes here

// Keep ThemeType enum here or move to a separate file if it grows
enum ThemeType {
  main,
  jamaica,
  trinidad,
  bahamas,
}

class AppTheme {
  // --- Hive Box Reference ---
  static Box<dynamic>? _themeBox;

  // --- Static Properties for Current Theme ---
  static ThemeType _currentThemeType = ThemeType.main; // Default
  static AppTheme _currentAppTheme = AppTheme.fromType(ThemeType.main);

  // --- Public Accessors for Current Theme ---
  static ThemeType get currentThemeType => _currentThemeType;
  static AppTheme get current => _currentAppTheme;
  static ThemeData get currentThemeData => _currentAppTheme.themeData;

  // --- Instance Properties (unchanged from your code) ---
  final ThemeType type;
  bool isDark; // Consider if this should be part of ThemeType or a separate setting
  Color bg1;
  Color bg2;
  Color surface;
  Color accent1;
  Color accent1Dark;
  Color accent1Darker;
  Color accent2;
  Color grey;
  Color greyStrong;
  Color greyWeak;
  Color error;
  Color focus;
  Color txt;
  Color accentTxt;

  /// Default constructor
  AppTheme({
    required this.type,
    this.isDark = false, // Default isDark to false
    required this.bg1,
    required this.bg2,
    required this.surface,
    required this.accent1,
    required this.accent1Dark,
    required this.accent1Darker,
    required this.accent2,
    required this.grey,
    required this.greyStrong,
    required this.greyWeak,
    required this.error,
    required this.focus,
    required this.txt,
    required this.accentTxt,
  });

  /// Factory constructor to create themes
  factory AppTheme.fromType(ThemeType type, {bool isDarkOverride = false}) {
    // Basic dark mode color adjustments (can be more sophisticated)
    // For a more robust solution, each ThemeType might need its own dark variant definition
    bool effectiveIsDark = isDarkOverride; // Or a global dark mode setting

    switch (type) {
    case ThemeType.jamaica:
      return AppTheme(
        type: type,
        isDark: effectiveIsDark,
        bg1: effectiveIsDark ? Colors.grey[850]! : Colors.white,
        bg2: effectiveIsDark ? Colors.green[900]! : Colors.green[100]!,
        surface: effectiveIsDark ? Colors.grey[800]! : Colors.yellow[50]!,
        accent1: Colors.green[effectiveIsDark ? 400 : 700]!,
        accent1Dark: Colors.green[effectiveIsDark ? 500 : 800]!,
        accent1Darker: Colors.green[effectiveIsDark ? 600 : 900]!,
        accent2: Colors.yellow[effectiveIsDark ? 400 : 700]!,
        grey: Colors.grey[effectiveIsDark ? 400 : 600]!,
        greyStrong: Colors.grey[effectiveIsDark ? 200 : 900]!,
        greyWeak: Colors.grey[effectiveIsDark ? 700 : 300]!,
        error: Colors.red[effectiveIsDark ? 300 : 700]!,
        focus: Colors.green[effectiveIsDark ? 300 : 500]!,
        txt: effectiveIsDark ? Colors.white70 : Colors.black,
        accentTxt: effectiveIsDark ? Colors.black : Colors.white,
    );
    case ThemeType.trinidad:
      return AppTheme(
        type: type,
        isDark: effectiveIsDark,
        bg1: effectiveIsDark ? Colors.grey[850]! : Colors.white,
        bg2: effectiveIsDark ? Colors.red[900]! : Colors.red[50]!,
        surface: effectiveIsDark ? Colors.grey[800]! : Colors.white,
        accent1: Colors.red[effectiveIsDark ? 400 : 800]!,
        accent1Dark: Colors.red[effectiveIsDark ? 500 : 900]!,
        accent1Darker: Colors.red[effectiveIsDark ? 600 : 900]!, // Often same as Dark
        accent2: effectiveIsDark ? Colors.grey[700]! : Colors.white, // Dark mode needs a visible accent2
        grey: Colors.grey[effectiveIsDark ? 400 : 600]!,
        greyStrong: Colors.grey[effectiveIsDark ? 200 : 900]!,
        greyWeak: Colors.grey[effectiveIsDark ? 700 : 300]!,
        error: Colors.red[effectiveIsDark ? 300 : 700]!,
        focus: Colors.red[effectiveIsDark ? 300 : 500]!,
        txt: effectiveIsDark ? Colors.white70 : Colors.black,
        accentTxt: effectiveIsDark ? Colors.black : Colors.white,
    );
      case ThemeType.bahamas:
        return AppTheme(
          type: type,
          isDark: effectiveIsDark,
          bg1: effectiveIsDark ? Colors.grey[700]! : Colors.white,
          bg2: effectiveIsDark ? Colors.blue[900]! : Colors.lightBlue[50]!,
          surface: effectiveIsDark ? const Color(0xFF121212) : Colors.white,
          accent1: effectiveIsDark ? Colors.grey[800]! : const Color.fromRGBO(5, 195, 221, 1),
          accent1Dark: effectiveIsDark ? Colors.blue[500]! : const Color(0xFF1E90FF),
          accent1Darker: Colors.blue[effectiveIsDark ? 600 : 900]!,
          accent2: effectiveIsDark ? Colors.yellow[600]! : Colors.black, // Ensure visibility in dark
          grey: Colors.grey[effectiveIsDark ? 400 : 600]!,
          greyStrong: Colors.grey[effectiveIsDark ? 200 : 900]!,
          greyWeak: Colors.grey[effectiveIsDark ? 700 : 300]!,
          error: Colors.red[effectiveIsDark ? 300 : 700]!,
          focus: Colors.blue[effectiveIsDark ? 300 : 500]!,
          txt: effectiveIsDark ? Colors.white70 : Colors.black,
          accentTxt: effectiveIsDark ? Colors.black : Colors.white,
        );
      case ThemeType.main:
      // Fallback to main theme
        return AppTheme(
          type: type, // Should be ThemeType.main here
          isDark: effectiveIsDark,
          bg1: effectiveIsDark ? Colors.grey[800]! : Color(0xFFEEF0F1),
          bg2: effectiveIsDark ? Color(0xFF2A2A2A) : Color(0xFFC1DCBC),
          surface: effectiveIsDark ? const Color(0xFF121212) : Colors.white,
          accent1: effectiveIsDark ? Colors.lightBlue[300]! : const Color(0xFF1E90FF), // Blue
          accent1Dark: effectiveIsDark ? Colors.lightBlue[400]! : const Color(0xFF1C86EE),
          accent1Darker: effectiveIsDark ? Colors.lightBlue[500]! : const Color(0xFF1874CD),
          accent2: effectiveIsDark ? Colors.tealAccent[300]! : const Color(0xFF40E0D0), // Turquoise
          grey: Colors.grey[effectiveIsDark ? 400 : 600]!,
          greyStrong: Colors.grey[effectiveIsDark ? 200 : 900]!,
          greyWeak: Colors.grey[effectiveIsDark ? 700 : 300]!,
          error: effectiveIsDark ? Colors.redAccent[100]! : Colors.red.shade900,
          focus: effectiveIsDark ? Colors.amberAccent[700]! : Colors.yellow.shade700, // Yellow
          txt: effectiveIsDark ? Colors.white60 : Colors.black,
          accentTxt: effectiveIsDark ? Colors.black : Colors.white,
        );
    }
  }

  /// Generates ThemeData for the app
  ThemeData get themeData {
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();
    return baseTheme.copyWith(
      // --- Use ColorScheme for most color definitions ---
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: accent1,
        onPrimary: accentTxt, // Text/icon color on primary color
        primaryContainer: accent1Darker, // Often a darker/lighter shade of primary
        onPrimaryContainer: accentTxt, // Text/icon color on primaryContainer
        secondary: accent2,
        onSecondary: accentTxt, // Text/icon color on secondary color
        secondaryContainer: accent1Dark, // Often a darker/lighter shade of secondary
        onSecondaryContainer: accentTxt, // Text/icon color on secondaryContainer
        surface: surface, // Background for cards, dialogs, sheets
        onSurface: txt, // Text/icon color on background color
        error: error,
        onError: accentTxt, // Text/icon color on error color
      ),
      // --- Component Themes ---
      scaffoldBackgroundColor: bg1,
      appBarTheme: AppBarTheme(
        backgroundColor: surface, // Or bg2, or accent1 based on design
        foregroundColor: txt, // Title and icon color
        elevation: isDark ? 1.0 : 2.0,
        iconTheme: IconThemeData(color: accent1),
        titleTextStyle: baseTheme.textTheme.titleLarge?.copyWith(color: txt),
      ),
      textTheme: baseTheme.textTheme.apply(
        bodyColor: txt,
        displayColor: txt,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bg2.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: greyWeak),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: greyWeak.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: focus, width: 2),
        ),
        labelStyle: TextStyle(color: txt.withOpacity(0.7)),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: accent1,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent1,
          foregroundColor: accentTxt,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: accent1,
          )
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent1,
          side: BorderSide(color: accent1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: isDark ? 2 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent2,
        foregroundColor: accentTxt,
      ),
      dividerColor: greyWeak,
      highlightColor: accent1.withOpacity(0.1), // For ink wells, etc.
      splashColor: accent1.withOpacity(0.2), // For ink wells, etc.
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: focus.withOpacity(0.3),
        cursorColor: focus,
        selectionHandleColor: focus,
      ),
      // Add other component themes as needed (TabBarTheme, BottomNavigationBarTheme, etc.)
    );
  }

  // --- Hive Integration Methods ---

  /// Initializes Hive, registers adapter, opens box, and loads the theme.
  /// Call this in your main.dart BEFORE runApp().
  static Future<void> initialize() async {
    await Hive.initFlutter(); // Initialize Hive for Flutter
    if (!Hive.isAdapterRegistered(ThemeTypeAdapter().typeId)) {
      Hive.registerAdapter(ThemeTypeAdapter());
    }
    _themeBox = await Hive.openBox('themeSettings'); // Open a box for theme settings

    // Load saved theme type or use default
    final dynamic savedThemeIndex = _themeBox!.get(kThemePersistenceKey);
    if (savedThemeIndex != null && savedThemeIndex is int && savedThemeIndex < ThemeType.values.length) {
      _currentThemeType = ThemeType.values[savedThemeIndex];
    } else {
      _currentThemeType = ThemeType.main; // Default if nothing saved or invalid
    }
    _currentAppTheme = AppTheme.fromType(_currentThemeType /*, potentially pass isDark here too */);
  }

  /// Changes the current theme and saves it to Hive.
  /// Returns the new ThemeData.
  /// You'll likely call this from a ThemeProvider/ChangeNotifier.
  static Future<ThemeData> setTheme(ThemeType newType, {bool? isDarkValue}) async {
    _currentThemeType = newType;
    // If you manage dark mode separately, update it here too
    // For now, `fromType` can take an `isDarkOverride`
    bool effectiveIsDark = isDarkValue ?? _currentAppTheme.isDark;

    _currentAppTheme = AppTheme.fromType(_currentThemeType, isDarkOverride: effectiveIsDark);

    await _themeBox?.put(kThemePersistenceKey, _currentThemeType.index);
    return _currentAppTheme.themeData;
  }

  /// Toggles dark mode and saves (if you decide to persist dark mode preference)
  /// This is a basic example; you might want to save the dark mode state separately.
  static Future<ThemeData> toggleDarkMode() async {
    bool newIsDarkState = !_currentAppTheme.isDark;
    _currentAppTheme = AppTheme.fromType(_currentThemeType, isDarkOverride: newIsDarkState);
    // Optional: Persist dark mode separately
    // await _themeBox?.put('isDarkMode', newIsDarkState);
    return _currentAppTheme.themeData;
  }


// Your shift method - ensure ColorUtils.shiftHsl exists and works as expected
// Color shift(Color c, double d) => ColorUtils.shiftHsl(c, d * (isDark? -1 : 1));
}

// LoginThemeHelper remains the same if still needed
class LoginThemeHelper {
  static TextStyle? loginTextStyle;
}