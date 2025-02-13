import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:camera/camera.dart';
import '../screens/camera_screen.dart';
import '../screens/profile.dart';

AppBar buildAppBar(BuildContext context, CameraDescription camera) {
  return AppBar(
    backgroundColor: Colors.green,
    title: Text('Grocery Trak'),
    leading: Container(
      margin: EdgeInsets.all(10),
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
          PopupMenuItem(
            value: 1,
            child: Row(children: [Icon(Icons.camera), SizedBox(width: 10), Text("Scan")]),
          ),
          PopupMenuItem(
            value: 2,
            child: Row(children: [Icon(Icons.star), SizedBox(width: 10), Text("Profile")]),
          ),
          PopupMenuItem(
            value: 3,
            child: Row(children: [Icon(Icons.chrome_reader_mode), SizedBox(width: 10), Text("Sign Out")]),
          ),
        ],
        onSelected: (value) {
          if (value == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(camera: camera)));
          } else if (value == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
          }
        },
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          width: 37,
          decoration: BoxDecoration(color: Colors.amber[100], borderRadius: BorderRadius.circular(10)),
          child: SvgPicture.asset('assets/icons/dots.svg', height: 5, width: 5),
        ),
      )
    ],
  );
}
