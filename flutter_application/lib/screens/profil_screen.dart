import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Matching background color
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Consistent padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfilePic(),
              const SizedBox(height: 24), // Consistent spacing
              ProfileMenu(
                text: "Personal information",
                icon: Icons.person, // Matches "Personal information"
                press: () {},
              ),
              const SizedBox(height: 12),
              ProfileMenu(
                text: "Objective",
                icon: Icons.flag, // Represents goals or objectives
                press: () {},
              ),
              const SizedBox(height: 12),
              ProfileMenu(
                text: "My favorites",
                icon: Icons.favorite, // Matches "favorites"
                press: () {},
              ),
              const SizedBox(height: 12),
              ProfileMenu(
                text: "Settings",
                icon: Icons.settings, // Matches "Settings"
                press: () {},
              ),
              const SizedBox(height: 12),
              ProfileMenu(
                text: "Help Center",
                icon: Icons.help, // Matches "Help Center"
                press: () {},
              ),
            ],
          ),
        ),
      ),
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
                border: Border.all(color: Colors.green[700]!, width: 2), // Added green border
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profil.png'), 
              ),

            ),
            Positioned(
              right: -8,
              bottom: 0,
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
  final IconData icon; // Changed to IconData for Material icons
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
            Icon(
              icon,
              color: Colors.green[700],
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
