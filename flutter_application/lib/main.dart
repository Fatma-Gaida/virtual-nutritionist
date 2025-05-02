
// import 'package:flutter/material.dart';
// import 'package:flutter_application/screens/notifications_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_application/screens/calorie_screen.dart';
// import 'package:flutter_application/screens/login_screen.dart';
// import 'package:flutter_application/screens/register_screen.dart';

// import 'package:flutter_application/screens/notifications_screen.dart';
// import 'package:flutter_application/providers/user_provider.dart';
// import 'package:flutter_application/services/auth_service.dart';
// import 'package:flutter_application/services/api_service.dart';
// import 'package:flutter_application/screens/add_plat_screen.dart';
// import 'package:flutter_application/screens/chatbot_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         // First, provide the ApiService
//         Provider<ApiService>(create: (_) => ApiService()),
//         // Then provide the AuthService which depends on ApiService
//         ProxyProvider<ApiService, AuthService>(
//           update: (_, apiService, __) => AuthService(apiService),
//         ),
//         // Finally provide the UserProvider which depends on AuthService
//         ChangeNotifierProxyProvider<AuthService, UserProvider>(
//           create:
//               (context) => UserProvider(
//                 Provider.of<AuthService>(context, listen: false),
//               ),
//           update:
//               (_, authService, previousUserProvider) =>
//                   previousUserProvider ?? UserProvider(authService),
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: '/notification',
//         routes: {
//           '/login': (context) => const LoginScreen(),
//           '/calories': (context) => const CalorieScreen(),
//           '/register': (context) => const RegisterScreen(),
//           '/notification': (context) => const NotificationScreen(),
//           '/addplat': (context) => const AddPlatScreen(),
//           '/chatbot': (context) =>  ChatbotScreen(chatbotId: '1'),
//         },
//         theme: ThemeData(
//           primarySwatch: Colors.green,
//           inputDecorationTheme: InputDecorationTheme(
//             filled: true,
//             fillColor: Colors.green[50],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_application/providers/user_provider.dart';
import 'package:flutter_application/services/auth_service.dart';
import 'package:flutter_application/services/api_service.dart';
import 'package:flutter_application/utils/routes.dart';
import 'package:provider/provider.dart';


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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green[800],
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Poppins',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.green[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      initialRoute: AppRoutes.dashboard,
      onGenerateRoute: AppRouter.generateRoute,
      // Remove the routes parameter to avoid conflicts with onGenerateRoute
    );
  }
}