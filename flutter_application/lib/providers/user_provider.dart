import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  final AuthService _authService;
  bool _isLoading = false;

  UserProvider(this._authService) {
    _loadUser();
  }

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> _loadUser() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _currentUser = await _authService.getCurrentUser();
    } catch (e) {
      print('Error loading user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUser() async {
    // Get user ID
    final userId = await _authService.getCurrentUserId();
    if (userId == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // Fetch fresh user data from API
      // This is a placeholder - you need to implement a "getUserById" method in your API service
      // final response = await apiService.get('/users/$userId');
      // _currentUser = User.fromJson(response.data);
      
      // For now, we'll just reload from SharedPreferences
      _currentUser = await _authService.getCurrentUser();
    } catch (e) {
      print('Error refreshing user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _currentUser = await _authService.login(email, password);
      notifyListeners();
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }
}