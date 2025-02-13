import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe_details_model.dart';
import '../models/recipe_model.dart';

class RecipeDetailsPage extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailsPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipeDetailsModel>(
      create: (_) => RecipeDetailsModel(recipe: recipe),
      child: Consumer<RecipeDetailsModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(model.name),
              backgroundColor: Colors.green,
            ),
            body: model.isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recipe Icon/Image (using asset; adjust if using network image)
                        // Center(
                        //   child: model.iconPath != null && model.iconPath!.isNotEmpty
                        //       ? Image.asset(
                        //           model.iconPath!,
                        //           height: 150,
                        //         )
                        //       : Icon(
                        //           Icons.restaurant_menu,
                        //           size: 150,
                        //           color: Colors.grey,
                        //         ),
                        // ),
                        const SizedBox(height: 16.0),
                        // Recipe Title
                        Text(
                          model.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        // Recipe stats: difficulty, duration, and kcal
                        Row(
                          children: [
                            Text(
                              model.difficulty,
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${model.duration} mins',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${model.kcal} kCal',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        // Instructions Section
                        const Text(
                          "Instructions",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          model.instruction.isNotEmpty
                              ? model.instruction
                              : "No instructions provided.",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24.0),
                        // Ingredients Section
                        const Text(
                          "Ingredients",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        ...model.ingredients.map((ingredient) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                ingredient.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            )),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
