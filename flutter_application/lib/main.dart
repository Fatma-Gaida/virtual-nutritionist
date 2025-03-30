import 'package:flutter/material.dart';
import 'screens/login_screen.dart' as login;
import 'screens/register_screen.dart' as register;
import 'screens/user_details_screen.dart' as details; // Use a unique alias for user_details_screen
import 'screens/profil_screen.dart' as profile;
void main() {
  print('Starting application...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building MyApp');
    return MaterialApp(
      title: 'Virtual Nutritionist',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //  home: const details.UserDetailsScreen(),
      // home: const register.SignUpScreen(), // Start with UserDetailsScreen
      home: const profile.ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}