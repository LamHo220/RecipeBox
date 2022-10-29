import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_api/recipe_api.dart';
import 'package:recipe_box/app/app.dart';
import 'package:recipe_box/common/components/texts.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/home/cubit/home_cubit.dart';
import 'package:recipe_box/home/home.dart';
import 'package:recipe_repository/recipe_repository.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final TextEditingController _searchController = TextEditingController();

  final FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  @override
  Widget build(BuildContext context) {
    final Tabs selectedTab =
        context.select((HomeCubit cubit) => cubit.state.tab);
    final bool isShow = context.select((HomeCubit cubit) => cubit.state.isShow);
    // final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
        extendBody: true,
        floatingActionButtonLocation: _fabLocation,
        floatingActionButton: isShow
            ? FloatingActionButton(
                backgroundColor: ThemeColors.primaryLight,
                onPressed: () => context.read<HomeCubit>().setTab(Tabs.add),
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: isShow
            ? BottomAppBar(
                shape: const CircularNotchedRectangle(),
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (Map<String, dynamic> k in _items)
                      _TabButton(
                        k: k,
                        groupValue: selectedTab,
                        value: k['value'],
                      )
                  ],
                ))
            : null,
        // appBar: AppBar(
        //   title: const Text('Home'),
        //   actions: <Widget>[
        //     IconButton(
        //       key: const Key('homePage_logout_iconButton'),
        //       icon: const Icon(Icons.exit_to_app),
        //       onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
        //     )
        //   ],
        // ),
        body: IndexedStack(
          index: selectedTab.index,
          children: [
            SingleChildScrollView(
              child: Container(
                padding: Pad.pa24,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, ${user.username} 👋",
                              style: Style.welcome,
                            ),
                            _question
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            RecipeApi _api = RecipeApi();
                            RecipeRepository _repo =
                                RecipeRepository(RecipeApi: _api);
                            _repo.createRecipe(Recipe(
                                name: 'name',
                                description: 'description',
                                bookmarked: 0,
                                cal: 0,
                                gram: 0,
                                forked: 0,
                                ingredients: [],
                                isPublic: false,
                                note: 'note',
                                steps: [],
                                categories: [],
                                timestamp: Timestamp.now()));
                          },
                          // context.read<AppBloc>().add(AppLogoutRequested()),
                          child: Avatar(photo: user.photo),
                        )
                      ],
                    ),
                    Pad.h24,
                    CupertinoSearchTextField(
                        controller: _searchController,
                        padding: Pad.pa12,
                        borderRadius: BorderRadius.circular(16),
                        placeholder: 'Search by recipes',
                        style: Style.search,
                        backgroundColor: ThemeColors.card,
                        prefixInsets:
                            const EdgeInsetsDirectional.fromSTEB(18, 4, 0, 4)),
                    Pad.h24,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [heading('Categories'), seeAll(() => {})],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: const [
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
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        heading('Your Favorite Recipes'),
                        seeAll(() => {})
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        for (var i = 0; i < 10; ++i)
                          Row(
                            children: [
                              // RecipeCard(),
                              Pad.w8,
                            ],
                          )
                      ]),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [heading('Your Recipes'), seeAll(() => {})],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        for (var i = 0; i < 10; ++i)
                          Row(
                            children: [
                              // RecipeCard(),
                              Pad.w8,
                            ],
                          )
                      ]),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [heading('Popular'), seeAll(() => {})],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        for (var i = 0; i < 10; ++i)
                          Row(
                            children: [
                              // RecipeCard(),
                              Pad.w8,
                            ],
                          )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Text('123'),
            ),
            Container(
              child: Text('456'),
            ),
            Container(
              child: Text('768'),
            ),
            Align(
              alignment: const Alignment(0, -1 / 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Avatar(photo: user.photo),
                  const SizedBox(height: 4),
                  Text(
                    user.email ?? '',
                  ),
                  const SizedBox(height: 4),
                  // Text(user.name ?? '', ),
                ],
              ),
            ),
          ],
        ));
  }

  static const List<Map<String, dynamic>> _items = [
    {
      'icon': Icon(
        Icons.home_outlined,
      ),
      'text': 'Home',
      'value': Tabs.home
    },
    {
      'icon': Icon(Icons.favorite_outline),
      'text': 'Favorite',
      'value': Tabs.favorite
    },
    {'icon': Icon(Icons.abc), 'text': ' ', 'value': Tabs.add},
    {
      'icon': Icon(FontAwesomeIcons.compass),
      'text': 'Explore',
      'value': Tabs.explore
    },
    {
      'icon': Icon(FontAwesomeIcons.user),
      'text': 'Profile',
      'value': Tabs.profile
    },
  ];

  final Widget _question = const Text(
    'What do you want to cook today?',
    style: Style.question,
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static Page<void> page() => MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: HomeView(),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.groupValue,
    required this.value,
    required this.k,
  });

  final Map<String, dynamic> k;

  final Tabs groupValue;
  final Tabs value;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: groupValue == value
              ? ThemeColors.primaryLight
              : ThemeColors.inactive,
        ),
        onPressed: () =>
            value == Tabs.add ? null : context.read<HomeCubit>().setTab(value),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.vertical,
          children: [
            k['icon'],
            Text(k['text']),
          ],
        ));
    // IconButton(
    //   onPressed: () => context.read<HomeCubit>().setTab(value),
    //   iconSize: 32,
    //   color:
    //       groupValue != value ? null : Theme.of(context).colorScheme.secondary,
    //   icon: icon,
    // );
  }
}
