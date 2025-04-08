import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery_trak_web/home.dart';
import 'package:grocery_trak_web/screens/login_screen.dart';
import 'package:grocery_trak_web/services/auth_service.dart';

// Global variable to hold available cameras.
List<CameraDescription>? cameras;
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final FlutterSecureStorage _storage = FlutterSecureStorage();

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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'Grocery Trak',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<bool>(
          future: AuthService.validateToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            
            // If token is valid, user is logged in
            if (snapshot.hasData && snapshot.data == true) {
              return MyHomePage(
                title: 'Grocery Trak',
                camera: cameras?.first,
              );
            }
            
            // If no valid token, show login screen
            return const LoginScreen();
          },
        ),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => MyHomePage(
          title: 'Grocery Trak',
          camera: cameras?.first,
        ),
      },
    );
  }
}
