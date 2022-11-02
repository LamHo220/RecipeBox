import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_box/app/app.dart';
import 'package:recipe_box/common/components/texts.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/explore/view/explore_page.dart';
import 'package:recipe_box/home/cubit/home_cubit.dart';
import 'package:recipe_box/home/home.dart';
import 'package:recipe_box/home/view/home.dart';
import 'package:recipe_box/recipe/widgets/recipe_card.dart';
import 'package:recipe_repository/recipe_repository.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  @override
  Widget build(BuildContext context) {
    final Tabs selectedTab =
        context.select((HomeCubit cubit) => cubit.state.tab);
    final bool isShow = context.select((HomeCubit cubit) => cubit.state.isShow);
    final user = context.select((AppBloc bloc) => bloc.state.user);

    Widget fab() {
      return FloatingActionButton(
        backgroundColor: ThemeColors.primaryLight,
        onPressed: () => context.read<HomeCubit>().setTab(Tabs.add),
        child: const Icon(Icons.add),
      );
    }

    BottomAppBar bab() {
      return BottomAppBar(
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
          ));
    }

    return Scaffold(
        extendBody: true,
        floatingActionButtonLocation: _fabLocation,
        floatingActionButton: isShow ? fab() : null,
        bottomNavigationBar: isShow ? bab() : null,
        body: IndexedStack(
          index: selectedTab.index,
          children: [
            Home(),
            Container(
              child: Text('123'),
            ),
            Container(
              child: Text('456'),
            ),
            ExplorePage(),
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
        onPressed: value == Tabs.add
            ? null
            : () => context.read<HomeCubit>().setTab(value),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.vertical,
          children: [
            k['icon'],
            Pad.h4,
            Text(k['text']),
          ],
        ));
  }
}
