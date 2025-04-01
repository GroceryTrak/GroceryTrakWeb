import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_trak_web/services/auth_service.dart';

import '../screens/camera_screen.dart';
import '../screens/profile.dart';

AppBar buildAppBar(BuildContext context, CameraDescription? camera) {
  Future<void> handleSignOut() async {
    try {
      await AuthService.logout();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    }
  }

  return AppBar(
    backgroundColor: Colors.green,
    title: const Text('Grocery Trak'),
    leading: Container(
      margin: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset('assets/icons/Arrow - Left 2.svg'),
    ),
    actions: [
      PopupMenuButton<int>(
        itemBuilder: (context) => [
          if (camera != null)  // Only show camera option if camera is available
            const PopupMenuItem(
              value: 1,
              child: Row(children: [Icon(Icons.camera), SizedBox(width: 10), Text("Scan")]),
            ),
          const PopupMenuItem(
            value: 2,
            child: Row(children: [Icon(Icons.star), SizedBox(width: 10), Text("Profile")]),
          ),
          const PopupMenuItem(
            value: 3,
            child: Row(children: [Icon(Icons.logout), SizedBox(width: 10), Text("Sign Out")]),
          ),
        ],
        onSelected: (value) {
          if (value == 1 && camera != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(camera: camera)));
          } else if (value == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
          } else if (value == 3) {
            handleSignOut();
          }
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          width: 37,
          decoration: BoxDecoration(color: Colors.amber[100], borderRadius: BorderRadius.circular(10)),
          child: SvgPicture.asset('assets/icons/dots.svg', height: 5, width: 5),
        ),
      )
    ],
  );
}
