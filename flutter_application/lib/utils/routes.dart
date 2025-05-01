// import 'package:flutter/material.dart';
// import 'package:flutter_application/screens/calorie_screen.dart';
// //import 'package:flutter_application/screens/home_screen.dart';
// import 'package:flutter_application/screens/profil_screen.dart';
// //import 'package:flutter_application/screens/activity_screen.dart';
// import 'package:flutter_application/screens/recipe_screen.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_application/screens/calorie_screen.dart';
// //import 'package:flutter_application/screens/home_screen.dart';
// import 'package:flutter_application/screens/profil_screen.dart';
// //import 'package:flutter_application/screens/activity_screen.dart';
// import 'package:flutter_application/screens/recipe_screen.dart';

// class AppRoutes {
//   static const String login = '/login';
//   static const String home = '/home';
//   //static const String home = '/home';
//   static const String calories = '/calories';
//   static const String profile = '/profile';
//   static const String activity = '/activity';
//   //static const String profile = '/profile';
//   //static const String activity = '/activity';
//   static const String signup = '/signup';
//   static const String camera = '/camera';
//   static const String recipes = '/recipes';
//   static const String recipeDetails = '/recipe-details';
// }

// class MainNavigationScreen extends StatefulWidget {
//   const MainNavigationScreen({Key? key, required this.initialIndex})
//     : super(key: key);

//   final int initialIndex;

//   @override
//   _MainNavigationScreenState createState() => _MainNavigationScreenState();
// }

// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   late int _selectedIndex;

//   // List of screens to display in the bottom navigation bar
//   final List<Widget> _screens = [
//     //const HomeScreen(), // Create this if you don't have it yet
//     const CalorieScreen(),
//     const SizedBox(), // Placeholder for camera button
//     //const ActivityScreen(), // Create this if you don't have it yet
//     const ProfileScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialIndex;
//   }

//   void _onItemTapped(int index) {
//     // Handle camera button separately
//     if (index == 2) {
//       _showCameraOptions(context);
//       return;
//     }

//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   void _showCameraOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Take a photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Navigate to camera screen or launch camera
//                   Navigator.pushNamed(context, AppRoutes.camera);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Choose from gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Handle gallery selection
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.green[800],
//         unselectedItemColor: Colors.grey,
//         currentIndex: _selectedIndex,
//         items: [
//           const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.bar_chart),
//             label: 'Calories',
//           ),
//           BottomNavigationBarItem(
//             icon: CircleAvatar(
//               backgroundColor: Colors.green[800],
//               radius: 22,
//               child: const Icon(Icons.camera_alt, color: Colors.white),
//             ),
//             label: '',
//           ),
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.fitness_center),
//             label: 'Activity',
//           ),
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
