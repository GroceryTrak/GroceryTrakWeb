import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_trak_web/models/userItem_model.dart';


class IngredientsList extends StatelessWidget {
  final List<UserItemModel> ingredients;

  const IngredientsList({Key? key, required this.ingredients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 30),
          child: Text(
            'Ingredients',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 25),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final userItem = ingredients[index];
              return Container(
              width: 100, // Adjust width to fit text properly
              padding: EdgeInsets.all(8), // Add padding for spacing
              decoration: BoxDecoration(
                color: Colors.grey.shade300, // Background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(userItem.item.imageLink),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 5), // Add spacing
                  Center( // Ensure text is centered
                    child: Text(
                      userItem.item.name,
                      textAlign: TextAlign.center, // Align text within its box
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
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
