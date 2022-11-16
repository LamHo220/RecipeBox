import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_box/common/components/searcher/widget/searcher.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/explore/cubit/explore_cubit.dart';
import 'package:recipe_box/recipe/view/recipe_list_page.dart';

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
              itemBuilder: (context, index) => _Button(
                  text: Categories.values[index].name,
                  color: _colors[index],
                  icon: _icons[index],
                  func: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipeListPage(
                              title: Categories.values[index].name)))))
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

List<IconData> _icons = [
  Icons.breakfast_dining,
  Icons.lunch_dining,
  Icons.dinner_dining,
  Icons.cake,
  Icons.grass
];

List<Color> _colors = [
  Colors.yellow[700]!,
  Colors.red[300]!,
  Colors.black45,
  Colors.blue[300]!,
  Colors.green[300]!,
];

class _Button extends StatelessWidget {
  const _Button(
      {super.key,
      required this.text,
      required this.color,
      required this.icon,
      required this.func});

  final String text;

  final Color color;

  final IconData icon;

  final Function()? func;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeColors.white,
        elevation: 0,
      ),
      onPressed: func,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(4),
              color: color,
            ),
            padding: Pad.pa8,
            child: Icon(
              icon,
              color: ThemeColors.white,
              size: 16,
            ),
          ),
          Pad.w8,
          Text(text, style: Style.label)
        ],
      ),
    );
  }
}
