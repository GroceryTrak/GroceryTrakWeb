import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grocery_trak_web/home.dart';
import 'package:grocery_trak_web/screens/login_screen.dart';
import 'package:grocery_trak_web/services/auth_service.dart';

// Global variable to hold available cameras.
List<CameraDescription>? cameras;
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  // flutter run --web-port=53459 -d chrome for .env.dev, flutter build web --release
  await dotenv.load(
    fileName: kReleaseMode ? '.env.prod' : '.env.dev',
  );
  WidgetsFlutterBinding.ensureInitialized();
  
  availableCameras().then((value) {
    cameras = value;
  }).catchError((e) {
    print('Camera initialization failed: $e');
    cameras = null;
  });
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'GroceryTrak',
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
                title: 'GroceryTrak',
                camera: cameras?.first,
              );
            }
            
            // If no valid token, show login screen
            return const LoginScreen();
          },
        ),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => MyHomePage(
          title: 'GroceryTrak',
          camera: cameras?.first,
        ),
      },
    );
  }
}
