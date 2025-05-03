/*
import 'package:flutter/material.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/screens/calorie_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:flutter_application/models/meal_model.dart';
import 'package:flutter_application/screens/profil_screen.dart';
import 'package:flutter_application/screens/recipe_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/calorie_model.dart';
import '../repositories/Calories_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.currentUser;

            if (userProvider.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: Colors.green[700]),
              );
            }

            if (user == null) {
              return Center(
                child: Text(
                  'User not logged in',
                  style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfilePic(),
                  const SizedBox(height: 16),

                  // Display user name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      user.nom,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ),

                  // Display user email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      user.email,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),

                  const SizedBox(height: 24),

                  ProfileMenu(
                    text: "Personal information",
                    icon: Icons.person,
                    press: () {
                      // Navigate to detailed personal info page
                      _showPersonalInfo(context, user);
                    },
                  ),
                  const SizedBox(height: 12),
                  ProfileMenu(
                    text: "Objective",
                    icon: Icons.flag,
                    press: () {
                      // Navigate to objectives page
                    },
                  ),
                  const SizedBox(height: 12),
                  ProfileMenu(
                    text: "My favorites",
                    icon: Icons.favorite,
                    press: () {
                      // Navigate to favorites page
                    },
                  ),
                  const SizedBox(height: 12),
                  ProfileMenu(
                    text: "Settings",
                    icon: Icons.settings,
                    press: () {
                      // Navigate to settings page
                    },
                  ),
                  const SizedBox(height: 12),
                  ProfileMenu(
                    text: "Help Center",
                    icon: Icons.help,
                    press: () {
                      // Navigate to help center
                    },
                  ),
                  const SizedBox(height: 24),

                  // Logout button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await userProvider.logout();
                        // Navigate back to login
                        if (context.mounted) {
                          //Navigator.of(context).pushReplacementNamed('/login');
                          Navigator.pushNamed(context, AppRoutes.login);
                        }
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showPersonalInfo(BuildContext context, dynamic user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 24),

                  InfoItem(title: 'Name', value: user.nom),
                  InfoItem(title: 'Email', value: user.email),
                  InfoItem(
                    title: 'Birth Date',
                    value:
                        user.dob != null
                            ? '${user.dob.day}/${user.dob.month}/${user.dob.year}'
                            : 'Not provided',
                  ),
                  InfoItem(title: 'Gender', value: user.sexe ?? 'Not provided'),
                  InfoItem(
                    title: 'Height',
                    value:
                        user.taille != null
                            ? '${user.taille} cm'
                            : 'Not provided',
                  ),
                  InfoItem(
                    title: 'Weight',
                    value:
                        user.poids != null
                            ? '${user.poids} kg'
                            : 'Not provided',
                  ),
                  InfoItem(
                    title: 'Activity Level',
                    value: user.etatActivite ?? 'Not provided',
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Health Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 8),

                  InfoItem(
                    title: 'Allergies',
                    value:
                        user.allergies.isEmpty
                            ? 'None'
                            : user.allergies.join(', '),
                  ),
                  InfoItem(
                    title: 'Medical Conditions',
                    value:
                        user.maladies.isEmpty
                            ? 'None'
                            : user.maladies.join(', '),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  
  
  
}

class InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const InfoItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green[800],
      unselectedItemColor: Colors.grey,
      currentIndex: 1, // Calories tab is selected
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Calories'),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            backgroundColor: Colors.green[800],
            radius: 22,
            child: Icon(Icons.camera_alt, color: Colors.white),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Activity',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (index) {
        if (index == 4) {
          // Navigate to Profile screen when tapping on Profile tab
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        }else if(index == 1){
          // Navigate to Calorie screen when tapping on Calorie tab
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalorieScreen()),
          );
        }
      },
    );
  }

}

class ProfilePic extends StatelessWidget {
  const ProfilePic({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green[700]!, width: 2),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                // If you have a profile image from the user data, use it here
                // Otherwise use a placeholder or default image
                backgroundImage: const AssetImage(
                  'assets/images/default_profile.png',
                ),
                // If you don't have the image asset, use an icon instead:
                // child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            Positioned(
              right: -8,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  // Add functionality to change profile picture
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Change profile picture feature coming soon',
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[100]!, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    required this.icon,
    this.press,
  });

  final String text;
  final IconData icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green[700], size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
          ],
        ),
      ),
    );
  }
  
}
*/


import 'package:flutter/material.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/screens/calorie_screen.dart';
import 'package:flutter_application/screens/water_tracker_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:flutter_application/models/meal_model.dart';
import 'package:flutter_application/screens/profil_screen.dart';
import 'package:flutter_application/screens/recipe_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/calorie_model.dart';
import '../repositories/Calories_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.currentUser;

            if (userProvider.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: Colors.green[700]),
              );
            }

            if (user == null) {
              return Center(
                child: Text(
                  'User not logged in',
                  style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfilePic(),
                  const SizedBox(height: 16),

                  // Display user name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      user.nom,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ),

                  // Display user email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      user.email,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),

                  const SizedBox(height: 24),

                  ProfileMenu(
                    text: "Personal information",
                    icon: Icons.person,
                    press: () {
                      // Navigate to detailed personal info page
                      _showPersonalInfo(context, user);
                    },
                  ),
                  const SizedBox(height: 12),
                  ProfileMenu(
                    text: "Objective",
                    icon: Icons.flag,
                    press: () {
                      // Navigate to objectives page
                    },
                  ),
                  const SizedBox(height: 12),
                  ProfileMenu(
                    text: "My favorites",
                    icon: Icons.favorite,
                    press: () {
                      // Navigate to favorites page
                    },
                  ),
                  const SizedBox(height: 12),
                  ProfileMenu(
                    text: "Historique",
                    icon: Icons.settings,
                    press: () {
                      // Navigate to settings page
                    },
                  ),
                  
                  const SizedBox(height: 24),

                  // Logout button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await userProvider.logout();
                        // Navigate back to login
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed('/login');
                        }
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showPersonalInfo(BuildContext context, dynamic user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder:
                (_, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24.0),
                    children: [
                      // Handle bar for bottom sheet
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      const SizedBox(height: 24),

                      InfoItem(title: 'Name', value: user.nom),
                      InfoItem(title: 'Email', value: user.email),
                      InfoItem(
                        title: 'Birth Date',
                        value:
                            user.dob != null
                                ? '${user.dob.day}/${user.dob.month}/${user.dob.year}'
                                : 'Not provided',
                      ),
                      InfoItem(
                        title: 'Gender',
                        value: user.sexe ?? 'Not provided',
                      ),
                      InfoItem(
                        title: 'Height',
                        value:
                            user.taille != null
                                ? '${user.taille} cm'
                                : 'Not provided',
                      ),
                      InfoItem(
                        title: 'Weight',
                        value:
                            user.poids != null
                                ? '${user.poids} kg'
                                : 'Not provided',
                      ),
                      InfoItem(
                        title: 'Activity Level',
                        value: user.etatActivite ?? 'Not provided',
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Health Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      const SizedBox(height: 8),

                      InfoItem(
                        title: 'Allergies',
                        value:
                            user.allergies.isEmpty
                                ? 'None'
                                : user.allergies.join(', '),
                      ),
                      InfoItem(
                        title: 'Medical Conditions',
                        value:
                            user.maladies.isEmpty
                                ? 'None'
                                : user.maladies.join(', '),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const InfoItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey[300]),
        ],
      ),
    );
  }
}
/*
class ProfilePic extends StatelessWidget {
  const ProfilePic({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green[700]!, width: 2),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                // If you have a profile image from the user data, use it here
                // Otherwise use a placeholder or default image
                backgroundImage: const AssetImage('assets/images/profile.png'),
                // If you don't have the image asset, use an icon instead:
                // child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            Positioned(
              right: -8,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  // Add functionality to change profile picture
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Change profile picture feature coming soon',
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[100]!, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

class ProfilePic extends StatelessWidget {
  const ProfilePic({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the user provider to get the current user's gender
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    // Determine which profile image to use based on gender
    String profileImagePath = 'assets/images/profile.png'; // Default image

    if (user != null && user.sexe != null) {
      if (user.sexe != null && (user.sexe!.toLowerCase() == 'female' ||
          user.sexe!.toLowerCase() == 'f') || user.sexe!.toLowerCase() == 'F') {
        profileImagePath = 'assets/images/profile_female.png';
      } else if (user.sexe != null &&
          (user.sexe!.toLowerCase() == 'male' ||
              user.sexe!.toLowerCase() == 'm')) {
        profileImagePath = 'assets/images/profile_male.png';
      }
    }

    return Center(
      child: SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green[700]!, width: 2),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                // Use the gender-specific profile image
                backgroundImage: AssetImage(profileImagePath),
                /*
                // Fallback to an icon if the image fails to load
                onBackgroundImageError: (_, __) {
                  return const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  );
                },
                 */
              ),
            ),
            Positioned(
              right: -8,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  // Add functionality to change profile picture
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Change profile picture feature coming soon',
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[100]!, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    required this.icon,
    this.press,
  });

  final String text;
  final IconData icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green[700], size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
          ],
        ),
      ),
    );
  }
}
