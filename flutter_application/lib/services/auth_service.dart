import 'package:flutter/foundation.dart';

class AuthService {
  static Future<void> login(String email, String password) async {
    // Implement your actual authentication logic here
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Remove this in production
    if (kDebugMode) {
      print('Logged in with $email');
    }
  }
}
