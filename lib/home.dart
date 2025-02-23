import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:grocery_trak_web/main.dart';
import 'package:grocery_trak_web/models/userItem_model.dart';
import 'package:grocery_trak_web/screens/camera_screen.dart';
import 'package:grocery_trak_web/services/userItem_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/app_bar.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/multi_search.dart';
import 'widgets/ingredients_list.dart';
import 'widgets/recipe_grid.dart';
import 'models/recipe_model.dart';
import 'services/recipe_api_service.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final CameraDescription camera;

  MyHomePage({super.key, required this.title, required this.camera});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<UserItemModel> _allIngredients = [];
  List<UserItemModel> ingredients = [];
  List<RecipeModel> recipes = [];
  bool _isLoading = true;

  // New state variable to hold the captured selection for the multi search bar
  List<String> capturedSelection = [];

  @override
  void initState() {
    super.initState();
    _generateInfo();
  }
  
  Future<void> _generateInfo() async {
    // Load all ingredients once
    try {
      _allIngredients = await UserItemApiService.retrieveUserItems();
      ingredients = [];
    } catch (e) {
      print("Error fetching ingredients: $e");
      _allIngredients = [];
      ingredients = [];
    }

    // Load default recipes (change this default query as needed)
    try {
      String query = "ingredients=";
      recipes = await RecipeApiService.searchRecipes(query);
    } catch (e) {
      print("Error fetching recipes: $e");
      recipes = [];
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Callback from the multi-select widget.
  Future<void> _searchRecipes(String query) async {
    setState(() {
      _isLoading = true;
    });

    // Extract the ingredient IDs from the query string.
    String idsStr = query.replaceFirst("ingredients=", "").replaceFirst("&", "");
    List<String> selectedIds =
        idsStr.split(',').where((id) => id.trim().isNotEmpty).toList();
    print("Selected ingredient IDs: $selectedIds");

    // Filter the full ingredients list based on the selected IDs.
    ingredients = _allIngredients.where((ingredient) {
      return selectedIds.contains(ingredient.itemId.toString());
    }).toList();

    try {
      recipes = await RecipeApiService.searchRecipes(query);
    } catch (e) {
      print("Error searching recipes: $e");
      recipes = [];
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) async {
    if (index == 2) {
      // Push the camera screen and wait for the captured result.
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(camera: widget.camera),
        ),
      );

      if (result != null) {
        // Expecting the result to be a UserItemModel.
        UserItemModel capturedItem = result as UserItemModel;
        // Update the multi search selection with the captured item's display string.
        setState(() {
          capturedSelection = ['${capturedItem.item.name} (${capturedItem.itemId})'];
        });
        // Automatically search recipes based on the captured item.
        _searchRecipes("&ingredients=${capturedItem.itemId}");
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
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
                  MultiSelectSearchBar(
                    onSelectionDone: _searchRecipes,
                    initialSelection: capturedSelection,
                  ),
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
