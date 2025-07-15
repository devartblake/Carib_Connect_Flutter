import 'package:carib_connect/data/models/user_model.dart';
import 'package:carib_connect/components/carib_login/carib_login.dart'; // For LoginData, SignupData

abstract class AuthRepository {
  Future<UserModel?> login(LoginData loginData);
  Future<UserModel?> signUp(SignupData signupData);
  Future<void> logout();
  Future<String?> recoverPassword(String email); // Returns message or null for error
  Future<UserModel?> getCurrentUser(); // Tries to get user if a token exists
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();

// Optional: For social logins if you implement them
// Future<UserModel?> signInWithGoogle();
// Future<UserModel?> signInWithFacebook();
}