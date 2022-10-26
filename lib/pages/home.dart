import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_box/common/components/recipe_card.dart';
import 'package:recipe_box/common/components/texts.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/controllers/state_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_box/controllers/user_controller.dart';

class Home extends GetView<StateController> {
  Home({Key? key}) : super(key: key);

  final TextEditingController _searchController = TextEditingController();

  final stateController = Get.put(StateController());
  final userController = Get.put(UserController());
  final TextEditingController searchController = TextEditingController();

  final FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: SafeArea(
          // bottom: false,
          child: _body(),
        ),
        extendBody: true,
        floatingActionButtonLocation: _fabLocation,
        floatingActionButton: !stateController.hide.value
            ? FloatingActionButton(
                backgroundColor: ThemeColors.primaryLight,
                onPressed: () {},
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: !stateController.hide.value
            ? BottomAppBar(
                shape: const CircularNotchedRectangle(),
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (Map<String, dynamic> k in _items)
                      TextButton(
                          style: _viewStepsStyle(
                              ModalRoute.of(context)!.settings.name ==
                                  k['path']),
                          onPressed: () {
                            Get.toNamed(k['path']);
                          },
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            direction: Axis.vertical,
                            children: [
                              k['icon'],
                              Text(k['text']),
                            ],
                          ))
                  ],
                ))
            : null,
      ),
    );
  }

  static const List<Map<String, dynamic>> _items = [
    {
      'icon': Icon(
        Icons.home_outlined,
      ),
      'text': 'Home',
      'path': '/'
    },
    {
      'icon': Icon(Icons.favorite_outline),
      'text': 'Favorite',
      'path': '/favorite'
    },
    {'icon': Icon(Icons.abc), 'text': ' ', 'path': ''},

    {
      'icon': Icon(Icons.favorite_outline),
      'text': 'Explore',
      'path': '/explore'
    },
    {
      'icon': Icon(Icons.favorite_outline),
      'text': 'Profile',
      'path': '/profile'
    },

    // ' ': Icon(Icons.abc),
    // 'Explore': Icon(
    //   Icons.explore,
    // ),
    // 'Profile': Icon(
    //   FontAwesomeIcons.user,
    //   // size: 24,
    // ),
  ];

  Widget _body() {
    return SingleChildScrollView(
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
                    Obx(() => Text(
                          "Hello, ${userController.username.value.toString()} 👋",
                          style: Style.welcome,
                        )),
                    _question
                  ],
                ),
                Container(
                    padding: Pad.pa8,
                    decoration: const BoxDecoration(
                        color: ThemeColors.card,
                        borderRadius:
                            BorderRadiusDirectional.all(Radius.circular(99))),
                    child: const FaIcon(
                      FontAwesomeIcons.solidUser,
                      color: ThemeColors.inactive,
                    ))
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
              children: [heading('Your Favorite Recipes'), seeAll(() => {})],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                for (var i = 0; i < 10; ++i)
                  Row(
                    children: [
                      RecipeCard(),
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
                      RecipeCard(),
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
                      RecipeCard(),
                      Pad.w8,
                    ],
                  )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  final Widget _question = const Text(
    'What do you want to cook today?',
    style: Style.question,
  );

  ButtonStyle _viewStepsStyle(bool selected) {
    return ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        return selected ? ThemeColors.primaryLight : ThemeColors.inactive;
      },
    ), shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
      (Set<MaterialState> states) {
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
      },
    ), elevation: MaterialStateProperty.resolveWith<double?>(
      (Set<MaterialState> states) {
        return 0;
      },
    ), backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        return ThemeColors.white;
      },
    ));
  }
}
