import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:recipe_box/app/app.dart';
import 'package:recipe_box/common/components/searcher/widget/searcher.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/explore/view/explore_page.dart';
import 'package:recipe_box/home/cubit/home_cubit.dart';
import 'package:recipe_box/recipe/widgets/recipe_item.dart';
import 'package:recipe_repository/recipe_repository.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

class RecipeListView extends StatelessWidget {
  RecipeListView({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc value) => value.state.user);
    final userDetails =
        context.select((HomeCubit bloc) => bloc.state.userDetails);
    Future<QuerySnapshot<Recipe>> _getRecipes(title) {
      if (Categories.values.map((e) => e.name).contains(title)) {
        return context.read<HomeCubit>().getRecipesByCategory(title);
      }
      switch (title) {
        case 'Public Recipes':
          return context.read<HomeCubit>().getUser(user.id).then((value) {
            value.docs.removeWhere((element) => element.data().isPublic);
            return value;
          });
        case 'Private Recipes':
          return context.read<HomeCubit>().getUser(user.id).then((value) {
            value.docs.removeWhere((element) => !element.data().isPublic);
            return value;
          });
        case 'Favorites':
          return context.read<HomeCubit>().userFavorite(userDetails);
        case 'Your Recipes':
          return context.read<HomeCubit>().userRecipes(user);
        default:
          return context.read<HomeCubit>().popularRecipes();
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ThemeColors.white,
        title: Text(title),
        titleTextStyle: Style.welcome,
        foregroundColor: ThemeColors.text,
        actions: [Searcher()],
      ),
      body: FutureBuilder<QuerySnapshot<Recipe>>(
        future: _getRecipes(title),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null || data.size == 0) {
            return Container(
              padding: Pad.pa12,
              child: Text("There is no recipe in $title"),
            );
          }
          if (data.docs.isEmpty) {
            return Container(
              padding: Pad.pa12,
              child: Text("There is no recipe in $title"),
            );
          }
          return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                    color: ThemeColors.white,
                  ),
              itemCount: data.docs.length,
              itemBuilder: (context, index) => RecipeItem(
                    recipe: data.docs[index].data(),
                  ));
        },
      ),
    );
  }
}

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: RecipeListView(title: title),
    );
  }
}
