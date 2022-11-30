import 'package:animations/animations.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/home/cubit/home_cubit.dart';
import 'package:recipe_box/recipe/widgets/recipe_item.dart';
import 'package:recipe_repository/recipe_repository.dart';

const _postLimit = 6;

class SearcherWidget extends StatelessWidget {
  SearcherWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => OpenContainer(
          openElevation: 0,
          closedElevation: 0,
          closedBuilder: (context, action) => IconButton(
              onPressed: () => action(), icon: const Icon(Icons.search)),
          openBuilder: (context, action) => RecipeResultView(
              repository: context.read<HomeCubit>().getRecipeRepo(),
              user: context
                  .select((HomeCubit value) => value.state.userDetails))),
    );
  }
}

class Searcher extends StatelessWidget {
  const Searcher({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SearcherWidget();
  }
}

class RecipeResultView extends StatefulWidget {
  const RecipeResultView({
    required this.repository,
    required this.user,
  });

  final RecipeRepository repository;

  final UserDetails user;

  @override
  _RecipeResultViewState createState() => _RecipeResultViewState();
}

class _RecipeResultViewState extends State<RecipeResultView> {
  RecipeRepository get _repository => widget.repository;
  UserDetails get _user => widget.user;

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

  FloatingSearchBarController _fController = FloatingSearchBarController();

  Future<void> _fetchPage(int pageKey) async {
    print(12);
    try {
      final q = widget.repository
          .getRecipeRef()
          .where('name', isGreaterThanOrEqualTo: _fController.query)
          .orderBy("name");
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
  // void didUpdateWidget(RecipeResultView oldWidget) {
  //   if (oldWidget.listPreferences != widget.listPreferences) {
  //     _pagingController.refresh();
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: [
          FloatingSearchBar(
            controller: _fController,
            scrollController: _controller,
            hint: 'Search...',
            scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
            transitionDuration: const Duration(milliseconds: 300),
            transitionCurve: Curves.easeInOut,
            physics: const BouncingScrollPhysics(),
            openAxisAlignment: 0.0,
            debounceDelay: const Duration(milliseconds: 300),
            onQueryChanged: (String query) async {
              _pagingController.itemList = null;
              _pagingController.notifyPageRequestListeners(0);
            },
            // Specify a custom transition to be used for
            // animating between opened and closed stated.
            transition: CircularFloatingSearchBarTransition(),
            actions: [
              // FloatingSearchBarAction(
              //   showIfOpened: false,
              //   child: CircularButton(
              //     icon: const Icon(Icons.place),
              //     onPressed: () {},
              //   ),
              // ),
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
            ],
            backdropColor: ThemeColors.white,
            builder: (context, transition) {
              return RefreshIndicator(
                onRefresh: () => Future.sync(
                  () => _pagingController.refresh(),
                ),
                child: PagedListView.separated(
                  scrollController: _controller,
                  shrinkWrap: true,
                  builderDelegate: PagedChildBuilderDelegate<Recipe>(
                    itemBuilder: (context, recipe, index) {
                      return RecipeItem(
                        recipe: recipe,
                      );
                    },
                    firstPageErrorIndicatorBuilder: (context) => Container(),
                    // ErrorIndicator(
                    //   error: _pagingController.error,
                    //   onTryAgain: () => _pagingController.refresh(),
                    // ),
                    noItemsFoundIndicatorBuilder: (context) => Container(),
                    // EmptyListIndicator(),
                  ),
                  pagingController: _pagingController,
                  // padding: const EdgeInsets.all(16),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 16,
                  ),
                ),
              );
            },
          )
        ],
      ));
}
