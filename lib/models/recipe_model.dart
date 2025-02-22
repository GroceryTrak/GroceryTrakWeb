import 'package:grocery_trak_web/models/recipe_item.dart';

class RecipeModel {
  final int id;
  final String name;
  final String instruction;
  final String difficulty;
  final int duration;
  final int kcal;
  final String? iconPath;
  List<ItemModel> ingredients;

  RecipeModel({
    required this.id, // id must remain required for consistency
    this.name = "Unknown Recipe",
    this.instruction = "",
    this.difficulty = "Unknown",
    this.duration = 0,
    this.kcal = 0,
    this.iconPath,
    List<ItemModel>? ingredients,
  }) : ingredients = ingredients ?? [];

  RecipeModel copyWith({
    int? id,
    String? name,
    String? instruction,
    String? difficulty,
    int? duration,
    int? kcal,
    String? iconPath,
    List<ItemModel>? ingredients,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      instruction: instruction ?? this.instruction,
      difficulty: difficulty ?? this.difficulty,
      duration: duration ?? this.duration,
      kcal: kcal ?? this.kcal,
      iconPath: iconPath ?? this.iconPath,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  // Factory constructor to create a RecipeModel from JSON.
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
  return RecipeModel(
    id: (json['id'] as int?) ?? 0,
    name: json['name'] as String? ?? "Unknown Recipe",
    instruction: json['instruction'] as String? ?? "",
    difficulty: json['difficulty'] as String? ?? "Unknown",
    duration: json['duration'] as int? ?? 0,
    kcal: json['kcal'] as int? ?? 0,
    iconPath: json['iconPath'] as String?,
    ingredients: (json['ingredients'] as List<dynamic>?)
            ?.map((ingredient) {
              // Extract the nested item
              final itemData = Map<String, dynamic>.from(ingredient['item']);
              // Add quantity and unit from the outer ingredient object
              itemData['quantity'] = ingredient['quantity'];
              itemData['unit'] = ingredient['unit'];
              return ItemModel.fromJson(itemData);
            })
            .toList() ??
        [],
  );
}


  // Converts a RecipeModel into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'instruction': instruction,
      'difficulty': difficulty,
      'duration': duration,
      'kcal': kcal,
      if (iconPath != null) 'iconPath': iconPath,
      'ingredients': ingredients.map((item) => item.toJson()).toList(),
    };
  }


}
