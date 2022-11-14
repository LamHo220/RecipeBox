import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_box/common/components/searcher/widget/searcher.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/explore/cubit/explore_cubit.dart';

class ExploreView extends StatelessWidget {
  ExploreView({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ThemeColors.white,
        title: Text('Explore'),
        titleTextStyle: Style.welcome,
        foregroundColor: ThemeColors.text,
        actions: [Searcher()],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Container(
          //   padding: Pad.plr12,
          //   child: Searcher(placeholder: 'Search Recipes'),
          // ),
          Container(
            padding: Pad.pa12,
            child: Text(
              'Discover',
              style: Style.heading,
            ),
          ),
          Container(
            padding: Pad.pa12,
            child: Text(
              'Categories',
              style: Style.heading,
            ),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: Categories.values.length,
              itemBuilder: (context, index) => TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: ThemeColors.text, padding: Pad.pa12),
                    onPressed: () => {},
                    child: Row(
                      children: [Text(Categories.values[index].name)],
                    ),
                  ))
        ],
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});
  static Page<void> page() => MaterialPage<void>(child: ExplorePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExploreCubit(),
      child: ExploreView(),
    );
  }
}

enum Categories {
  Breakfast,
  Lunch,
  Dinner,
  Dessert,
  Vegetable,
}
