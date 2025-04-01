import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../screens/camera_screen.dart';
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
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index == 1 && camera != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(camera: camera!)));
        } else if (index == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
        } else {
          onItemTapped(index);
        }
      },
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        if (camera != null)  // Only show camera tab if camera is available
          const BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Camera'),
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
