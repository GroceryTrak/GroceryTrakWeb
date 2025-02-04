import 'package:flutter/material.dart';

class IngredientModel {
  String name;
  String iconPath;
  Color boxColor;

  IngredientModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });

  static List<IngredientModel> getRecipes()
  {
    List<IngredientModel> recipes = [];

    recipes.add(
      IngredientModel(name: 'Orange', iconPath: 'assets/icons/orange-snacks.svg', boxColor: Colors.orange)
    );

    recipes.add(
      IngredientModel(name: 'Pie', iconPath: 'assets/icons/pie.svg', boxColor: Colors.blue)
    );

    recipes.add(
      IngredientModel(name: 'Salad', iconPath: 'assets/icons/plate.svg', boxColor: Colors.green)
    );

    return recipes;
  }
}