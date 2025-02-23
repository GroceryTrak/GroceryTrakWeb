// import 'package:flutter/material.dart';
// import 'package:grocery_trak_web/models/item_model.dart';
// import 'package:grocery_trak_web/services/item_api_service.dart';

// class IngredientModel {
//   String name;
//   String iconPath;
//   Color boxColor;

//   IngredientModel({
//     required this.name,
//     required this.iconPath,
//     required this.boxColor,
//   });

//   // Updated method that fetches items asynchronously and converts them to IngredientModel instances.
//   static Future<List<IngredientModel>> getItems() async {
//     List<ItemModel> items = [];
//     try {
//       // Using the API service to fetch recipes.
//       // Adjust the query string as needed.
//       // String query = "Chicken&ingredients=2,3";
//       items = await ItemApiService.searchItems(query);
//     } catch (e) {
//       print("Error fetching recipes: $e");
//       items = []; // Fallback to an empty list on error.
//     }

//     // Convert ItemModel objects to IngredientModel objects.
//     // Modify this mapping based on the actual fields available in ItemModel.
//     List<IngredientModel> ingredients = items.map((item) {
//       return IngredientModel(
//         name: item.name,
//         // Here we assign a default color; customize if needed.
//         boxColor: Colors.green,
//       );
//     }).toList();

//     return ingredients;
//   }
// }
