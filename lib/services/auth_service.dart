import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Replace with your actual backend API base URL.
  final String baseUrl;
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  AuthService({required this.baseUrl});

  /// Performs a login request with the provided email and password.
  /// Returns a map containing user data and token on success.
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body as JSON
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        // Get the token directly from the response
        final token = responseData['token'];
        
        if (token == null) {
          throw Exception('No token found in response');
        }

        print('Successfully extracted token: ${token.substring(0, 20)}...');
        return {'token': token};
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  /// Performs a sign up request with the provided name, email, and password.
  /// Returns a map containing the created user data on success.
  Future<String> signUp(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    // Adjust accepted status codes according to your API, e.g., 201 for created.
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  /// Validates the current JWT token
  static Future<bool> validateToken() async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) return false;

      // Decode the token to check expiration
      final parts = token.split('.');
      if (parts.length != 3) return false;

      final payload = json.decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      final exp = payload['exp'] as int?;
      
      if (exp == null) return false;
      
      // Check if token is expired
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (now >= exp) {
        // Token is expired, remove it
        await _storage.delete(key: 'jwt_token');
        return false;
      }

      return true;
    } catch (e) {
      print('Token validation error: $e');
      return false;
    }
  }

  /// Logs out the user by removing the token
  static Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  /// Gets the current token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }
}
