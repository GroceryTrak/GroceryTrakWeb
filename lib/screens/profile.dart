import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  // You can later replace these with actual user data.
  final String userName = 'John Doe';
  final String userEmail = 'john.doe@example.com';
  // final String profileImagePath = 'assets/images/profile_placeholder.png'; // Ensure you add this asset to your pubspec.yaml

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              color: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 50,
                    // backgroundImage: AssetImage(profileImagePath),
                    // TODO; Add profile image path
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Profile Options List
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildOption(
                    context,
                    icon: Icons.history,
                    title: 'Cooking History',
                    onTap: () {
                      // TODO: Navigate to cooking history screen
                    },
                  ),
                  const Divider(),
                  _buildOption(
                    context,
                    icon: Icons.favorite,
                    title: 'Favorite Recipes',
                    onTap: () {
                      // TODO: Navigate to favorite recipes screen
                    },
                  ),
                  const Divider(),
                  _buildOption(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      // TODO: Navigate to settings screen
                    },
                  ),
                  const Divider(),
                  _buildOption(
                    context,
                    icon: Icons.logout,
                    title: 'Sign Out',
                    onTap: () {
                      // TODO: Handle sign out action
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A helper widget to build each profile option.
  Widget _buildOption(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
