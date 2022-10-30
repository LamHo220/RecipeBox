import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:recipe_box/recipe/widgets/card_after.dart';
import 'package:recipe_box/recipe/widgets/card_before.dart';
import 'package:recipe_repository/recipe_repository.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({Key? key, required this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        transitionType: ContainerTransitionType.fadeThrough,
        closedElevation: 0,
        closedBuilder: (context, openContainer) {
          return Before(recipe: recipe, openContainer: openContainer);
        },
        openBuilder: (context, closedContainer) {
          return After(recipe: recipe, closedContainer: closedContainer);
        });
  }
}
