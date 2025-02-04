import 'package:flutter/material.dart';

class RecipeModel {
  String name;
  String iconPath;
  Color boxColor;
  String difficulty;
  String duration;
  String kCal;


  RecipeModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
    required this.difficulty,
    required this.duration,
    required this.kCal,
  });

  static List<RecipeModel> getRecipes()
  {
    List<RecipeModel> recipes = [];

    recipes.add(
      RecipeModel(name: 'Blueberry Pancake', iconPath: 'assets/icons/blueberry-pancake.svg', boxColor: Colors.orange, difficulty: 'Easy', duration: '15', kCal: '180')
    );

    recipes.add(
      RecipeModel(name: 'Salmon Nigiri', iconPath: 'assets/icons/salmon-nigiri.svg', boxColor: Colors.red, difficulty: 'Hard', duration: '30', kCal: '150')
    );

    recipes.add(
      RecipeModel(name: 'Canai Bread', iconPath: 'assets/icons/canai-bread.svg', boxColor: Colors.blue, difficulty: 'Medium', duration: '35', kCal: '190')
    );

    recipes.add(
      RecipeModel(name: 'Honey Pancake', iconPath: 'assets/icons/honey-pancakes.svg', boxColor: Colors.green, difficulty: 'Easy', duration: '10', kCal: '200')
    );

    recipes.add(
      RecipeModel(name: 'Honey Pancake', iconPath: 'assets/icons/honey-pancakes.svg', boxColor: Colors.green, difficulty: 'Easy', duration: '10', kCal: '200')
    );

    recipes.add(
      RecipeModel(name: 'Honey Pancake', iconPath: 'assets/icons/honey-pancakes.svg', boxColor: Colors.green, difficulty: 'Easy', duration: '10', kCal: '200')
    );

    recipes.add(
      RecipeModel(name: 'Honey Pancake', iconPath: 'assets/icons/honey-pancakes.svg', boxColor: Colors.green, difficulty: 'Easy', duration: '10', kCal: '200')
    );

    recipes.add(
      RecipeModel(name: 'Honey Pancake', iconPath: 'assets/icons/honey-pancakes.svg', boxColor: Colors.green, difficulty: 'Easy', duration: '10', kCal: '200')
    );

    return recipes;
  }
  
}