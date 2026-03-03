import '../models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _emailKey = 'user_email';
  static const String _usernameKey = 'user_username';

  final _secureStorage = const FlutterSecureStorage();

  // Mock implementation - in production, this would call an API

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (!email.contains('@')) {
        throw Exception('Invalid email format');
      }

      if (password.length < 8) {
        throw Exception('Password too short');
      }

      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      final username = email.split('@')[0];

      // Store securely
      await _secureStorage.write(key: _tokenKey, value: token);
      await _secureStorage.write(key: _userIdKey, value: userId);
      await _secureStorage.write(key: _emailKey, value: email);
      await _secureStorage.write(key: _usernameKey, value: username);

      final user = User(
        id: userId,
        email: email,
        username: username,
        createdAt: DateTime.now(),
      );

      return AuthResponse(
        user: user,
        token: token,
        success: true,
        message: 'Login successful',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (!email.contains('@')) {
        throw Exception('Invalid email format');
      }

      if (password.length < 8) {
        throw Exception('Password must be at least 8 characters');
      }

      if (username.isEmpty) {
        throw Exception('Username is required');
      }

      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

      // Store securely
      await _secureStorage.write(key: _tokenKey, value: token);
      await _secureStorage.write(key: _userIdKey, value: userId);
      await _secureStorage.write(key: _emailKey, value: email);
      await _secureStorage.write(key: _usernameKey, value: username);

      final user = User(
        id: userId,
        email: email,
        username: username,
        createdAt: DateTime.now(),
      );

      return AuthResponse(
        user: user,
        token: token,
        success: true,
        message: 'Signup successful',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // Clear all stored auth data from secure storage
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _userIdKey);
      await _secureStorage.delete(key: _emailKey);
      await _secureStorage.delete(key: _usernameKey);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getStoredToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getStoredUserId() async {
    try {
      return await _secureStorage.read(key: _userIdKey);
    } catch (e) {
      return null;
    }
  }

  Future<User?> getStoredUser() async {
    try {
      final userId = await _secureStorage.read(key: _userIdKey);
      final email = await _secureStorage.read(key: _emailKey);
      final username = await _secureStorage.read(key: _usernameKey);

      if (userId != null && email != null && username != null) {
        return User(
          id: userId,
          email: email,
          username: username,
          createdAt: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
