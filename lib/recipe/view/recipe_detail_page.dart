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
import 'package:recipe_box/common/level_parser.dart';
import 'package:recipe_box/recipe/bloc/recipe_bloc.dart';
import 'package:recipe_box/recipe/view/recipe_add_page.dart';
import 'package:recipe_box/recipe/view/recipe_steps.dart';
import 'package:recipe_repository/recipe_repository.dart';
import 'package:rating_dialog/rating_dialog.dart';
import '../../home/cubit/home_cubit.dart';

class RecipeDetailsView extends StatelessWidget {
  const RecipeDetailsView(
      {Key? key,
      required this.recipe,
      required this.closedContainer,
      required this.decoratedImage})
      : super(key: key);

  final Recipe recipe;
  final Function closedContainer;
  final DecorationImage decoratedImage;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final flag = context.select((HomeCubit value) => value.state.flag);

    PreferredSizeWidget? appBar = AppBar(
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
                builder: (context2) {
                  return CupertinoAlertDialog(
                    title: const Text('Warning'),
                    content:
                        const Text('Are you really want to delete the recipe?'),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: ThemeColors.primaryDark),
                        child: const Text("No"),
                        onPressed: () => Navigator.of(context2).pop(false),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: ThemeColors.primaryDark),
                        child: const Text("Yes"),
                        onPressed: () => Navigator.of(context2).pop(true),
                      )
                    ],
                  );
                }).then((value) {
              if (value) {
                try {
                  context.read<RecipeBloc>().deleteRecipe(recipe);
                  context.read<HomeCubit>().addExp(user, -10);
                  context.read<HomeCubit>().setFlag(!flag);
                  context.read<HomeCubit>().removeFromFavorite(recipe, true);
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
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
                          action: RAction.Modify,
                        )));
          } else if (value == 3) {
            showDialog(
              context: context,
              builder: (context2) => AlertDialog(
                content: Card(
                  elevation: 0,
                  child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    builder: (context, snapshot) {
                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return Text(
                          'No Reviews from others currently.',
                          style: Style.highlightText,
                        );
                      }
                      // final ratings =
                      //     snapshot.data!.docs.map((e) => e['rating']);
                      // final s =
                      //     ratings.reduce((value, element) => value + element);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < snapshot.data!.docs.length; ++i)
                            Wrap(
                              children: [
                                Row(
                                  children: [
                                    FutureBuilder<QuerySnapshot<UserDetails>>(
                                      future: context
                                          .read<HomeCubit>()
                                          .getUserDetails(snapshot.data!.docs[i]
                                              .data()['user_id']
                                              .toString()),
                                      builder: (context, snapshot2) {
                                        if (snapshot2.data == null) {
                                          return Text(
                                            snapshot.data!.docs[i]
                                                .data()['user_id']
                                                .toString(),
                                            style: Style.label,
                                          );
                                        }
                                        return Text(
                                          snapshot2.data!.docs.first
                                              .data()
                                              .username
                                              .toString(),
                                          style: Style.label,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow[800],
                                    ),
                                    Pad.w12,
                                    Text(snapshot.data!.docs[i]
                                        .data()['rating']
                                        .toString()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.comment,
                                      color: Colors.blue,
                                    ),
                                    Pad.w12,
                                    Text(snapshot.data!.docs[i]
                                        .data()['comment']
                                        .toString())
                                  ],
                                )
                              ],
                            )
                        ],
                      );
                    },
                    future: context.read<HomeCubit>().getRateByRecipe(recipe),
                  ),
                ),
              ),
            );
          }
        }, itemBuilder: (context) {
          return [
            PopupMenuItem(value: 1, child: Text('Notes from creater')),
            PopupMenuItem<int>(
              value: 3,
              child: Text("Reviews"),
            ),
            PopupMenuItem(
              enabled: user.id == recipe.user,
              value: 2,
              child: Text('Edit'),
            ),
            PopupMenuItem<int>(
              enabled: user.id == recipe.user,
              value: 0,
              child: Text("Delete Recipe"),
            ),
          ];
        })
      ],
      elevation: 0,
    );

    Widget? bottomAppBar = BottomAppBar(
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
                    onTap: () => state.userDetails.favorites.contains(recipe.id)
                        ? context
                            .read<HomeCubit>()
                            .removeFromFavorite(recipe, false)
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
                              action: RAction.Fork,
                            ))),
                child: Container(
                  padding: Pad.pa12,
                  decoration: BoxDecoration(
                      color: ThemeColors.card,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(FontAwesomeIcons.codeFork),
                )),
            Pad.w8,
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    builder: (context, snapshot) => GestureDetector(
                        onTap: () {
                          final _dialog = RatingDialog(
                            initialRating: snapshot.data != null &&
                                    snapshot.data!.docs.isNotEmpty
                                ? snapshot.data!.docs[0]['rating'] as double
                                : 1.0,
                            title: const Text(
                              'Rating This Recipe',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            message: const Text(
                              'Let others know your feedback!',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                            submitButtonText: 'Submit',
                            commentHint: 'Any comment on this recipe?',
                            onCancelled: () {},
                            onSubmitted: (response) {
                              if (snapshot.data == null) {
                              } else if (snapshot.data!.docs.isEmpty) {
                                context.read<HomeCubit>().rate(recipe,
                                    response.rating, response.comment, user);
                              } else {
                                context.read<HomeCubit>().updateRate(recipe,
                                    response.rating, response.comment, user);
                              }
                            },
                          );
                          final res = showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => _dialog,
                          );
                        },
                        child: Container(
                          padding: Pad.pa12,
                          decoration: BoxDecoration(
                              color: ThemeColors.card,
                              borderRadius: BorderRadius.circular(12)),
                          child: Icon(
                            FontAwesomeIcons.commentDots,
                            color: snapshot.data != null &&
                                    snapshot.data!.docs.isNotEmpty
                                ? Colors.yellow[900]
                                : null,
                          ),
                        )),
                    future: context.read<HomeCubit>().getRate(recipe, user));
              },
            ),
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
    );

    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: appBar,
          bottomNavigationBar: bottomAppBar,
          body: SingleChildScrollView(
            child: Column(children: [
              Container(
                alignment: Alignment.bottomLeft,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(image: decoratedImage),
                child: Container(
                  color: ThemeColors.halfGray,
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(
                            Icons.account_circle,
                            color: ThemeColors.white,
                          ),
                          Pad.w8,
                          FutureBuilder<QuerySnapshot<UserDetails>>(
                              future: context
                                  .read<HomeCubit>()
                                  .getUserDetails(recipe.user),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          data.docs.first.data().username,
                                          style: Style.cardTitle,
                                        ),
                                        Pad.w4,
                                        Text(
                                          "lv ${getLevel(data.docs.first.data().exp)}",
                                          style: Style.cardSubTitle
                                              .copyWith(fontSize: 12),
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
                              }),
                        ],
                      ),
                      FutureBuilder<QuerySnapshot<Recipe>>(
                        future: context
                            .read<HomeCubit>()
                            .gerRecipeById(recipe.original),
                        builder: (context, snapshot) {
                          if (!recipe.isPublic) {
                            return const Text(
                              'Private Recipe',
                              style: TextStyle(color: Colors.white60),
                            );
                          }
                          final data = snapshot.data;
                          if (data == null) {
                            return const SizedBox();
                          }
                          if (recipe.original == null) {
                            return const SizedBox();
                          }
                          if (data.docs.isEmpty) {
                            return const SizedBox();
                          }
                          if (!data.docs.first.data().isPublic) {
                            return const Text(
                              'Original is a Private Recipe',
                              style: TextStyle(color: Colors.white60),
                            );
                          }
                          final _recipe = data.docs.first.data();
                          return FutureBuilder<Uint8List?>(
                            future: context
                                .read<HomeCubit>()
                                .getImage(_recipe.imgPath),
                            builder: (context, snapshot2) {
                              final _decoratedImage = DecorationImage(
                                  image: snapshot2.data == null
                                      ? Image.asset('assets/placeholder.png')
                                          .image
                                      : MemoryImage(snapshot2.data!),
                                  fit: BoxFit.cover);
                              return OpenContainer(
                                  closedElevation: 0,
                                  openElevation: 0,
                                  openColor: Colors.transparent,
                                  closedColor: Colors.transparent,
                                  closedBuilder: (context, open) =>
                                      ElevatedButton(
                                          style: _viewStepsStyle(),
                                          child: Text(snapshot2.data == null
                                              ? 'Finding Original...'
                                              : snapshot2.data!.isEmpty
                                                  ? 'Finding Original...'
                                                  : 'Find Original'),
                                          onPressed: () =>
                                              snapshot2.data == null
                                                  ? null
                                                  : snapshot2.data!.isEmpty
                                                      ? null
                                                      : open()),
                                  openBuilder: (context, close) =>
                                      RecipeDetails(
                                          recipe: _recipe,
                                          closedContainer: () => close(),
                                          decoratedImage: _decoratedImage));
                            },
                          );
                        },
                      )
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
                                borderRadius:
                                    BorderRadiusDirectional.circular(12),
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
                                    FutureBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                        future: context
                                            .read<HomeCubit>()
                                            .getRateByRecipe(recipe),
                                        builder: (context, snapshot) {
                                          if (snapshot.data == null ||
                                              snapshot.data!.docs.isEmpty) {
                                            return Text(
                                              '0',
                                              style: Style.highlightText,
                                            );
                                          }
                                          final ratings = snapshot.data!.docs
                                              .map((e) => e['rating']);
                                          final s = ratings.reduce(
                                              (value, element) =>
                                                  value + element);
                                          return Text(
                                            '${(s / ratings.length).toStringAsFixed(1)}',
                                            style: Style.highlightText,
                                          );
                                        }),
                                    Text(
                                      'rating',
                                      style: Style.label.copyWith(fontSize: 12),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${recipe.time['hr']}',
                                      style: Style.highlightText,
                                    ),
                                    Text(
                                      'hour',
                                      style: Style.label.copyWith(fontSize: 12),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${recipe.time['min']}',
                                      style: Style.highlightText,
                                    ),
                                    Text(
                                      'minutes',
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Descriptions',
                                style: Style.heading,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [Text(recipe.description)],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
      },
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
    required this.decoratedImage,
  });

  final Recipe recipe;

  final Function closedContainer;
  final DecorationImage decoratedImage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc(),
      child: RecipeDetailsView(
        recipe: recipe,
        closedContainer: closedContainer,
        decoratedImage: decoratedImage,
      ),
    );
  }
}
