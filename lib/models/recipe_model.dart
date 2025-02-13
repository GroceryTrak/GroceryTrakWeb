class RecipeItem {
  final int id;
  final String name;

  RecipeItem({
    required this.id,
    required this.name,
  });

  factory RecipeItem.fromJson(Map<String, dynamic> json) {
    return RecipeItem(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class RecipeModel {
  final int id;
  final String name;
  final String instruction; // Combines description and steps
  final String difficulty;
  final int duration;
  final int kcal;
  final String? iconPath; // Optional field for UI
  final List<RecipeItem> ingredients;

  RecipeModel({
    required this.id,
    required this.name,
    required this.instruction,
    required this.difficulty,
    required this.duration,
    required this.kcal,
    this.iconPath,
    required this.ingredients,
  });
  
  RecipeModel copyWith({
    String? instruction,
    List<RecipeItem>? ingredients,
  }) {
    return RecipeModel(
      id: id,
      name: name,
      instruction: instruction ?? this.instruction,
      difficulty: difficulty,
      duration: duration,
      kcal: kcal,
      iconPath: iconPath,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  // Factory constructor to create a RecipeModel from JSON.
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      instruction: json['instruction'] as String? ?? '',
      difficulty: json['difficulty'] as String,
      duration: json['duration'] as int,
      kcal: json['kcal'] as int,
      iconPath: json['iconPath'] as String?, // if provided locally
      ingredients: json['ingredients'] != null
          ? List<RecipeItem>.from(
              json['ingredients'].map((item) => RecipeItem.fromJson(item)))
          : [],
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

  // Mock data for testing
  static List<RecipeModel> getRecipes() {
    return [
      RecipeModel(
        id: 1,
        name: 'Spaghetti Bolognese',
        instruction:
            'Boil spaghetti according to package instructions. Sauté onions and garlic in olive oil. Add ground beef and cook until browned. Stir in tomato sauce and simmer. Serve sauce over spaghetti.',
        difficulty: 'Medium',
        duration: 45,
        kcal: 500,
        iconPath: 'assets/icons/pie.svg',
        ingredients: [
          RecipeItem(id: 1, name: 'Spaghetti'),
          RecipeItem(id: 2, name: 'Ground beef'),
          RecipeItem(id: 3, name: 'Tomato sauce'),
          RecipeItem(id: 4, name: 'Onions'),
          RecipeItem(id: 5, name: 'Garlic'),
          RecipeItem(id: 6, name: 'Olive oil'),
        ],
      ),
      RecipeModel(
        id: 2,
        name: 'Chicken Curry',
        instruction:
            'Marinate chicken in curry paste. Sauté onions and bell peppers. Add chicken and cook thoroughly. Pour coconut milk and simmer until thickened. Serve with rice.',
        difficulty: 'Hard',
        duration: 60,
        kcal: 600,
        iconPath: 'assets/icons/plate.svg',
        ingredients: [
          RecipeItem(id: 1, name: 'Chicken'),
          RecipeItem(id: 2, name: 'Curry paste'),
          RecipeItem(id: 3, name: 'Coconut milk'),
          RecipeItem(id: 4, name: 'Onions'),
          RecipeItem(id: 5, name: 'Bell peppers'),
        ],
      ),
      RecipeModel(
        id: 3,
        name: 'Caesar Salad',
        instruction:
            'Chop romaine lettuce. Mix with croutons and parmesan cheese. Drizzle with Caesar dressing and toss gently.',
        difficulty: 'Easy',
        duration: 20,
        kcal: 350,
        iconPath: 'assets/icons/orange-snacks.svg',
        ingredients: [
          RecipeItem(id: 1, name: 'Romaine lettuce'),
          RecipeItem(id: 2, name: 'Croutons'),
          RecipeItem(id: 3, name: 'Parmesan cheese'),
          RecipeItem(id: 4, name: 'Caesar dressing'),
        ],
      ),
    ];
  }
}
