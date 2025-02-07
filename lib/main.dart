import 'package:flutter/material.dart';
import 'package:grocery_trak_web/home.dart';
import 'package:camera/camera.dart';

// Global variable to hold available cameras.
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras(); // Camera variable
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery Trak',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: 'Grocery Trak',
        camera: cameras.first, // Pass the first available camera.
      ),
    );
  }
}
