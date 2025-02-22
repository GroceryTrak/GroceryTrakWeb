import 'package:flutter/material.dart';
import 'package:grocery_trak_web/models/recipe_item.dart';
import 'package:flutter_svg/svg.dart';

class IngredientsList extends StatelessWidget {
  final List<ItemModel> ingredients;

  IngredientsList({required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            'Ingredient',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 25),
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  // color: ingredients[index].boxColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        // child: SvgPicture.asset(ingredients[index].iconPath),
                      ),
                    ),
                    Text(
                      ingredients[index].name,
                      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 14),
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
