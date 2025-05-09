import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class RegisterService {
  final ApiService _apiService;
  final AuthService _authService;

 RegisterService(this._apiService,this._authService);

  // Create account method
/*  Future<User> createAccount(User user) async {
    try {
      final response = await _apiService.post('/users/creer-compte', user.toRegistrationJson());

      if (response.statusCode == 201) {
        final createdUser = User.fromJson(response.data);
        await _authService.saveUserCredentials(createdUser);
        return createdUser;
      } else {
        throw Exception('->: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Registration error: ${e.toString()}');
    }
  }
*/
  
  Future<User> createAccount(User user) async {
    try {
      final response = await _apiService.post(
        '/users/creer-compte',
        user.toRegistrationJson(),
      );

      // Modified to accept both 200 and 201 as success
      if (response.statusCode == 201 || response.statusCode == 200) {
        final createdUser = User.fromJson(response.data);
        await _authService.saveUserCredentials(createdUser);
        return createdUser;
      } else {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Registration error details: $e');
      throw Exception('Registration error: ${e.toString()}');
    }
  }

  
  
  // Save user details to the backend
  Future<User> saveUserDetails({
    required String gender,
    required DateTime birthday,
    required double height,
    required int weight,
    required String activityLevel,
    required List<String> maladies,
    required List<String> allergies,
    required String mainGoal, // Not sent to backend
    required int targetWeight, // Not sent to backend
    required String targetPeriod, // Not sent to backend
  }) async {
    try {
      // Retrieve user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null) {
        throw Exception('User ID not found in local storage');
      }

      // Prepare query parameters for the backend
      final Map<String, dynamic> queryParams = {
        'sexe': gender,
        'dob': birthday.toIso8601String().split('T')[0], // Convert to yyyy-MM-dd
        'taille': height,
        'poids': weight,
        'etatActivite': activityLevel,
        'allergies': allergies.isNotEmpty ? allergies.join(',') : null,
        'maladies': maladies.isNotEmpty ? maladies.join(',') : null,
      };

      // Debug: Print query parameters
      print('Sending query params: $queryParams');

      // Send PUT request to the backend
      final response = await _apiService.put('/users/$userId/details', queryParams);

      // Check response status
      if (response.statusCode == 200) {
        print('User details saved successfully: ${response.data}');
        return User.fromJson(response.data);
      } else {
        print('Failed to save user details: ${response.statusCode} ${response.data}');
        throw Exception('Failed to save user details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving user details: $e');
      throw Exception('Error saving user details: $e');
    }
  }
}
