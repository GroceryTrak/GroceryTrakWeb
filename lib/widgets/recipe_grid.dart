import 'dart:math';

import 'package:flutter/material.dart';

import '../models/recipe_model.dart';
import '../widgets/recipe_details_page.dart';

Color getRandomColor() {
  return Color.fromRGBO(
    Random().nextInt(256), // Red
    Random().nextInt(256), // Green
    Random().nextInt(256), // Blue
    0.3, // Opacity
  );
}

class RecipeGrid extends StatelessWidget {
  final List<RecipeModel> recipes;

  const RecipeGrid({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title for the grid.
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Recommended Recipes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 210,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.6,
            ),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Container(
                decoration: BoxDecoration(
                  color: getRandomColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // This ensures children are centered horizontally.
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Display the imageLink if available; fall back to icon if not.
                    if (recipe.imageLink.isNotEmpty)
                      Image.network(
                        recipe.imageLink,
                        height: 70,
                        fit: BoxFit.cover,
                      )
                    else
                      const Icon(
                        Icons.restaurant_menu,
                        size: 70,
                        color: Colors.grey,
                      ),

                    // Center the recipe name text
                    Text(
                      recipe.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),

                    // Center the difficulty/duration/kcal text
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${recipe.difficulty} | ${recipe.duration} mins | ${recipe.kcal} kCal',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xff7B6B72),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    // "View" button
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailsPage(recipe: recipe),
                          ),
                        );
                      },
                      child: Container(
                        height: 45,
                        width: 130,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff9DCEFF), Color(0xff92A3FD)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            'View',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
