import '../models/user_model.dart';

class AuthRepository {
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

      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        username: email.split('@')[0],
        createdAt: DateTime.now(),
      );

      return AuthResponse(
        user: user,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
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

      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        username: username,
        createdAt: DateTime.now(),
      );

      return AuthResponse(
        user: user,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        success: true,
        message: 'Signup successful',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // Clear stored auth data
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      // Check if token exists in secure storage
      await Future.delayed(const Duration(milliseconds: 200));
      return false; // Mock implementation
    } catch (e) {
      rethrow;
    }
  }
}
