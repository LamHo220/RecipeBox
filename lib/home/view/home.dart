import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_box/app/app.dart';
import 'package:recipe_box/common/components/searcher/widget/searcher.dart';
import 'package:recipe_box/common/components/texts.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/home/cubit/home_cubit.dart';
import 'package:recipe_box/home/home.dart';
import 'package:recipe_box/recipe/widgets/recipe_card.dart';
import 'package:recipe_repository/recipe_repository.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final TextEditingController _searchController = TextEditingController();

  final FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    print(user);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: ThemeColors.text,
        backgroundColor: ThemeColors.white,
        title: Text(
          "Hello, ${(user.username == '' ? null : user.username) ?? (user.email == null ? '' : user.email!.split('@')[1])} 👋",
        ),
        titleTextStyle: Style.welcome,
        actions: [Searcher()],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _question,
            Pad.h12,
            Container(
              padding: Pad.plr16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [heading('Categories'), seeAll(() => {})],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  Pad.w24,
                  Chip(label: Text('Vegetable')),
                  Pad.w24,
                  Chip(label: Text('Dinner')),
                  Pad.w24,
                  Chip(label: Text('Lunch')),
                  Pad.w24,
                  Chip(label: Text('Breakfast')),
                  Pad.w24,
                  Chip(label: Text('Meat')),
                  Pad.w24,
                  Chip(label: Text('Bread')),
                  Pad.w24,
                ],
              ),
            ),
            Container(
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
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Pad.w24,
                FutureBuilder<QuerySnapshot<Recipe>>(
                  future: context.read<HomeCubit>().test(),
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    return data != null && data.docs.isNotEmpty
                        ? RecipeCard(recipe: data.docs[0].data())
                        : const Text(
                            'You currently haven\'t add any recipe to favorites.');
                  },
                ),
                Pad.w16
              ]),
            ),
            Container(
              padding: Pad.plr16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [heading('Your Recipes'), seeAll(() => {})],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Pad.w24,
                for (var i = 0; i < 10; ++i)
                  Row(
                    children: [
                      // RecipeCard(
                      //   recipe: _test,
                      // ),
                      Text('data'),
                      Pad.w8,
                    ],
                  ),
                Pad.w16
              ]),
            ),
            Container(
              padding: Pad.plr16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [heading('Popular'), seeAll(() => {})],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Pad.w24,
                for (var i = 0; i < 10; ++i)
                  Row(
                    children: [
                      // RecipeCard(
                      //   recipe: _test,
                      // ),
                      Text('data'),
                      Pad.w8,
                    ],
                  ),
                Pad.w16
              ]),
            ),
            Pad.h24,
            Pad.h24,
            Pad.h24,
            Pad.h24,
          ],
        ),
      ),
    );
  }

  final Widget _question = Container(
    padding: Pad.plr16,
    child: Text(
      'What do you want to cook today?',
      style: Style.question,
    ),
  );
}
