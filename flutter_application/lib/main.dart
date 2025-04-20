import 'package:flutter/material.dart';
//import 'screens/login_screen.dart' as login;
//import 'screens/register_screen.dart' as register;
//import 'screens/user_details_screen.dart' as details; // Use a unique alias for user_details_screen
//import 'screens/profil_screen.dart' as profile;
//import 'screens/calorie_screen.dart' as calorie; // Use a unique alias for calorie_screen
import 'screens/water_tracker_screen.dart' as water;
void main() {
  //print('Starting application...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    //print('Building MyApp');
    return MaterialApp(
      title: 'Virtual Nutritionist',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: const details.UserDetailsScreen(),
      //home: const calorie.CalorieScreen(),
      //home: const register.SignUpScreen(), // Start with UserDetailsScreen
      //home: const profile.ProfileScreen(),
      home: const water.WaterTrackerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
