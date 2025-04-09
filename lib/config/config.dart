import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get environment => dotenv.env['ENV'] ?? 'development';
  static String get backendUri => dotenv.env['BACKEND_URI'] ?? 'https://backend.grocerytrak.com';
}
