import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

// Ensure you have this function implemented, for example:
Future<String?> loadUsername() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    final loadedUsername = await loadUsername();
    setState(() {
      username = loadedUsername;
    });
  }

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
                    // Uncomment and add your profile image asset if available:
                    // backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    username ?? 'John Doe',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                  const Divider(),
                  _buildOption(
                    context,
                    icon: Icons.logout,
                    title: 'Sign Out',
                    onTap: () {
                      // Add any additional sign-out logic before navigation if needed.
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
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

  /// Helper widget to build a profile option tile.
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
