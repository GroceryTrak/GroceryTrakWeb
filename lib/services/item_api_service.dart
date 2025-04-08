import 'dart:convert';

import 'package:grocery_trak_web/models/item_model.dart';
import 'package:http/http.dart' as http;



class ItemApiService {
  // Update baseUrl to match your backend API URL.
  static const String baseUrl = "https://backend.grocerytrak.com";

  /// Fetches a item by its ID.
  static Future<ItemModel> fetchItemById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/item/$id'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ItemModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load item');
    }
  }

  /// Searches items by name using a query parameter.
  static Future<List<ItemModel>> searchItems(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/item/search?q=$query'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> items = jsonData['items'] ?? [];
        return items.map((data) => ItemModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to search items');
      }
    } catch (e) {
      return [];
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
  
}
