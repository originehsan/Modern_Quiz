import 'package:flutter/foundation.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  // State
  User? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;
  String? _authToken;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  String? get authToken => _authToken;

  // Password strength
  int _passwordStrength = 0;
  int get passwordStrength => _passwordStrength;

  AuthViewModel({required this.repository});

  /// Check if user is already logged in (call on app startup)
  Future<void> checkExistingLogin() async {
    try {
      final isLoggedIn = await repository.isUserLoggedIn();
      if (isLoggedIn) {
        final user = await repository.getStoredUser();
        final token = await repository.getStoredToken();
        if (user != null && token != null) {
          _currentUser = user;
          _authToken = token;
          _isAuthenticated = true;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error checking existing login: $e');
    }
  }

  Future<void> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await repository.login(email: email, password: password);

      if (response.success) {
        _currentUser = response.user;
        _authToken = response.token;
        _isAuthenticated = true;
        _errorMessage = null;
      } else {
        _errorMessage = response.message ?? 'Login failed';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await repository.signup(
        email: email,
        password: password,
        username: username,
      );

      if (response.success) {
        _currentUser = response.user;
        _authToken = response.token;
        _isAuthenticated = true;
        _errorMessage = null;
      } else {
        _errorMessage = response.message ?? 'Signup failed';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.logout();
      _currentUser = null;
      _authToken = null;
      _isAuthenticated = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void checkPasswordStrength(String password) {
    int strength = 0;

    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    _passwordStrength = (strength / 3).ceil().clamp(0, 4);
    notifyListeners();
  }

  String getPasswordStrengthText() {
    switch (_passwordStrength) {
      case 0:
        return 'Too weak';
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Unknown';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
