/*
// utils/routes.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/screens/calorie_screen.dart';
import 'package:flutter_application/screens/dashboard_screen.dart';
import 'package:flutter_application/screens/profil_screen.dart';
import 'package:flutter_application/screens/water_tracker_screen.dart';
import 'package:flutter_application/screens/recipe_screen.dart';
import 'package:flutter_application/screens/notifications_screen.dart';
import 'package:flutter_application/screens/recipe_details_screen.dart';
import 'package:flutter_application/screens/login_screen.dart';
import 'package:flutter_application/screens/register_screen.dart'; // Added signup import
import 'package:flutter_application/screens/chatbot_screen.dart';
import 'package:flutter_application/screens/add_plat_screen.dart';
import 'package:flutter_application/models/recipe_model.dart';
import 'dart:js' as js;

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/register';
  static const String dashboard = '/dashboard';
  static const String calories = '/calories';
  static const String profile = '/profile';
  static const String water = '/water';
  static const String notification = '/notification';
  static const String recipes = '/recipes';
  static const String recipeDetails = '/recipe-details';
  static const String chatbot = '/chatbot';
  static const String addPlat = '/addPlat';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String chatbotId =
        '1'; // Replace with your actual chatbot ID or get from settings

    switch (settings.name) {
      // Authentication routes without bottom navigation
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      // Main app routes with bottom navigation
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => const RootNavigationPage(initialIndex: 0),
        );

      case AppRoutes.calories:
        return MaterialPageRoute(
          builder: (_) => const RootNavigationPage(initialIndex: 1),
        );

      case AppRoutes.water:
        return MaterialPageRoute(
          builder: (_) => const RootNavigationPage(initialIndex: 2),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const RootNavigationPage(initialIndex: 3),
        );

      // Standalone screens (no bottom navigation)
      case AppRoutes.notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());

      case AppRoutes.addPlat:
        return MaterialPageRoute(builder: (_) => const AddPlatScreen());

      case AppRoutes.recipes:
        return MaterialPageRoute(builder: (_) => const RecipesScreen());

      case AppRoutes.chatbot:
        return MaterialPageRoute(
          builder: (_) => ChatbotScreen(chatbotId: chatbotId),
        );

      case AppRoutes.recipeDetails:
        final recipe = settings.arguments as Recipe;
        return MaterialPageRoute(
          builder: (_) => RecipeDetailsScreen(recipe: recipe),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}

class RootNavigationPage extends StatefulWidget {
  const RootNavigationPage({Key? key, required this.initialIndex})
    : super(key: key);

  final int initialIndex;

  @override
  _RootNavigationPageState createState() => _RootNavigationPageState();
}

class _RootNavigationPageState extends State<RootNavigationPage> {
  late int _selectedIndex;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadChatbaseScript();
  }

  void _loadChatbaseScript() {
    try {
      js.context.callMethod('eval', [
        '''
        (function() {
          function loadChatbase() {
            const script = document.createElement('script');
            script.src = 'https://www.chatbase.co/embed.min.js';
            script.id = 'a_t4Hm6RM6VVtTkPm9DFX';
            script.setAttribute('data-chatbot-id', '1');
            script.setAttribute('data-domain', 'www.chatbase.co');
            script.onerror = function() {
              console.error('Chatbase failed to load');
              // Notify Flutter of the error
              if (window.flutterWebRenderer) {
                flutterWebRenderer.postMessage('chatbaseError');
              }
            };
            document.body.appendChild(script);
          }
          
          if (document.readyState === 'complete') {
            loadChatbase();
          } else {
            window.addEventListener('load', loadChatbase);
          }
        })();
        ''',
      ]);

      // Optional: Listen for JS errors (if using Flutter Web renderer)
      js.context['flutterWebRenderer'] = {
        'postMessage': (String message) {
          if (message == 'chatbaseError') {
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          }
        },
      };

      // Simulate loading delay (remove if unnecessary)
      Future.delayed(const Duration(seconds: 2), () {
        if (!_hasError) {
          setState(() => _isLoading = false);
        }
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  // List of main screens with bottom navigation
  final List<Widget> _screens = [
    const DashboardScreen(),
    const CalorieScreen(userId: '',), ///////////////////////what is this userId
    const WaterTrackerScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    // Update the state and navigate using named routes to update the URL
    setState(() {
      _selectedIndex = index;
    });

    // Update the route in the navigator
    String route;
    switch (index) {
      case 0:
        route = AppRoutes.dashboard;
        break;
      case 1:
        route = AppRoutes.calories;
        break;
      case 2:
        route = AppRoutes.water;
        break;
      case 3:
        route = AppRoutes.profile;
        break;
      default:
        route = AppRoutes.dashboard;
    }

    // Replace current route instead of pushing new one to avoid stacking
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content (screens)
          _screens[_selectedIndex],

          // Chatbot overlay
          Positioned.fill(
            child: Stack(
              children: [
                // Placeholder for the chatbot (script will render here)
                const SizedBox.expand(),

                // Loading/Error UI
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (_hasError)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load chatbot',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadChatbaseScript,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color.fromRGBO(46, 125, 50, 1),
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Calories'),
        BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Water'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),

      ],
      onTap: _onItemTapped,
    );
  }
}
*/

//changed at 21:36
/*
// utils/routes.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/screens/calorie_screen.dart';
import 'package:flutter_application/screens/dashboard_screen.dart';
import 'package:flutter_application/screens/profil_screen.dart';
import 'package:flutter_application/screens/water_tracker_screen.dart';
import 'package:flutter_application/screens/recipe_screen.dart';
import 'package:flutter_application/screens/notifications_screen.dart';
import 'package:flutter_application/screens/recipe_details_screen.dart';
import 'package:flutter_application/screens/login_screen.dart';
import 'package:flutter_application/screens/register_screen.dart'; // Added signup import
import 'package:flutter_application/screens/chatbot_screen.dart';
import 'package:flutter_application/screens/add_plat_screen.dart';
import 'package:flutter_application/models/recipe_model.dart';
import 'package:flutter_application/services/auth_service.dart'; // Add this import for auth service
import 'dart:js' as js;

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/register';
  static const String dashboard = '/dashboard';
  static const String calories = '/calories';
  static const String profile = '/profile';
  static const String water = '/water';
  static const String notification = '/notification';
  static const String recipes = '/recipes';
  static const String recipeDetails = '/recipe-details';
  static const String chatbot = '/chatbot';
  static const String addPlat = '/addPlat';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String chatbotId =
        '1'; // Replace with your actual chatbot ID or get from settings

    // Get the current user ID - you'll need to implement this based on your auth system
    final String userId = AuthService.getCurrentUserIdReturningString();

    switch (settings.name) {
      // Authentication routes without bottom navigation
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      // Main app routes with bottom navigation
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => RootNavigationPage(initialIndex: 0, userId: userId),
        );

      case AppRoutes.calories:
        return MaterialPageRoute(
          builder: (_) => RootNavigationPage(initialIndex: 1, userId: userId),
        );

      case AppRoutes.water:
        return MaterialPageRoute(
          builder: (_) => RootNavigationPage(initialIndex: 2, userId: userId),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => RootNavigationPage(initialIndex: 3, userId: userId),
        );

      // Standalone screens (no bottom navigation)
      case AppRoutes.notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());

      case AppRoutes.addPlat:
        return MaterialPageRoute(builder: (_) => AddPlatScreen(userId: userId));

      case AppRoutes.recipes:
        return MaterialPageRoute(builder: (_) => const RecipesScreen());

      case AppRoutes.chatbot:
        return MaterialPageRoute(
          builder: (_) => ChatbotScreen(chatbotId: chatbotId),
        );

      case AppRoutes.recipeDetails:
        final recipe = settings.arguments as Recipe;
        return MaterialPageRoute(
          builder: (_) => RecipeDetailsScreen(recipe: recipe),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}

class RootNavigationPage extends StatefulWidget {
  const RootNavigationPage({
    Key? key,
    required this.initialIndex,
    required this.userId,
  }) : super(key: key);

  final int initialIndex;
  final String userId;

  @override
  _RootNavigationPageState createState() => _RootNavigationPageState();
}

class _RootNavigationPageState extends State<RootNavigationPage> {
  late int _selectedIndex;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadChatbaseScript();
  }

  void _loadChatbaseScript() {
    try {
      js.context.callMethod('eval', [
        '''
        (function() {
          function loadChatbase() {
            const script = document.createElement('script');
            script.src = 'https://www.chatbase.co/embed.min.js';
            script.id = 'a_t4Hm6RM6VVtTkPm9DFX';
            script.setAttribute('data-chatbot-id', '1');
            script.setAttribute('data-domain', 'www.chatbase.co');
            script.onerror = function() {
              console.error('Chatbase failed to load');
              // Notify Flutter of the error
              if (window.flutterWebRenderer) {
                flutterWebRenderer.postMessage('chatbaseError');
              }
            };
            document.body.appendChild(script);
          }
          
          if (document.readyState === 'complete') {
            loadChatbase();
          } else {
            window.addEventListener('load', loadChatbase);
          }
        })();
        ''',
      ]);

      // Optional: Listen for JS errors (if using Flutter Web renderer)
      js.context['flutterWebRenderer'] = {
        'postMessage': (String message) {
          if (message == 'chatbaseError') {
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          }
        },
      };

      // Simulate loading delay (remove if unnecessary)
      Future.delayed(const Duration(seconds: 2), () {
        if (!_hasError) {
          setState(() => _isLoading = false);
        }
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  // Create screens with the user ID passed to them
  late final List<Widget> _screens = [
    DashboardScreen(userId: widget.userId),
    CalorieScreen(userId: widget.userId),
    WaterTrackerScreen(userId: widget.userId),
    ProfileScreen(userId: widget.userId),
  ];

  void _onItemTapped(int index) {
    // Update the state and navigate using named routes to update the URL
    setState(() {
      _selectedIndex = index;
    });

    // Update the route in the navigator
    String route;
    switch (index) {
      case 0:
        route = AppRoutes.dashboard;
        break;
      case 1:
        route = AppRoutes.calories;
        break;
      case 2:
        route = AppRoutes.water;
        break;
      case 3:
        route = AppRoutes.profile;
        break;
      default:
        route = AppRoutes.dashboard;
    }

    // Replace current route instead of pushing new one to avoid stacking
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content (screens)
          _screens[_selectedIndex],

          // Chatbot overlay
          Positioned.fill(
            child: Stack(
              children: [
                // Placeholder for the chatbot (script will render here)
                const SizedBox.expand(),

                // Loading/Error UI
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (_hasError)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load chatbot',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadChatbaseScript,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color.fromRGBO(46, 125, 50, 1),
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Calories'),
        BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Water'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: _onItemTapped,
    );
  }
}
*/
// utils/routes.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/screens/calorie_screen.dart';
import 'package:flutter_application/screens/consumed_dishes_screen.dart';
import 'package:flutter_application/screens/dashboard_screen.dart';
import 'package:flutter_application/screens/favorites_screen.dart';
import 'package:flutter_application/screens/profil_screen.dart';
import 'package:flutter_application/screens/water_tracker_screen.dart';
import 'package:flutter_application/screens/recipe_screen.dart';
import 'package:flutter_application/screens/notifications_screen.dart';
import 'package:flutter_application/screens/recipe_details_screen.dart';
import 'package:flutter_application/screens/login_screen.dart';
import 'package:flutter_application/screens/register_screen.dart';
import 'package:flutter_application/screens/chatbot_screen.dart';
import 'package:flutter_application/screens/add_plat_screen.dart';
import 'package:flutter_application/models/recipe_model.dart';
import 'package:flutter_application/services/auth_service.dart'; // Import your existing AuthService
import 'dart:js' as js;

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/register';
  static const String dashboard = '/dashboard';
  static const String calories = '/calories';
  static const String profile = '/profile';
  static const String water = '/water';
  static const String notification = '/notification';
  static const String recipes = '/recipes';
  static const String recipeDetails = '/recipe-details';
  static const String chatbot = '/chatbot';
  static const String addPlat = '/addPlat';
  static const String favorites = '/favorites';
  static const String consumed = '/consumed';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String chatbotId = '1';

    // Get the current user ID using the static method
    final String userId = AuthService.getCurrentUserIdReturningString();

    switch (settings.name) {
      // Authentication routes without bottom navigation
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      // Main app routes with bottom navigation
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => RootNavigationPage(initialIndex: 0, userId: userId),
        );

      case AppRoutes.calories:
        return MaterialPageRoute(
          builder: (_) => RootNavigationPage(initialIndex: 1, userId: userId),
        );

      case AppRoutes.water:
        return MaterialPageRoute(
          builder: (_) => RootNavigationPage(initialIndex: 2, userId: userId),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => RootNavigationPage(initialIndex: 3, userId: userId),
        );

      // Standalone screens (no bottom navigation)
      case AppRoutes.notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      /*
      case AppRoutes.addPlat:
        return MaterialPageRoute(builder: (_) =>const  AddPlatScreen(userId: userId));
*/
      case AppRoutes.addPlat:
        return MaterialPageRoute(builder: (_) => const AddPlatScreen());

      case AppRoutes.recipes:
        return MaterialPageRoute(builder: (_) => const RecipesScreen());

      case AppRoutes.chatbot:
        return MaterialPageRoute(
          builder: (_) => ChatbotScreen(chatbotId: chatbotId),
        );

      case AppRoutes.recipeDetails:
        final recipe = settings.arguments as Recipe;
        return MaterialPageRoute(
          builder: (_) => RecipeDetailsScreen(recipe: recipe),
        );

      case AppRoutes.favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());

      case AppRoutes.consumed:
        return MaterialPageRoute(
          builder: (_) => ConsumedDishesScreen(userId: userId),
        );
  /*
      case AppRoutes.consumed:
        return MaterialPageRoute(
          builder: (_) => RootNavigationPage(initialIndex: 5, userId: userId),
        );
      */
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}

class RootNavigationPage extends StatefulWidget {
  const RootNavigationPage({
    Key? key,
    required this.initialIndex,
    required this.userId,
  }) : super(key: key);

  final int initialIndex;
  final String userId;

  @override
  _RootNavigationPageState createState() => _RootNavigationPageState();
}

class _RootNavigationPageState extends State<RootNavigationPage> {
  late int _selectedIndex;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadChatbaseScript();
  }

  void _loadChatbaseScript() {
    try {
      js.context.callMethod('eval', [
        '''
        (function() {
          function loadChatbase() {
            const script = document.createElement('script');
            script.src = 'https://www.chatbase.co/embed.min.js';
            script.id = 'a_t4Hm6RM6VVtTkPm9DFX';
            script.setAttribute('data-chatbot-id', '1');
            script.setAttribute('data-domain', 'www.chatbase.co');
            script.onerror = function() {
              console.error('Chatbase failed to load');
              // Notify Flutter of the error
              if (window.flutterWebRenderer) {
                flutterWebRenderer.postMessage('chatbaseError');
              }
            };
            document.body.appendChild(script);
          }
          
          if (document.readyState === 'complete') {
            loadChatbase();
          } else {
            window.addEventListener('load', loadChatbase);
          }
        })();
        ''',
      ]);

      // Optional: Listen for JS errors (if using Flutter Web renderer)
      js.context['flutterWebRenderer'] = {
        'postMessage': (String message) {
          if (message == 'chatbaseError') {
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          }
        },
      };

      // Simulate loading delay (remove if unnecessary)
      Future.delayed(const Duration(seconds: 2), () {
        if (!_hasError) {
          setState(() => _isLoading = false);
        }
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  // Create screens with the user ID passed to them
  late final List<Widget> _screens = [
    DashboardScreen(),
    CalorieScreen(userId: widget.userId),
    WaterTrackerScreen(),
    ProfileScreen(),
    FavoritesScreen(),
    //ConsumedDishesScreen(userId: widget.userId),
    /*DashboardScreen(userId: widget.userId),
    CalorieScreen(userId: widget.userId),
    WaterTrackerScreen(userId: widget.userId),
    ProfileScreen(userId: widget.userId),
    */
  ];

  void _onItemTapped(int index) {
    // Update the state and navigate using named routes to update the URL
    setState(() {
      _selectedIndex = index;
    });

    // Update the route in the navigator
    String route;
    switch (index) {
      case 0:
        route = AppRoutes.dashboard;
        break;
      case 1:
        route = AppRoutes.calories;
        break;
      case 2:
        route = AppRoutes.water;
        break;
      case 3:
        route = AppRoutes.profile;
        break;
      case 4:
        route = AppRoutes.favorites;
      case 5:
        route = AppRoutes.consumed;
      default:
        route = AppRoutes.dashboard;
    }

    // Replace current route instead of pushing new one to avoid stacking
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content (screens)
          _screens[_selectedIndex],

          // Chatbot overlay
          Positioned.fill(
            child: Stack(
              children: [
                // Placeholder for the chatbot (script will render here)
                const SizedBox.expand(),

                // Loading/Error UI
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (_hasError)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load chatbot',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadChatbaseScript,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color.fromRGBO(46, 125, 50, 1),
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Calories'),
        BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Water'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
      onTap: _onItemTapped,
    );
  }
}
