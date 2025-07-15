import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  // Supabase Variables
  static String? _supabaseUrl;
  static String? _supabaseAnonKey;

  // Getter for Supabase URL
  static String get supabaseUrl {
    assert(_supabaseUrl != null, 'SUPABASE_URL is not loaded from .env');
    return _supabaseUrl!;
  }

  // Getter for Supabase Anon Key
  static String get supabaseAnonKey {
    assert(_supabaseAnonKey != null, 'SUPABASE_ANON_KEY is not loaded from .env');
    return _supabaseAnonKey!;
  }

  // General initialization method
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: ".env");
      _supabaseUrl = dotenv.env['SUPABASE_URL'];
      _supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (_supabaseUrl == null || _supabaseAnonKey == null) {
        print('--------------------------------------------------------------------');
        print('ERROR: SUPABASE_URL or SUPABASE_ANON_KEY not found in .env file.');
        print('Please ensure your .env file is in the root of your project and contains these values.');
        print('SUPABASE_URL: $_supabaseUrl');
        print('SUPABASE_ANON_KEY: $_supabaseAnonKey');
        print('--------------------------------------------------------------------');
        // You might want to throw an exception here in a production setting
        // or handle it more gracefully depending on your app's requirements.
      }
    } catch (e) {
      print('Error loading .env file: $e');
      // Handle error, maybe rethrow or provide default values if appropriate for some variables
    }
  }

// You can add other environment variables here as needed
// static String get someOtherApiKey => dotenv.env['SOME_OTHER_API_KEY'] ?? 'default_value_if_not_found';
}