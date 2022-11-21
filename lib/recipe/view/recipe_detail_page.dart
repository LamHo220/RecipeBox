import 'package:animations/animations.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_box/app/app.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/recipe/bloc/recipe_bloc.dart';
import 'package:recipe_box/recipe/cubit/recipe_cubit.dart';
import 'package:recipe_box/recipe/view/recipe_add_page.dart';
import 'package:recipe_box/recipe/view/recipe_steps.dart';
import 'package:recipe_repository/recipe_repository.dart';

import '../../home/cubit/home_cubit.dart';

class RecipeDetailsView extends StatelessWidget {
  const RecipeDetailsView({
    Key? key,
    required this.recipe,
    required this.closedContainer,
  }) : super(key: key);

  final Recipe recipe;
  final Function closedContainer;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final flag = context.select((HomeCubit value) => value.state.flag);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => closedContainer(),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          PopupMenuButton(onSelected: (value) {
            if (value == 0) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text('Warning'),
                      content:
                          Text('Are you really want to delete the recipe?'),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: ThemeColors.primaryDark),
                          child: Text("No"),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: ThemeColors.primaryDark),
                          child: Text("Yes"),
                          onPressed: () => Navigator.pop(context, true),
                        )
                      ],
                    );
                  }).then((value) {
                if (value) {
                  context.read<RecipeBloc>().deleteRecipe(recipe);
                  context.read<HomeCubit>().setFlag(!flag);
                  context.read<HomeCubit>().removeFromFavorite(recipe);
                  Navigator.pop(context);
                }
              });
            } else if (value == 1) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Card(
                        child: Container(
                            padding: Pad.pa8,
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Text(
                              recipe.note,
                              style: Style.question,
                            )),
                      ),
                    );
                  });
            } else if (value == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeAddPage(
                            recipe: recipe,
                            action: RAction.modify,
                          )));
            }
          }, itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                enabled: user.id == recipe.user,
                value: 0,
                child: Text("Delete Recipe"),
              ),
              PopupMenuItem(value: 1, child: Text('Notes from creater')),
              PopupMenuItem(value: 2, child: Text('Edit'))
            ];
          })
        ],
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: ThemeColors.white,
          width: double.infinity,
          padding: Pad.pa12,
          child: Row(
            children: [
              BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) =>
                      previous.userDetails != current.userDetails,
                  builder: (context, state) => GestureDetector(
                      onTap: () => state.userDetails.favorites
                              .contains(recipe.id)
                          ? context.read<HomeCubit>().removeFromFavorite(recipe)
                          : context.read<HomeCubit>().addToFavorite(recipe),
                      child: Container(
                        padding: Pad.pa12,
                        decoration: BoxDecoration(
                            color: ThemeColors.card,
                            borderRadius: BorderRadius.circular(12)),
                        child: state.userDetails.favorites.contains(recipe.id)
                            ? Icon(
                                FontAwesomeIcons.solidHeart,
                                color: Colors.red,
                              )
                            : Icon(FontAwesomeIcons.heart),
                      ))),
              Pad.w8,
              GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipeAddPage(
                                recipe: recipe,
                                action: RAction.fork,
                              ))),
                  child: Container(
                    padding: Pad.pa12,
                    decoration: BoxDecoration(
                        color: ThemeColors.card,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(FontAwesomeIcons.codeFork),
                  )),
              Pad.w8,
              GestureDetector(
                  onTap: () => {},
                  child: Container(
                    padding: Pad.pa12,
                    decoration: BoxDecoration(
                        color: ThemeColors.card,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(FontAwesomeIcons.commentDots),
                  )),
              Pad.w8,
              Expanded(
                  child: OpenContainer(
                      closedElevation: 0,
                      transitionDuration: const Duration(milliseconds: 500),
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedBuilder: (context, open) {
                        return ElevatedButton(
                            style: _viewStepsStyle(),
                            onPressed: () => open(),
                            child: Container(
                              padding: EdgeInsetsDirectional.all(14),
                              child: Text('View Steps'),
                            ));
                      },
                      openBuilder: (context, close) {
                        return Steps(
                            name: recipe.name,
                            steps: recipe.steps,
                            closedContainer: closedContainer);
                      }))
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            alignment: Alignment.bottomLeft,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.network('https://picsum.photos/1024').image,
                    fit: BoxFit.cover)),
            child: Container(
              color: ThemeColors.halfGray,
              padding:
                  const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_circle,
                    color: ThemeColors.white,
                  ),
                  Pad.w8,
                  FutureBuilder<QuerySnapshot<UserDetails>>(
                      future:
                          context.read<HomeCubit>().getUserDetails(recipe.user),
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        if (data == null) {
                          return Container();
                        }
                        if (data.docs.isEmpty) {
                          return Container();
                        }
                        return Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          direction: Axis.vertical,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  data.docs.first.data().username,
                                  style: Style.cardTitle,
                                ),
                                Pad.w4,
                                Text(
                                  "lv${data.docs.first.data().level}",
                                  style:
                                      Style.cardSubTitle.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                            FutureBuilder<QuerySnapshot<Recipe>>(
                              future: context
                                  .read<HomeCubit>()
                                  .getUser(recipe.user),
                              builder: (context, snapshot) {
                                return Text(
                                  '${snapshot.data == null ? 0 : snapshot.data!.size} recipe shared',
                                  style: Style.cardSubTitle,
                                );
                              },
                            )
                          ],
                        );
                      })
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.only(start: 12, end: 12),
            child: Column(
              children: [
                Container(
                  padding: Pad.pa12,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.ideographic,
                        children: [
                          Text(
                            recipe.name,
                            style: Style.heading,
                          ),
                          Pad.w8,
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite,
                                color: Colors.red[600],
                                size: 16,
                              ),
                              Text(recipe.bookmarked.toString())
                            ],
                          ),
                          Pad.w8,
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(
                                FontAwesomeIcons.codeFork,
                                color: ThemeColors.gray,
                                size: 16,
                              ),
                              Text(recipe.forked.toString())
                            ],
                          )
                        ],
                      ),
                      Pad.h8,
                      Container(
                        padding: Pad.pa12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(12),
                            border: Border.all(
                              color: ThemeColors.inactive,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  recipe.cal.toString(),
                                  style: Style.highlightText,
                                ),
                                Text(
                                  'cal',
                                  style: Style.label.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  recipe.gram.toString(),
                                  style: Style.highlightText,
                                ),
                                Text(
                                  'gram',
                                  style: Style.label.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                // TODO rating
                                Text(
                                  '0',
                                  style: Style.highlightText,
                                ),
                                Text(
                                  'rating',
                                  style: Style.label.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  ' ${recipe.time['hr'] != '0' ? ('${recipe.time['hr']!}hr') : ''} ${recipe.time['min'] != '0' ? ('${recipe.time['min']!}mins') : ''}',
                                  style: Style.highlightText,
                                ),
                                Text(
                                  'is needed',
                                  style: Style.label.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  recipe.steps.length.toString(),
                                  style: Style.highlightText,
                                ),
                                Text(
                                  'steps',
                                  style: Style.label.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Pad.h12,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.ideographic,
                        children: [
                          const Text(
                            'Ingredients',
                            style: Style.heading,
                          ),
                          Text('${recipe.ingredients.length} items',
                              style: Style.label
                                  .copyWith(color: ThemeColors.inactive))
                        ],
                      ),
                      Pad.h24,
                      for (int i = 0; i < recipe.ingredients.length; ++i)
                        Container(
                          padding: EdgeInsetsDirectional.only(bottom: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              Text("${(i + 1)}.", style: Style.label),
                              Pad.w8,
                              Expanded(
                                child: Text(recipe.ingredients[i]['name']!,
                                    style: Style.label),
                              ),
                              Text(
                                recipe.ingredients[i]['value']!,
                                style: Style.label.copyWith(
                                  color: ThemeColors.gray,
                                ),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

ButtonStyle _viewStepsStyle() {
  return ButtonStyle(shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
    (Set<MaterialState> states) {
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    },
  ), elevation: MaterialStateProperty.resolveWith<double?>(
    (Set<MaterialState> states) {
      return 0;
    },
  ), backgroundColor: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      return ThemeColors.primaryLight;
    },
  ));
}

class RecipeDetails extends StatelessWidget {
  const RecipeDetails({
    super.key,
    required this.recipe,
    required this.closedContainer,
  });

  final Recipe recipe;

  final Function closedContainer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc(recipe: null),
      child: RecipeDetailsView(
        recipe: recipe,
        closedContainer: closedContainer,
      ),
    );
  }
}
