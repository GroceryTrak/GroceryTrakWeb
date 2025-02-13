import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/recipe_model.dart';

class RecipeDetailsPage extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailsPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Icon/Image
            Center(
              child: SvgPicture.asset(
                recipe.iconPath,
                height: 150,
              ),
            ),
            const SizedBox(height: 16.0),
            // Recipe Title
            Text(
              recipe.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            // Recipe stats: difficulty, duration, and kCal
            Row(
              children: [
                Text(
                  recipe.difficulty,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Text(
                  '${recipe.duration} mins',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Text(
                  '${recipe.kCal} kCal',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            // Recipe Description Section
            const Text(
              "Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              "This recipe is a delightful dish that blends flavors perfectly. "
              "Add your favorite ingredients and adjust the spices to taste. "
              "You can include detailed instructions, cooking tips, and personal notes here.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24.0),
            // Ingredients Section
            const Text(
              "Ingredients",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ..._buildIngredientsList(),
            const SizedBox(height: 24.0),
            // Cooking Steps Section
            const Text(
              "Cooking Steps",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ..._buildCookingSteps(),
          ],
        ),
      ),
    );
  }

  /// Returns a list of placeholder widgets for the ingredients.
  List<Widget> _buildIngredientsList() {
    // Replace with actual data from recipe if available.
    List<String> ingredients = [
      "1 cup of ingredient A",
      "2 tbsp of ingredient B",
      "Salt to taste",
      "Pepper to taste",
    ];

    return ingredients.map((ingredient) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          ingredient,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }).toList();
  }

  /// Returns a list of placeholder widgets for the cooking steps.
  List<Widget> _buildCookingSteps() {
    // Replace with actual steps from recipe if available.
    List<String> steps = [
      "Preheat your oven to 350°F.",
      "Mix ingredient A and B in a bowl.",
      "Season with salt and pepper.",
      "Bake for 20 minutes.",
    ];

    return steps.map((step) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          step,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }).toList();
  }
}
