import 'package:animations/animations.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_box/app/app.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/home/cubit/home_cubit.dart';
import 'package:recipe_box/recipe/bloc/recipe_bloc.dart';
import 'package:recipe_box/recipe/view/recipe_add_page.dart';
import 'package:recipe_box/recipe/view/recipe_detail_page.dart';
import 'package:recipe_box/recipe/view/recipe_steps.dart';
import 'package:recipe_box/recipe/widgets/recipe_card_before.dart';
import 'package:recipe_repository/recipe_repository.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({Key? key, required this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RecipeBloc(),
        child: FutureBuilder<Uint8List?>(
          future: context.read<HomeCubit>().getImage(recipe.imgPath),
          builder: (context, snapshot) {
            final decoratedImage = DecorationImage(
                image: snapshot.data == null
                    ? Image.asset('assets/loading.gif').image
                    : MemoryImage(snapshot.data!),
                fit: BoxFit.cover);

            Widget _closedBuild(context, openContainer) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => openContainer(),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.35,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(image: decoratedImage),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: Pad.pa8,
                            width: double.infinity,
                            color: ThemeColors.halfGray,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        recipe.name,
                                        style: Style.cardTitle,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: ThemeColors.white,
                                        size: 16,
                                      ),
                                      Text(
                                        ' ${recipe.time['hr'] != '0' ? ('${recipe.time['hr']!}hr') : ''} ${recipe.time['min'] != '0' ? ('${recipe.time['min']!}mins') : ''}',
                                        style: Style.cardSubTitle,
                                      )
                                    ],
                                  ),
                                ]),
                          )
                        ]),
                  ),
                ),
              );
            }

            return OpenContainer(
                transitionDuration: const Duration(milliseconds: 500),
                transitionType: ContainerTransitionType.fadeThrough,
                closedElevation: 0,
                closedBuilder: (context, openContainer) =>
                    _closedBuild(context, openContainer),
                openBuilder: (context, closedContainer) => RecipeDetails(
                    recipe: recipe,
                    closedContainer: closedContainer,
                    decoratedImage: decoratedImage));
          },
        ));
  }
}
