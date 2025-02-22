import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:grocery_trak_web/models/recipe_item.dart';
import 'package:grocery_trak_web/services/item_api_service.dart';
import 'widgets/app_bar.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/search_field.dart';
import 'widgets/ingredients_list.dart';
import 'widgets/recipe_grid.dart';
import 'models/recipe_model.dart';
import 'services/recipe_api_service.dart'; // Import the API service

class MyHomePage extends StatefulWidget {
  final String title;
  final CameraDescription camera;

  MyHomePage({super.key, required this.title, required this.camera});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<ItemModel> ingredients = [];
  List<RecipeModel> recipes = [];
  bool _isLoading = true; // Flag to show loading indicator

  @override
  void initState() {
    super.initState();
    _generateInfo();
  }

  // Asynchronously fetch recipes and ingredients from the backend API.
  Future<void> _generateInfo() async {
    String queryItem = "Chicken";
    try {
      // Await the Future<List<ItemModel>> returned from the API service.
      ingredients = await ItemApiService.searchItems(queryItem);
    } catch (e) {
      print("Error fetching ingredients: $e");
      ingredients = []; // Fallback to an empty list on error.
    }

    try {
      // Using the API service to fetch recipes.
      String query = "Chicken&ingredients=2,7";
      recipes = await RecipeApiService.searchRecipes(query);
    } catch (e) {
      print("Error fetching recipes: $e");
      recipes = []; // Fallback to an empty list on error.
    }

    // Update UI state to reflect that data has been loaded.
    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, widget.camera),
      body: _isLoading 
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchField(),
                  SizedBox(height: 40),
                  IngredientsList(ingredients: ingredients),
                  SizedBox(height: 40),
                  RecipeGrid(recipes: recipes),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        camera: widget.camera,
      ),
    );
  }
}
