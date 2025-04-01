import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:grocery_trak_web/home.dart';

// Global variable to hold available cameras.
List<CameraDescription>? cameras;
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    cameras = await availableCameras();
  } catch (e) {
    print('Camera initialization failed: $e');
    cameras = null;
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'Grocery Trak',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: 'Grocery Trak',
        camera: cameras?.first, // Pass the first available camera if any.
      ),
    );
  }
}
