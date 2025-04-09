import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../screens/camera_screen.dart';
import '../screens/grocery.dart';
import '../screens/profile.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final CameraDescription? camera;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.camera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define navigation items
    final List<BottomNavigationBarItem> navigationItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.shopping_basket),
        label: 'Grocery',
      ),
      if (camera != null)
        const BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Camera',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: Colors.green,
      items: navigationItems,
      onTap: (index) {
        // Handle grocery navigation
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GroceryPage()),
          );
          return;
        }

        // Handle camera navigation
        if (camera != null && index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CameraScreen(camera: camera!)),
          );
          return;
        }

        // Handle profile navigation
        // If camera is not available, profile is at index 2
        // If camera is available, profile is at index 3
        final isProfileTab = camera != null ? index == 3 : index == 2;
        
        if (isProfileTab) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
          return;
        }

        // Handle home navigation
        onItemTapped(index);
      },
    );
  }
}
