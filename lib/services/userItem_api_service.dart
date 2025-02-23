import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:grocery_trak_web/models/userItem_model.dart';

class UserItemApiService {
  static const String _baseUrl = 'https://backend.grocerytrak.com';

  // Create an instance of FlutterSecureStorage
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  get itemModel => null;

  // Helper method to retrieve headers with the latest token.
  static Future<Map<String, String>> _getHeaders() async {
    String? token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// GET /user_item/{id}
  /// Fetches a user item by its ID.
  static Future<UserItemModel> fetchUserItemById(int id) async {
    final url = Uri.parse('$_baseUrl/user_item/$id');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserItemModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch user item with id $id');
    }
  }

  /// POST /user_item
  /// Creates a new user item.
  static Future<UserItemModel> createUserItem(UserItemModel userItem) async {
    final url = Uri.parse('$_baseUrl/user_item');
    final headers = await _getHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(userItem.toJson()),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return UserItemModel.fromJson(data);
    } else {
      throw Exception('Failed to create new user item');
    }
  }

  /// PUT /user_item/{id}
  /// Updates an existing user item.
  static Future<UserItemModel> updateUserItem(int id, UserItemModel userItem) async {
    final url = Uri.parse('$_baseUrl/user_item/$id');
    final headers = await _getHeaders();
    final response = await http.put(
      url,
      headers: headers,
      body: json.encode(userItem.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserItemModel.fromJson(data);
    } else {
      throw Exception('Failed to update user item with id $id');
    }
  }

  /// DELETE /user_item/{id}
  /// Deletes a user item.
  static Future<void> deleteUserItem(int id) async {
    final url = Uri.parse('$_baseUrl/user_item/$id');
    final headers = await _getHeaders();
    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user item with id $id');
    }
  }


  /// GET /user_item/
  /// Fetches all user items.
  static Future<List<UserItemModel>> retrieveUserItems() async {
    final url = Uri.parse('$_baseUrl/user_item/');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserItemModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch user items');
    }
  }

}
