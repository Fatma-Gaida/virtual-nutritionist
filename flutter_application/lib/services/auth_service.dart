import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<User> login(String email, String password) async {
    try {
      print('Starting login process for email: $email');

      // Test connection first
      final isConnected = await _apiService.testConnection();
      if (!isConnected) {
        throw Exception(
          'Cannot connect to server. Please check your network connection or try again later.',
        );
      }

      print('Connection test passed, proceeding with login request');

      // Try with 'motDePasse' as seen in your model
      try {
        final response = await _apiService.post('/login', {
          'email': email,
          'motDePasse': password,
        });

        print('Login response received: ${response.statusCode}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Login successful, parsing user data');
          final user = User.fromJson(response.data);
          await _saveUserCredentials(user);
          return user;
        } else {
          print('Login failed with status: ${response.statusCode}');
          throw Exception(
            'Authentication failed with status: ${response.statusCode}',
          );
        }
      } catch (firstAttemptError) {
        print('First login attempt failed: $firstAttemptError');

        // If first attempt fails, try with 'password' instead
        print('Trying alternative parameter name: password');
        final response = await _apiService.post('/login', {
          'email': email,
          'password': password,
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Second login attempt successful');
          final user = User.fromJson(response.data);
          await _saveUserCredentials(user);
          return user;
        } else {
          throw Exception('Authentication failed: Invalid credentials');
        }
      }
    } catch (e) {
      print('Login error details: $e');

      // Extract meaningful message from exception
      String errorMessage = e.toString();
      if (errorMessage.contains('DioError')) {
        errorMessage = 'Network error: Could not connect to server';
      } else if (errorMessage.contains('401')) {
        errorMessage = 'Invalid email or password';
      } else if (errorMessage.contains('404')) {
        errorMessage = 'Login service not available';
      }

      throw Exception('Authentication failed: $errorMessage');
    }
  }

  // Save all user data to SharedPreferences
  Future<void> _saveUserCredentials(User user) async {
    final prefs = await SharedPreferences.getInstance();

    // Save user ID
    String userId = user.idU.timestamp.toString();
    await prefs.setString('user_id', userId);
    await prefs.setString('user_name', user.nom);
    await prefs.setString('user_email', user.email);

    // Save additional user information
    if (user.dob != null) {
      await prefs.setString('user_dob', user.dob!.toIso8601String());
    }
    if (user.sexe != null) {
      await prefs.setString('user_sexe', user.sexe!);
    }
    if (user.taille != null) {
      await prefs.setDouble('user_taille', user.taille!);
    }
    if (user.poids != null) {
      await prefs.setDouble('user_poids', user.poids!);
    }
    if (user.etatActivite != null) {
      await prefs.setString('user_etat_activite', user.etatActivite!);
    }
    if (user.dashBoardQuotidienId != null) {
      await prefs.setString('user_dashboard_id', user.dashBoardQuotidienId!);
    }

    // Save lists
    await prefs.setStringList('user_allergies', user.allergies);
    await prefs.setStringList('user_maladies', user.maladies);
    await prefs.setStringList('user_notification_ids', user.notificationIds);
    await prefs.setStringList('user_objectif_ids', user.objectifIds);
    await prefs.setStringList('user_plat_favori_ids', user.platFavoriIds);

    print('User credentials and profile data saved successfully');
  }

  // Get the current user from SharedPreferences
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null || userId.isEmpty) {
      return null;
    }

    // Create an IdU object from the stored string
    final idU = IdU(
      timestamp: int.parse(userId),
      date: null, // We don't store the date part
    );

    return User(
      idU: idU,
      nom: prefs.getString('user_name') ?? '',
      email: prefs.getString('user_email') ?? '',
      dob:
          prefs.getString('user_dob') != null
              ? DateTime.parse(prefs.getString('user_dob')!)
              : null,
      sexe: prefs.getString('user_sexe'),
      taille: prefs.getDouble('user_taille'),
      poids: prefs.getDouble('user_poids'),
      etatActivite: prefs.getString('user_etat_activite'),
      dashBoardQuotidienId: prefs.getString('user_dashboard_id'),
      allergies: prefs.getStringList('user_allergies') ?? [],
      maladies: prefs.getStringList('user_maladies') ?? [],
      notificationIds: prefs.getStringList('user_notification_ids') ?? [],
      objectifIds: prefs.getStringList('user_objectif_ids') ?? [],
      platFavoriIds: prefs.getStringList('user_plat_favori_ids') ?? [],
    );
  }

  // Refresh user data from API
  Future<User> refreshUserData() async {
    final userId = await getCurrentUserId();
    if (userId == null) {
      throw Exception('Not logged in');
    }

    try {
      final response = await _apiService.get('/users/$userId');

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        await _saveUserCredentials(user);
        return user;
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      print('Error refreshing user data: $e');

      // If we can't refresh from API, return the locally stored data
      final localUser = await getCurrentUser();
      if (localUser == null) {
        throw Exception('No user data available');
      }
      return localUser;
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    return userId != null && userId.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear all user-related data
    await prefs.clear();
    print('User logged out successfully');
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
}
