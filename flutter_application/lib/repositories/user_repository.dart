import 'package:dio/dio.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  Future<User> createUser(User user) async {
    try {
      final response = await apiService.post('/users/creer-compte', user.toJson());
      return User.fromJson(response.data);
    } catch (e) {
      if (e is DioError) {
        throw Exception('Failed to create user: ${e.response?.data ?? e.message}');
      }
      throw Exception('Failed to create user: $e');
    }
  }

  Future<User> getUserById(String id) async {
    try {
      final response = await apiService.get('/users/$id');
      return User.fromJson(response.data);
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 404) {
          throw Exception('User not found');
        } else if (e.response?.statusCode == 400) {
          throw Exception('Invalid ID format');
        }
        throw Exception('Failed to fetch user: ${e.response?.data ?? e.message}');
      }
      throw Exception('Failed to fetch user: $e');
    }
  }
}