import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery_trak_web/config/config.dart';
import 'package:grocery_trak_web/models/userItem_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UserItemApiService {
  static String get _baseUrl => Config.backendUri;

  // Create an instance of FlutterSecureStorage
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  get itemModel => null;

  // Helper method to retrieve headers with the latest token.
  static Future<Map<String, String>> _getHeaders() async {
    String? token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      throw Exception('No authentication token found');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// GET /user_item/{id}
  /// Fetches a user item by its ID.
  static Future<UserItemModel> fetchUserItemById(int id) async {
    try {
      final url = Uri.parse('$_baseUrl/user_item/$id');
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserItemModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access. Please log in again.');
      } else {
        throw Exception('Failed to fetch user item with id $id');
      }
    } catch (e) {
      print('Error in fetchUserItemById: $e');
      rethrow;
    }
  }

  /// POST /user_item
  /// Creates a new user item.
  static Future<UserItemModel> createUserItem(UserItemModel userItem) async {
    try {
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
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access. Please log in again.');
      } else {
        throw Exception('Failed to create new user item');
      }
    } catch (e) {
      print('Error in createUserItem: $e');
      rethrow;
    }
  }

  /// PUT /user_item/{id}
  /// Updates an existing user item.
  static Future<UserItemModel> updateUserItem(int id, UserItemModel userItem) async {
    try {
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
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access. Please log in again.');
      } else {
        throw Exception('Failed to update user item with id $id');
      }
    } catch (e) {
      print('Error in updateUserItem: $e');
      rethrow;
    }
  }

  /// DELETE /user_item/{id}
  /// Deletes a user item.
  static Future<void> deleteUserItem(int id) async {
    try {
      final url = Uri.parse('$_baseUrl/user_item/$id');
      final headers = await _getHeaders();
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access. Please log in again.');
      } else {
        throw Exception('Failed to delete user item with id $id');
      }
    } catch (e) {
      print('Error in deleteUserItem: $e');
      rethrow;
    }
  }

  /// GET /user_item/
  /// Fetches all user items.
  static Future<List<UserItemModel>> retrieveUserItems() async {
    try {
      final url = Uri.parse('$_baseUrl/user_item/');
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Print the raw response for debugging
        print('Response body: ${response.body}');
        
        // Try to decode the response body
        final dynamic decodedResponse = json.decode(response.body);
        
        // Handle different response formats
        List<dynamic> userItemsList;
        
        if (decodedResponse is Map<String, dynamic>) {
          // If response is a map with 'user_items' key
          userItemsList = decodedResponse['user_items'] ?? [];
        } else if (decodedResponse is List) {
          // If response is directly a list
          userItemsList = decodedResponse;
        } else {
          print('Unexpected response format: $decodedResponse');
          return [];
        }
        
        // Convert each item in the list to UserItemModel
        return userItemsList.map((json) => UserItemModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        print('Unauthorized access. Token: ${headers['Authorization']}');
        throw Exception('Unauthorized access. Please log in again.');
      } else {
        print('Failed to fetch user items. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error in retrieveUserItems: $e');
      rethrow;
    }
  }

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Config.backendUri,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  /// Predict item by sending an image file (for mobile).
  static Future<UserItemModel> predictItem(File imageFile) async {
    try {
      final headers = await _getHeaders();
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ));

      Response response = await _dio.post(
        '/user_item/predict',
        data: formData,
        options: Options(
          headers: headers,
          contentType: 'multipart/form-data',
        ),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserItemModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access. Please log in again.');
      } else {
        throw Exception('Failed to predict item (Status: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint("Error in predictItem: $e");
      rethrow;
    }
  }

  // /// Predict item by sending image bytes (for web).
  // static Future<ItemModel> predictItemFromBytes(Uint8List imageBytes, String fileName) async {
  //   // print("Image Byte: $imageBytes");
  //   // fileName = "image.png";
  //   // print("Filename: $fileName");
  //   try {
  //     FormData formData = FormData.fromMap({
  //       'image': MultipartFile.fromBytes(
  //         imageBytes,
  //         filename: fileName,
  //         contentType: MediaType('image', 'jpeg'),
  //       ),
  //     });

  //     Response response = await _dio.post(
  //       '/item/predict',
  //       data: formData,
  //       options: Options(contentType: 'multipart/form-data'),
  //     );
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return ItemModel.fromJson(response.data);
  //     } else {
  //       throw Exception('Failed to predict item (Status: ${response.statusCode})');
  //     }
  //   } catch (e) {
  //     debugPrint("Error in predictItemFromBytes: $e");
  //     throw Exception('Failed to predict item');
  //   }
  // }

}
