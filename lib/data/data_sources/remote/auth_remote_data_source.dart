import 'dart:convert';
import 'package:carib_connect/components/carib_login/carib_login.dart'; // For LoginData
import 'package:http/http.dart' as http; // Add http package to pubspec.yaml

// Define your base API URL
const String _apiBaseUrl = "https://192.168.1.117/api/auth";

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(LoginData loginData); // Returns raw JSON map for token and user
  Future<Map<String, dynamic>> signUp(SignupData signupData); // Returns raw JSON map
  Future<void> logout(String token); // May need token for server-side session invalidation
  Future<String?> recoverPassword(String email);
  Future<Map<String, dynamic>?> fetchCurrentUser(String token); // Fetch user details using token
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client _client;

  AuthRemoteDataSourceImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<Map<String, dynamic>> login(LoginData loginData) async {
    final response = await _client.post(
      Uri.parse('$_apiBaseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': loginData.name, // Assuming LoginData.name is the email/username
        'password': loginData.password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      // Expected response structure:
      // {
      //   "token": "your_jwt_token",
      //   "user": { "id": "...", "email": "...", "displayName": "..." ... }
      // }
      if (responseData.containsKey('token') && responseData.containsKey('user')) {
        return responseData;
      } else {
        throw Exception('Login response missing token or user data');
      }
    } else if (response.statusCode == 401 || response.statusCode == 400) {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Invalid credentials');
    } else {
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> signUp(SignupData signupData) async {
    // Ensure all required fields from SignupData are included
    final Map<String, dynamic> body = {
      'email': signupData.name, // Assuming name is email
      'password': signupData.password,
      'displayName': signupData.additionalSignupData?['displayName'], // Example
      // Add other fields from signupData.additionalSignupData as needed
      // 'phoneNumber': signupData.additionalSignupData?['phoneNumber'],
    };
    // Filter out null values if your API doesn't like them
    body.removeWhere((key, value) => value == null);


    final response = await _client.post(
      Uri.parse('$_apiBaseUrl/register'), // Or your signup endpoint
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) { // 201 Created or 200 OK
      final Map<String, dynamic> responseData = json.decode(response.body);
      // Expected response structure similar to login, or just user data if token is separate
      if (responseData.containsKey('user')) { // May or may not include token on signup
        return responseData;
      } else {
        throw Exception('Signup response missing user data');
      }
    } else if (response.statusCode == 400 || response.statusCode == 409) { // Bad Request or Conflict
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Signup failed');
    } else {
      throw Exception('Failed to sign up. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<void> logout(String token) async {
    // This is optional. Some backends have a logout endpoint to invalidate tokens.
    // If not, logout is purely a client-side token deletion.
    try {
      await _client.post(
        Uri.parse('$_apiBaseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      // Handle response if necessary, e.g., check for 200 OK
    } catch (e) {
      // Log error, but proceed with client-side logout anyway
      print("API logout error (client will still clear token): $e");
    }
  }

  @override
  Future<String?> recoverPassword(String email) async {
    final response = await _client.post(
      Uri.parse('$_apiBaseUrl/recover-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['message'] as String? ?? "Password recovery instructions sent.";
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Password recovery failed.');
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchCurrentUser(String token) async {
    final response = await _client.get(
      Uri.parse('$_apiBaseUrl/me'), // Or your endpoint to get current user details
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      // Expected: { "user": { "id": "...", "email": "..." ... } }
      // Or directly the user object: { "id": "...", "email": "..." ... }
      if (responseData.containsKey('user') && responseData['user'] is Map) {
        return responseData['user'] as Map<String, dynamic>;
      } else if (responseData.containsKey('id')) { // If API returns user object directly
        return responseData;
      }
      throw Exception('Current user data format is unexpected.');
    } else if (response.statusCode == 401) { // Token might be invalid or expired
      return null;
    } else {
      throw Exception('Failed to fetch current user. Status: ${response.statusCode}');
    }
  }
}