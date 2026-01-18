import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'logger_service.dart';

/// Secure storage service for sensitive data like tokens.
///
/// Uses flutter_secure_storage which provides:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences (or Keystore on older devices)
///
/// Usage:
/// ```dart
/// final storage = SecureStorageService();
/// await storage.saveAccessToken('token_value');
/// final token = await storage.getAccessToken();
/// ```
class SecureStorageService {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';

  late final FlutterSecureStorage _storage;

  SecureStorageService() {
    // Configure with appropriate options for each platform
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }

  // --- Access Token ---

  /// Save the access token securely
  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
      LoggerService.debug('Access token saved');
    } catch (e, st) {
      LoggerService.error('Failed to save access token', e, st);
      rethrow;
    }
  }

  /// Retrieve the stored access token
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e, st) {
      LoggerService.error('Failed to read access token', e, st);
      return null;
    }
  }

  /// Check if an access token exists
  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // --- Refresh Token ---

  /// Save the refresh token securely
  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
      LoggerService.debug('Refresh token saved');
    } catch (e, st) {
      LoggerService.error('Failed to save refresh token', e, st);
      rethrow;
    }
  }

  /// Retrieve the stored refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e, st) {
      LoggerService.error('Failed to read refresh token', e, st);
      return null;
    }
  }

  // --- User ID ---

  /// Save the user ID
  Future<void> saveUserId(String userId) async {
    try {
      await _storage.write(key: _userIdKey, value: userId);
    } catch (e, st) {
      LoggerService.error('Failed to save user ID', e, st);
      rethrow;
    }
  }

  /// Retrieve the stored user ID
  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: _userIdKey);
    } catch (e, st) {
      LoggerService.error('Failed to read user ID', e, st);
      return null;
    }
  }

  // --- Session Management ---

  /// Save complete session data (tokens + user ID)
  Future<void> saveSession({
    required String accessToken,
    String? refreshToken,
    String? userId,
  }) async {
    await saveAccessToken(accessToken);
    if (refreshToken != null) {
      await saveRefreshToken(refreshToken);
    }
    if (userId != null) {
      await saveUserId(userId);
    }
    LoggerService.info('Session saved');
  }

  /// Clear all stored session data (for logout)
  Future<void> clearSession() async {
    try {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      await _storage.delete(key: _userIdKey);
      LoggerService.info('Session cleared');
    } catch (e, st) {
      LoggerService.error('Failed to clear session', e, st);
      rethrow;
    }
  }

  /// Clear all stored data (complete reset)
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      LoggerService.info('All secure storage cleared');
    } catch (e, st) {
      LoggerService.error('Failed to clear all storage', e, st);
      rethrow;
    }
  }

  // --- Generic Key-Value ---

  /// Save a custom key-value pair
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a custom key
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a custom key
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
