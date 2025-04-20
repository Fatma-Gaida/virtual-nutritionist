import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  // Login method
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiService.post('/login', {
        'email': email,
        'motDePasse': password,
      });

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);

        // Save user ID to SharedPreferences for later use
        await _saveUserCredentials(user);

        return user;
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception('Authentication failed');
    }
  }

  // Save user credentials for later use
  Future<void> _saveUserCredentials(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_name', user.nom);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    return userId != null && userId.isNotEmpty;
  }

  // Log out
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
  }

  // Get current user ID
  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
}
