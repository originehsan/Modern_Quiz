import 'package:flutter/foundation.dart';
import '../../data/models/user_model.dart';

class ProfileViewModel extends ChangeNotifier {
  // State
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _soundEnabled = true;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get soundEnabled => _soundEnabled;

  ProfileViewModel();

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  Future<void> loadUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call to load user profile
      await Future.delayed(const Duration(milliseconds: 500));
      // In real app, fetch from API or local storage
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
  }

  void setSound(bool enabled) {
    _soundEnabled = enabled;
    notifyListeners();
  }
}
