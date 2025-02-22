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
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  // You can add a background color if needed
                  // color: Colors.grey.withOpacity(0.3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        // If you have an icon or image associated with the item, you can display it here.
                        // For example, if you add an iconPath field to your nested item model:
                        // child: SvgPicture.asset(userItem.item.iconPath),
                        // Otherwise, you might want to show a placeholder:
                        // child: SvgPicture.asset('assets/icons/placeholder.svg'),
                      ),
                    ),
                    Text(
                      userItem.item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
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
