import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recipe_model.dart';

class RecipeApiService {
  // Update baseUrl to match your backend API URL.
  static const String baseUrl = "https://backend.grocerytrak.com";

  /// Fetches a recipe by its ID.
  static Future<RecipeModel> fetchRecipeById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/recipe/$id'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return RecipeModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load recipe');
    }
  }

  /// Searches recipes by name using a query parameter.
  static Future<List<RecipeModel>> searchRecipes(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recipe/search?q=$query'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> recipes = jsonData['recipes'] ?? [];
        return recipes.map((data) => RecipeModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to search recipes');
      }
    } catch (e) {
      return [];
    }
  }

  /// Creates a new recipe.
  static Future<RecipeModel> createRecipe(RecipeModel recipe) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recipe'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(recipe.toJson()),
    );
    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return RecipeModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to create recipe');
    }
  }

  /// Updates an existing recipe.
  static Future<RecipeModel> updateRecipe(int id, RecipeModel recipe) async {
    final response = await http.put(
      Uri.parse('$baseUrl/recipe/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(recipe.toJson()),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return RecipeModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to update recipe');
    }
  }

  /// Deletes a recipe by ID.
  static Future<void> deleteRecipe(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/recipe/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete recipe');
    }
  }
}
