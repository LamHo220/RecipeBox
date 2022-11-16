import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_box/app/app.dart';
import 'package:recipe_box/common/components/searcher/widget/searcher.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/home/cubit/home_cubit.dart';
import 'package:recipe_box/recipe/widgets/recipe_item.dart';
import 'package:recipe_repository/recipe_repository.dart';

class FavoriteRecipeView extends StatelessWidget {
  FavoriteRecipeView({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final userDetails =
        context.select((HomeCubit bloc) => bloc.state.userDetails);
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
        future: context.read<HomeCubit>().userFavorite(userDetails),
        builder: (context, snapshot) {
          final data = snapshot.data;
          return data != null && data.docs.isNotEmpty
              ? ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: ThemeColors.white,
                      ),
                  itemCount: data.size,
                  itemBuilder: (context, index) => RecipeItem(
                        recipe: data.docs[index].data(),
                      ))
              : Text('There is no recipe in $title');
        },
      ),
    );
  }
}

class FavoriteRecipePage extends StatelessWidget {
  const FavoriteRecipePage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.userDetails != current.userDetails,
      builder: (context, state) => FavoriteRecipeView(title: title),
    );
  }
}

class RecipeListView extends StatelessWidget {
  RecipeListView({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
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
        future: context.read<HomeCubit>().getRecipes(title),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return Text("There is no recipe in $title");
          }
          if (data.docs.isEmpty) {
            return Text("There is no recipe in $title");
          }
          final docs =
              data.docs.where((element) => !element.data().isPublic).toList();
          return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                    color: ThemeColors.white,
                  ),
              itemCount: docs.length,
              itemBuilder: (context, index) => RecipeItem(
                    recipe: docs[index].data(),
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
