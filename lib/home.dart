import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'widgets/app_bar.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/search_field.dart';
import 'widgets/ingredients_list.dart';
import 'widgets/recipe_grid.dart';
import 'models/ingredient_model.dart';
import 'models/recipe_model.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final CameraDescription camera;

  MyHomePage({super.key, required this.title, required this.camera});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<IngredientModel> ingredients = [];
  List<RecipeModel> recipes = [];

  @override
  void initState() {
    super.initState();
    _generateInfo();
  }

  void _generateInfo() {
    ingredients = IngredientModel.getRecipes();
    recipes = RecipeModel.getRecipes();
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchField(),
            SizedBox(height: 40),
            IngredientsList(ingredients: ingredients),
            SizedBox(height: 40),
            RecipeGrid(recipes: recipes), // ✅ Recipe Grid now correctly included
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
