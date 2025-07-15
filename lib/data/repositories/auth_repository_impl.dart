import 'package:carib_connect/data/data_sources/local/auth_local_data_source.dart';
import 'package:carib_connect/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:carib_connect/data/models/user_model.dart';
import 'package:carib_connect/domain/repositories/auth_repository.dart';
import 'package:carib_connect/components/carib_login/carib_login.dart'; // For LoginData

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<UserModel?> login(LoginData loginData) async {
    try {
      final responseData = await _remoteDataSource.login(loginData);
      final token = responseData['token'] as String;
      final userJson = responseData['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userJson);

      await _localDataSource.saveToken(token);
      await _localDataSource.saveUserId(user.id); // Save user ID for convenience
      return user;
    } catch (e) {
      print("Login Error in Repository: $e");
      // Optionally, rethrow specific exception types or handle them
      rethrow; // Propagate the error to the BLoC
    }
  }

  @override
  Future<UserModel?> signUp(SignupData signupData) async {
    try {
      final responseData = await _remoteDataSource.signUp(signupData);
      final userJson = responseData['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userJson);

      // Optionally, if your API returns a token immediately on signup, save it
      if (responseData.containsKey('token')) {
        final token = responseData['token'] as String;
        await _localDataSource.saveToken(token);
        await _localDataSource.saveUserId(user.id);
      }
      return user;
    } catch (e) {
      print("SignUp Error in Repository: $e");
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      final token = await _localDataSource.getToken();
      if (token != null) {
        // Optional: Call API to invalidate server-side session
        // await _remoteDataSource.logout(token);
      }
    } catch (e) {
      // Log error but don't prevent local logout
      print("API logout error: $e");
    } finally {
      // Always clear local token and user ID
      await _localDataSource.deleteToken();
      await _localDataSource.deleteUserId();
    }
  }

  @override
  Future<String?> recoverPassword(String email) async {
    try {
      return await _remoteDataSource.recoverPassword(email);
    } catch (e) {
      print("Recover Password Error in Repository: $e");
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final token = await _localDataSource.getToken();
      if (token == null) {
        return null; // No token, so no authenticated user
      }

      // Optionally fetch fresh user data from API if token exists
      // This is good if user details can change and you want the latest
      final userJson = await _remoteDataSource.fetchCurrentUser(token);
      if (userJson != null) {
        return UserModel.fromJson(userJson);
      } else {
        // Token might be valid but fetching user failed, or token expired on server
        // You might want to clear the local token here if API confirms it's invalid
        await _localDataSource.deleteToken();
        await _localDataSource.deleteUserId();
        return null;
      }
    } catch (e) {
      print("GetCurrentUser Error in Repository: $e");
      // If fetching user fails (e.g. network error), could decide to clear token or not
      return null;
    }
  }

  @override
  Future<String?> getToken() async {
    return await _localDataSource.getToken();
  }

  @override
  Future<void> saveToken(String token) async {
    await _localDataSource.saveToken(token);
  }

  @override
  Future<void> deleteToken() async {
    await _localDataSource.deleteToken();
    await _localDataSource.deleteUserId();
  }
}