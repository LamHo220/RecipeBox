import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/home/home.dart';
import 'package:recipe_box/recipe/view/recipe_detail_page.dart';
import 'package:recipe_repository/recipe_repository.dart';

class RecipeItem extends StatelessWidget {
  const RecipeItem({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        transitionType: ContainerTransitionType.fadeThrough,
        closedElevation: 0,
        closedBuilder: (context, openContainer) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.white,
                  foregroundColor: ThemeColors.card,
                  padding: EdgeInsets.all(16)),
              onPressed: () => openContainer(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Avatar(),
                        Pad.w4,
                        Text(
                          'username',
                          style: Style.search
                              .copyWith(fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Pad.h12,
                    Text(
                      recipe.name,
                      style: Style.label,
                    ),
                    Pad.h12,
                    Text(
                      recipe.description,
                      maxLines: 5,
                      style: Style.search.copyWith(fontWeight: FontWeight.w400),
                    ),
                    Pad.h12,
                    Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red[400]),
                        Pad.w4,
                        Text(
                          recipe.bookmarked.toString(),
                          style: Style.search,
                        ),
                        Pad.w8,
                        Icon(FontAwesomeIcons.codeFork,
                            color: ThemeColors.gray, size: 20),
                        Pad.w4,
                        Text(
                          recipe.forked.toString(),
                          style: Style.search,
                        ),
                        Pad.w8,
                        Icon(
                          Icons.comment,
                          color: Colors.blue[400],
                        ),
                        Pad.w4,
                        Text(
                          '4.5/5',
                          style: Style.search,
                        )
                      ],
                    )
                  ]),
            ),
        openBuilder: (context, closeContainer) => RecipeDetails(
              recipe: recipe,
              closedContainer: closeContainer,
            ));
  }
}
