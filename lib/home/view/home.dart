import 'package:animations/animations.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_box/app/app.dart';
import 'package:recipe_box/common/components/searcher/widget/searcher.dart';
import 'package:recipe_box/common/components/texts.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/explore/view/explore_page.dart';
import 'package:recipe_box/home/cubit/home_cubit.dart';
import 'package:recipe_box/recipe/bloc/recipe_bloc.dart';
import 'package:recipe_box/recipe/view/recipe_add_page.dart';
import 'package:recipe_box/recipe/view/recipe_detail_page.dart';
import 'package:recipe_box/recipe/view/recipe_list_page.dart';
import 'package:recipe_box/recipe/view/recipe_steps.dart';
import 'package:recipe_box/recipe/widgets/recipe_card.dart';
import 'package:recipe_box/recipe/widgets/recipe_card_before.dart';
import 'package:recipe_repository/recipe_repository.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final userDetails =
        context.select((HomeCubit bloc) => bloc.state.userDetails);
    final flag = context.select((HomeCubit value) => value.state.flag);

    PreferredSizeWidget _appBar = AppBar(
      elevation: 0,
      foregroundColor: ThemeColors.text,
      backgroundColor: ThemeColors.white,
      title: Text(
        "Hello, ${(user.username == '' ? null : user.username) ?? (user.email == null ? '' : user.email!.split('@')[1])} 👋",
      ),
      titleTextStyle: Style.welcome,
      actions: [Searcher()],
    );

    Future<QuerySnapshot<UserDetails>> _userDetails =
        context.read<HomeCubit>().getUserDetails(user.id);

    List<Widget> _header = [
      _question,
      Pad.h12,
      Container(
        padding: Pad.plr16,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            heading('Categories'),
            seeAll(() => context.read<HomeCubit>().setTab(Tabs.explore))
          ],
        ),
      ),
    ];

    Widget _categories = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Pad.w24,
          for (int i = 0; i < Categories.values.length; ++i)
            Wrap(
              direction: Axis.horizontal,
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipeListPage(
                                title: Categories.values[i].name))),
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        foregroundColor: ThemeColors.text,
                        backgroundColor:
                            ThemeColors.primaryLight.withAlpha(35)),
                    child: Text(Categories.values[i].name)),
                Pad.w8
              ],
            ),
          Pad.w24,
        ],
      ),
    );

    Widget _favHeader = Container(
      padding: Pad.plr16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          heading('Your Favorite Recipes'),
          seeAll(() => context.read<HomeCubit>().setTab(Tabs.favorite))
        ],
      ),
    );

    Widget _favList = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        Pad.w24,
        FutureBuilder<QuerySnapshot<Recipe>>(
          future: context.read<HomeCubit>().userFavorite(userDetails),
          builder: (context, snapshot) {
            final data = snapshot.data;

            if (data == null || data.docs.isEmpty) {
              return const Text(
                  'You currently haven\'t add any recipe to favorites.');
            }

            final _recipes = data.docs.map((e) {
              final _recipe = e.data();
              return RecipeCard(recipe: _recipe);
            }).toList();
            return Row(
              children: _recipes,
            );
          },
        ),
        Pad.w16
      ]),
    );

    Widget _urRecipeHeader = Container(
      padding: Pad.plr16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          heading('Your Recipes'),
          seeAll(() => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipeListPage(title: 'Your Recipes'))))
        ],
      ),
    );

    Widget _urReicipeList = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        Pad.w24,
        FutureBuilder<QuerySnapshot<Recipe>>(
          future: context.read<HomeCubit>().userRecipes(user),
          builder: (context, snapshot) {
            final data = snapshot.data;

            if (data == null || data.docs.isEmpty) {
              return const Text(
                  'You currently haven\'t add any recipe to favorites.');
            }

            final _recipes = data.docs.map((e) {
              final _recipe = e.data();
              return RecipeCard(recipe: _recipe);
            }).toList();
            return Row(
              children: _recipes,
            );
          },
        ),
        Pad.w16
      ]),
    );

    Widget _popularHeader = Container(
      padding: Pad.plr16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          heading('Popular'),
          seeAll(() => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipeListPage(title: 'Popular'))))
        ],
      ),
    );

    Widget _popularList = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        Pad.w24,
        FutureBuilder<QuerySnapshot<Recipe>>(
          future: context.read<HomeCubit>().popularRecipes(),
          builder: (context, snapshot) {
            final data = snapshot.data;

            if (data == null || data.docs.isEmpty) {
              return const Text(
                  'You currently haven\'t add any recipe to favorites.');
            }

            final _recipes = data.docs.map((e) {
              final _recipe = e.data();
              return RecipeCard(recipe: _recipe);
            }).toList();
            return Row(
              children: _recipes,
            );
          },
        ),
        Pad.w16
      ]),
    );

    return SafeArea(
        bottom: true,
        child: Scaffold(
          appBar: _appBar,
          body: FutureBuilder<QuerySnapshot<UserDetails>>(
              future: _userDetails,
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.data!.docs.isNotEmpty)
                  context
                      .read<HomeCubit>()
                      .updateUserDetails(snapshot.data!.docs.first.data());
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._header,
                      _categories,
                      _favHeader,
                      _favList,
                      _urRecipeHeader,
                      _urReicipeList,
                      _popularHeader,
                      _popularList,
                    ],
                  ),
                );
              }),
        ));
  }

  final Widget _question = Container(
    padding: Pad.plr16,
    child: Text(
      'What do you want to cook today?',
      style: Style.question,
    ),
  );
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
