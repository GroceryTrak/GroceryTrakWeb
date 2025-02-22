import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/recipe_model.dart';
import '../widgets/recipe_details_page.dart'; 
import 'dart:math';

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
        SizedBox(height: 15),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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
                  children: [
                    // Display the icon if available, otherwise show a placeholder icon.
                    recipe.iconPath != null && recipe.iconPath!.isNotEmpty
                        ? SvgPicture.asset(
                            recipe.iconPath!,
                            height: 70,
                          )
                        : Icon(
                            Icons.restaurant_menu,
                            size: 70,
                            color: Colors.grey,
                          ),
                    Text(
                      recipe.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${recipe.difficulty} | ${recipe.duration} mins | ${recipe.kcal} kCal',
                        style: TextStyle(
                          color: Color(0xff7B6B72),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // Wrap the View button with InkWell for tap detection.
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailsPage(recipe: recipe),
                          ),
                        );
                      },
                      child: Container(
                        height: 45,
                        width: 130,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff9DCEFF), Color(0xff92A3FD)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
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
