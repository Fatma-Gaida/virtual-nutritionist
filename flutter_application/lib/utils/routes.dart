import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'package:flutter_application/screens/calorie_screen.dart';
import 'package:flutter_application/screens/dashboard_screen.dart';
import 'package:flutter_application/screens/profil_screen.dart';
import 'package:flutter_application/screens/water_tracker_screen.dart'; 

import 'package:flutter_application/screens/notifications_screen.dart'; 

class AppRoutes {
  static const String login = '/login';
  static const String dashboard= '/dashboard';
  static const String calories = '/calories';
  static const String profile = '/profile';
  static const String water = '/water';
  static const String signup = '/signup';
   static const String notification = '/notification';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // You can pass chatbotId through route settings if needed
    final String chatbotId = '1';  // Replace with your actual chatbot ID or get from settings
    
    switch (settings.name) {
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => RootNavigationPage(initialIndex: 0, chatbotId: chatbotId),
        );
      case AppRoutes.calories:
        return MaterialPageRoute(
          builder: (_) => RootNavigationPage(initialIndex: 1, chatbotId: chatbotId),
        );
      case AppRoutes.water:
        return MaterialPageRoute(
          builder: (_) => RootNavigationPage(initialIndex: 2, chatbotId: chatbotId),
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => RootNavigationPage(initialIndex: 3, chatbotId: chatbotId),
        );
        
      
      // Add other routes as needed
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

class RootNavigationPage extends StatefulWidget {
  const RootNavigationPage({Key? key, required this.initialIndex, this.chatbotId = "1"}) : super(key: key);

  final int initialIndex;
  final String chatbotId;

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
            script.setAttribute('data-chatbot-id', '${widget.chatbotId}');
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
        '''
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
        }
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

  // List of screens to display
  final List<Widget> _screens = [
    const DashboardScreen(), // Make sure to have this or uncomment import
    const CalorieScreen(),
    const WaterTrackerScreen(),
    const ProfileScreen(),
  ];

  // Add the missing _onItemTapped method
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
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Calories'),
        BottomNavigationBarItem(
          icon: Icon(Icons.water_drop),
          label: 'Water',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
      onTap: _onItemTapped,
    );
  }
}