import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:grocery_trak_web/main.dart';
import 'package:grocery_trak_web/models/userItem_model.dart';
import 'package:grocery_trak_web/services/userItem_api_service.dart';

import 'models/recipe_model.dart';
import 'services/recipe_api_service.dart';
import 'widgets/app_bar.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/ingredients_list.dart';
import 'widgets/multi_search.dart';
import 'widgets/recipe_grid.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final CameraDescription? camera;

  MyHomePage({super.key, required this.title, this.camera});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with RouteAware {

  int _selectedIndex = 0;
  List<UserItemModel> _allIngredients = [];
  List<UserItemModel> ingredients = [];
  List<RecipeModel> recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when the current route is re-displayed after popping another route.
    _generateInfo();
  }
  
  Future<void> _generateInfo() async {
    // Load all ingredients once
    try {
      _allIngredients = await UserItemApiService.retrieveUserItems();
      // Initially, you may want to show no ingredients or all ingredients.
      // For this example, we'll start with an empty list until a selection is made.
      ingredients = [];
    } catch (e) {
      print("Error fetching ingredients: $e");
      _allIngredients = [];
      ingredients = [];
    }

    // Load default recipes (you might change this default query as needed)
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

  // This callback is triggered by the multi-select widget after the user taps "OK".
  // The query string is expected in the format "ingredients=2,3"
  Future<void> _searchRecipes(String query) async {
    setState(() {
      _isLoading = true;
    });

    // Extract the ingredient IDs from the query string.
    String idsStr = query.replaceFirst("ingredients=", "");
    List<String> selectedIds =
        idsStr.split(',').where((id) => id.trim().isNotEmpty).toList();
    print("Selected ingredient IDs: $selectedIds");
    if (selectedIds.isNotEmpty) {
    selectedIds[0] = selectedIds[0].replaceAll("&", "");
    }
    print("Selected ingredient IDs: $selectedIds");

    // Filter the full ingredients list based on the selected IDs.
    ingredients = _allIngredients.where((ingredient) {
      // Assuming ingredient.itemId is a numeric value or a string.
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
                  // The multi-select search bar will call _searchRecipes when selections are made.
                  MultiSelectSearchBar(onSelectionDone: _searchRecipes),
                  SizedBox(height: 40),
                  // Display only the ingredients matching the selected options.
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
