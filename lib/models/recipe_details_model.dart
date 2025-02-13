import 'package:flutter/material.dart';
import '../services/recipe_api_service.dart';
import 'recipe_model.dart';

class RecipeDetailsModel extends ChangeNotifier {
  RecipeModel _recipe;
  bool isLoading = true;

  RecipeDetailsModel({required RecipeModel recipe}) : _recipe = recipe {
    // Fetch updated details from the API as soon as the model is created.
    fetchDetails();
  }

  // Getters for the recipe properties.
  RecipeModel get recipe => _recipe;
  int get id => _recipe.id;
  String get name => _recipe.name;
  String get instruction => _recipe.instruction;
  String get difficulty => _recipe.difficulty;
  int get duration => _recipe.duration;
  int get kcal => _recipe.kcal;
  String? get iconPath => _recipe.iconPath;
  List<RecipeItem> get ingredients => _recipe.ingredients;

  /// Fetches updated recipe details from the backend API.
  Future<void> fetchDetails() async {
    try {
      final updatedRecipe = await RecipeApiService.fetchRecipeById(_recipe.id);
      _recipe = updatedRecipe;
    } catch (e) {
      print("Error fetching recipe details: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Methods to update the recipe details using the copyWith method.
  void updateInstruction(String newInstruction) {
    _recipe = _recipe.copyWith(instruction: newInstruction);
    notifyListeners();
  }

  void updateIngredients(List<RecipeItem> newIngredients) {
    _recipe = _recipe.copyWith(ingredients: newIngredients);
    notifyListeners();
  }

  /// Simulates saving changes to the backend or local storage.
  Future<void> saveChanges() async {
    await Future.delayed(const Duration(seconds: 1));
    // Here you could integrate an API call to persist changes.
    notifyListeners();
  }
}
