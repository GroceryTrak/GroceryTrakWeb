import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Replace with your actual backend API base URL.
  final String baseUrl;

  AuthService({required this.baseUrl});

  /// Performs a login request with the provided email and password.
  /// Returns a map containing user data and token on success.
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {

      // Successful login returns user data and token.
      return {'token': response.body};
    } else {
      // You can customize error handling based on your API response.
      throw Exception('Failed to login: ${response.body}');
    }
  }

  /// Performs a sign up request with the provided name, email, and password.
  /// Returns a map containing the created user data on success.
  Future<String> signUp( String username, String password) async {
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
}
