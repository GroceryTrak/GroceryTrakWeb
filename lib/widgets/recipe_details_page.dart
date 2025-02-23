import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../models/recipe_details_model.dart';
import '../models/recipe_model.dart';

Color getRandomPastelColor() {
  final random = Random();
  final hue = random.nextDouble() * 360;
  final saturation = 0.4 + random.nextDouble() * 0.3; 
  final value = 0.8 + random.nextDouble() * 0.2;
  return HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
}

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
            backgroundColor: Colors.grey[100],
            body: model.isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    slivers: [
                      /// 1. A SliverAppBar with a large top image
                      SliverAppBar(
                        expandedHeight: 300,
                        pinned: true,
                        floating: false,
                        backgroundColor: Colors.green,
                        title: Text(model.name),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Top "hero" image or fallback
                              model.imageLink != null && model.imageLink!.isNotEmpty
                                  ? Image.network(
                                      model.imageLink!,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(color: Colors.grey[300]),
                              // A gradient overlay to darken the top for text contrast
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.4),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// 2. Main content in a container with random pastel background
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: getRandomPastelColor(),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// 2.1 Recipe Title
                              Text(
                                model.name,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),

                              /// 2.2 Recipe stats: difficulty, duration, kcal
                              Row(
                                children: [
                                  _StatChip(label: model.difficulty),
                                  const SizedBox(width: 8),
                                  _StatChip(label: '${model.duration} mins'),
                                  const SizedBox(width: 8),
                                  _StatChip(label: '${model.kcal} kCal'),
                                ],
                              ),
                              const SizedBox(height: 24.0),

                              /// 2.3 Instructions Section
                              const Text(
                                "Instructions",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  model.instruction.isNotEmpty
                                      ? model.instruction
                                      : "No instructions provided.",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 24.0),

                              /// 2.4 Ingredients Section
                              const Text(
                                "Ingredients",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: model.ingredients.isNotEmpty
                                      ? model.ingredients.map((ingredient) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.symmetric(vertical: 4.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle,
                                                  size: 18,
                                                  color: Colors.green,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    ingredient.name,
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList()
                                      : [
                                          const Text(
                                            "No ingredients provided.",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                ),
                              ),
                              const SizedBox(height: 24.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

/// A small widget to display each stat (e.g. difficulty, duration, kcal) in a random-color chip.
class _StatChip extends StatelessWidget {
  final String label;

  const _StatChip({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
      backgroundColor: getRandomPastelColor(),
      elevation: 2,
    );
  }
}
