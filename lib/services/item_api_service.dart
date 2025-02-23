import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grocery_trak_web/models/item_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';


class ItemApiService {
  // Update baseUrl to match your backend API URL.
  static const String baseUrl = "https://backend.grocerytrak.com";

  /// Fetches a item by its ID.
  static Future<ItemModel> fetchItemById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/item/$id'));
    print(response);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ItemModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load item');
    }

  }

  /// Searches items by name using a query parameter.
  static Future<List<ItemModel>> searchItems(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/item/search?q=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => ItemModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to search items');
    }
  }

  /// Creates a new item.
  static Future<ItemModel> createItem(ItemModel item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/item'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return ItemModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to create item');
    }
  }

  /// Updates an existing item.
  static Future<ItemModel> updateItem(int id, ItemModel item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/item/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ItemModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to update item');
    }
  }

  /// Deletes a item by ID.
  static Future<void> deleteItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/item/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete item');
    }
  }
  
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://backend.grocerytrak.com",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  /// Predict item by sending an image file (for mobile).
  static Future<ItemModel> predictItem(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
      });
      Response response = await _dio.post(
        '/item/predict',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ItemModel.fromJson(response.data);
      } else {
        throw Exception('Failed to predict item (Status: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint("Error in predictItem: $e");
      throw Exception('Failed to predict item');
    }
  }

  /// Predict item by sending image bytes (for web).
  static Future<ItemModel> predictItemFromBytes(Uint8List imageBytes, String fileName) async {
    // print("Image Byte: $imageBytes");
    // fileName = "image.png";
    // print("Filename: $fileName");
    try {
      FormData formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          imageBytes,
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
        '/item/predict',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ItemModel.fromJson(response.data);
      } else {
        throw Exception('Failed to predict item (Status: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint("Error in predictItemFromBytes: $e");
      throw Exception('Failed to predict item');
    }
  }
}
