import 'package:animations/animations.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_box/app/app.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/explore/view/explore_page.dart';
import 'package:recipe_box/recipe/view/recipe_add_page.dart';
import 'package:recipe_box/recipe/view/recipe_list_page.dart';
import 'package:recipe_box/home/cubit/home_cubit.dart';
import 'package:recipe_box/home/view/home.dart';
import 'package:recipe_box/profile/view/profile_page.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  @override
  Widget build(BuildContext context) {
    final Tabs selectedTab =
        context.select((HomeCubit cubit) => cubit.state.tab);
    final user = context.select((AppBloc bloc) => bloc.state.user);

    Widget fab() {
      return OpenContainer(
        openElevation: 0,
        closedShape: CircleBorder(),
        closedElevation: 6,
        closedBuilder: (context, action) => FloatingActionButton(
          backgroundColor: ThemeColors.primaryLight,
          onPressed: () => action(),
          child: const Icon(Icons.add),
        ),
        openBuilder: (context, action) => WillPopScope(
            child: RecipeAddPage(),
            onWillPop: () async {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Do you really want to leave?'),
                      content: Text('Your draft will not be saved.'),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: ThemeColors.primaryDark),
                          child: Text("Cancel"),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: ThemeColors.primaryDark),
                          child: Text("Confirm"),
                          onPressed: () => Navigator.pop(context, true),
                        )
                      ],
                    );
                  }).then((x) => x ?? false);
            }),
      );
    }

    BottomAppBar bab() {
      return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          elevation: 24,
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

    AuthenticationRepository repo = AuthenticationRepository();

    return Scaffold(
        extendBody: true,
        floatingActionButtonLocation: _fabLocation,
        floatingActionButton: fab(),
        bottomNavigationBar: bab(),
        body: _FadeIndexedStack(
          index: selectedTab.index,
          children: [
            BlocBuilder<HomeCubit, HomeState>(
                buildWhen: (previous, current) {
                  print(previous);
                  print(current);
                  return previous.userDetails != current.userDetails;
                },
                builder: (context, state) => Home()),
            FavoriteRecipePage(
              title: 'Favorite',
            ),
            Container(),
            ExplorePage(),
            ProfilePage(),
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
  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return HomeView();
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

class _FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const _FadeIndexedStack({
    Key? key,
    required this.index,
    required this.children,
    this.duration = const Duration(
      milliseconds: 200,
    ),
  }) : super(key: key);

  @override
  _FadeIndexedStackState createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<_FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void didUpdateWidget(_FadeIndexedStack oldWidget) {
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: IndexedStack(
        index: widget.index,
        children: widget.children,
      ),
    );
  }
}
