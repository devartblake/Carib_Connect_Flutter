import 'package:carib_connect/core/services/secure_storage_service.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> saveUserId(String userId); // If you decide to store it
  Future<String?> getUserId();            // If you decide to retrieve it
  Future<void> deleteUserId();           // If you decide to delete it
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService _secureStorageService;

  AuthLocalDataSourceImpl({required SecureStorageService secureStorageService})
      : _secureStorageService = secureStorageService;

  @override
  Future<void> deleteToken() async {
    await _secureStorageService.deleteToken();
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorageService.getToken();
  }

  @override
  Future<void> saveToken(String token) async {
    await _secureStorageService.saveToken(token);
  }

  @override
  Future<String?> getUserId() async {
    return await _secureStorageService.getUserId();
  }

  @override
  Future<void> saveUserId(String userId) async {
    await _secureStorageService.saveUserId(userId);
  }

  @override
  Future<void> deleteUserId() async {
    await _secureStorageService.deleteUserId();
  }
}