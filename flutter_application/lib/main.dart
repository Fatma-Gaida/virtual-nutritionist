/*
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
*/

import 'package:flutter/material.dart';
import 'package:flutter_application/models/recipe_model.dart';
import 'package:flutter_application/screens/recipe_details_screen.dart';
import 'package:flutter_application/screens/recipe_screen.dart';
import 'package:flutter_application/screens/water_tracker_screen.dart';
import 'package:flutter_application/screens/calorie_screen.dart';
import 'package:flutter_application/screens/profil_screen.dart';
import 'package:flutter_application/screens/login_screen.dart';
import 'package:flutter_application/providers/user_provider.dart';
import 'package:flutter_application/services/auth_service.dart';
import 'package:flutter_application/services/api_service.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  static const String login = '/login';
  static const String calories = '/calories';
  static const String profile = '/profile';
  static const String water = '/water';
  static const String recipes = '/recipes';
  static const String recipeDetails = '/recipe-details';
  static const String camera = '/camera';
}

void main() {
  runApp(
    MultiProvider(
      /*
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Add other providers as needed
      ],*/
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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health & Nutrition App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green[800],
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Poppins', // Make sure to define this in pubspec.yaml
      ),
      initialRoute: AppRoutes.login,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.login:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case AppRoutes.calories:
            return MaterialPageRoute(
              builder: (_) => const MainNavigationScreen(initialIndex: 0),
            );
          case AppRoutes.water:
            return MaterialPageRoute(
              builder: (_) => const MainNavigationScreen(initialIndex: 1),
            );
          case AppRoutes.profile:
            return MaterialPageRoute(
              builder: (_) => const MainNavigationScreen(initialIndex: 3),
            );
          case AppRoutes.recipes:
            return MaterialPageRoute(builder: (_) => const RecipesScreen());
          case AppRoutes.recipeDetails:
            final recipe = settings.arguments as Recipe;
            return MaterialPageRoute(
              builder: (_) => RecipeDetailsScreen(recipe: recipe),
            );
          default:
            return MaterialPageRoute(
              builder:
                  (_) => const Scaffold(
                    body: Center(child: Text('Route not found')),
                  ),
            );
        }
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key, required this.initialIndex})
    : super(key: key);

  final int initialIndex;

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _selectedIndex;

  // List of screens to display in the bottom navigation bar
  final List<Widget> _screens = [
    const CalorieScreen(),
    const WaterTrackerScreen(),
    const SizedBox(), // Placeholder for camera button
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    // Handle camera button separately
    if (index == 2) {
      _showCameraOptions(context);
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _showCameraOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to camera screen or launch camera
                  // Implement camera functionality when available
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Camera feature coming soon')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle gallery selection
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gallery feature coming soon'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Calories',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.water_drop),
            label: 'Water',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: Colors.green[800],
              radius: 22,
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: _onItemTapped,
      ),
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton(
                backgroundColor: Colors.green[800],
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  // Navigate to recipes screen to add a meal
                  Navigator.pushNamed(context, AppRoutes.recipes);
                },
              )
              : null,
    );
  }
}
