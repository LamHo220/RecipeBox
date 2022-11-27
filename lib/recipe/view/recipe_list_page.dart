import 'package:authentication_repository/authentication_repository.dart';
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

const _postLimit = 6;

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return RecipeListView(
      title: title,
      repository: context.read<HomeCubit>().getRecipeRepo(),
      user: context.select((HomeCubit value) => value.state.userDetails),
    );
  }
}

class RecipeListView extends StatefulWidget {
  const RecipeListView({
    required this.title,
    required this.repository,
    required this.user,
  });

  final String title;

  final RecipeRepository repository;

  final UserDetails user;

  @override
  _RecipeListViewState createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  RecipeRepository get _repository => widget.repository;
  UserDetails get _user => widget.user;
  String get _title => widget.title;

  final _pagingController = PagingController<int, Recipe>(
    firstPageKey: 1,
  );
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Query<Recipe> getQuery(ref) {
    if (Categories.values.map((e) => e.name).contains(_title)) {
      return ref.where('categories', arrayContains: _title);
    }
    switch (_title) {
      case 'Public Recipes':
        return ref
            .where('user', isEqualTo: _user.id)
            .where('isPublic', isEqualTo: true);
      case 'Private Recipes':
        return ref
            .where('user', isEqualTo: _user.id)
            .where('isPublic', isEqualTo: false);
      case 'Favorites':
        return ref
            .where('id', whereIn: _user.favorites)
            .where('isPublic', isEqualTo: true);
      case 'Your Recipes':
        return ref.where('user', isEqualTo: _user.id);
      default:
        return ref.where('isPublic', isEqualTo: true);
    }
  }

  // TODO
  Future<void> _fetchPage(int pageKey) async {
    try {
      final ref = widget.repository.getRecipeRef().orderBy('timestamp');
      final q = getQuery(ref);

      final QuerySnapshot<Recipe?> newRecipes =
          await q.limit(_postLimit).get().then((value) async {
        if (_pagingController.itemList == null) {
          return value;
        }
        if (_pagingController.itemList!.isEmpty) {
          return value;
        }
        final next = q.startAfter(
            [_pagingController.itemList!.last.timestamp]).limit(_postLimit);
        return next.get();
      });

      bool isLastPage = newRecipes.docs.isEmpty;
      _pagingController.itemList?.forEach((element) {
        isLastPage = isLastPage ||
            newRecipes.docs.map((e) {
              return e.data()!;
            }).contains(element);
      });
      if (isLastPage) {
        _pagingController
            .appendLastPage(newRecipes.docs.map((e) => e.data()!).toList());
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(
            newRecipes.docs.map((e) => e.data()!).toList(), nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(RecipeListView oldWidget) {
  //   if (oldWidget.listPreferences != widget.listPreferences) {
  //     _pagingController.refresh();
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(_title),
          backgroundColor: ThemeColors.white,
          foregroundColor: ThemeColors.primaryLight,
          titleTextStyle: Style.welcome,
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedListView.separated(
            builderDelegate: PagedChildBuilderDelegate<Recipe>(
              itemBuilder: (context, recipe, index) => RecipeItem(
                recipe: recipe,
              ),
              firstPageErrorIndicatorBuilder: (context) => Container(),
              // ErrorIndicator(
              //   error: _pagingController.error,
              //   onTryAgain: () => _pagingController.refresh(),
              // ),
              noItemsFoundIndicatorBuilder: (context) => Container(
                padding: Pad.pa12,
                child: Text(
                  'We can not find any recipe in ${_title}.',
                  style: Style.label,
                ),
              ),
              // EmptyListIndicator(),
            ),
            pagingController: _pagingController,
            // padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => const SizedBox(
              height: 16,
            ),
          ),
        ),
      );
}
