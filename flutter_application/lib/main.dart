import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/screens/calorie_screen.dart';
import 'package:flutter_application/screens/login_screen.dart';
import 'package:flutter_application/providers/user_provider.dart';
import 'package:flutter_application/services/auth_service.dart';
import 'package:flutter_application/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // First, provide the ApiService
        Provider<ApiService>(create: (_) => ApiService()),
        // Then provide the AuthService which depends on ApiService
        ProxyProvider<ApiService, AuthService>(
          update: (_, apiService, __) => AuthService(apiService),
        ),
        // Finally provide the UserProvider which depends on AuthService
        ChangeNotifierProxyProvider<AuthService, UserProvider>(
          create:
              (context) => UserProvider(
                Provider.of<AuthService>(context, listen: false),
              ),
          update:
              (_, authService, previousUserProvider) =>
                  previousUserProvider ?? UserProvider(authService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/calories': (context) => const CalorieScreen(),
        },
        theme: ThemeData(
          primarySwatch: Colors.green,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.green[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
