import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_box/app/app.dart';
import 'package:recipe_box/app/view/setting_page.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/home/cubit/home_cubit.dart';
import 'package:recipe_box/home/home.dart';
import 'package:recipe_box/profile/cubit/profile_cubit.dart';
import 'package:recipe_box/recipe/view/recipe_list_page.dart';
import 'package:recipe_box/recipe/widgets/recipe_card.dart';
import 'package:recipe_repository/recipe_repository.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final userDetails =
        context.select((HomeCubit bloc) => bloc.state.userDetails);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          foregroundColor: ThemeColors.text,
          backgroundColor: ThemeColors.white,
          actions: [
            IconButton(onPressed: () => {}, icon: const Icon(Icons.share)),
            OpenContainer(
                openElevation: 0,
                closedElevation: 0,
                closedBuilder: (context, action) => IconButton(
                    onPressed: () => action(),
                    icon: const Icon(Icons.settings)),
                openBuilder: (context, action) => SettingPage(action: action)),
          ]),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: Pad.pa12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Avatar(photo: user.photo),
                      Pad.w12,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          user.username == '' || user.username == null
                              ? Text(
                                  'You don\'t have user name',
                                  style: Style.heading
                                      .copyWith(color: ThemeColors.card),
                                )
                              : Text(
                                  user.username!,
                                  style: Style.heading.copyWith(height: 1),
                                ),
                          // Pad.h4,
                          Text(user.email ?? ''),
                        ],
                      )
                    ],
                  ),
                  Pad.h4,
                  // Text(
                  //   userDetails.description == ''
                  //       ? 'The user does not have bio.'
                  //       : userDetails.description,
                  //   style: Style.search,
                  // ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       padding: Pad.pa8,
                  //       child: Icon(
                  //         FontAwesomeIcons.user,
                  //         size: 16,
                  //         color: ThemeColors.gray,
                  //       ),
                  //     ),
                  //     Text('n followers')
                  //   ],
                  // ),
                  const Divider(),
                  Row(
                    children: const [
                      Icon(FontAwesomeIcons.star),
                      Pad.w8,
                      Text(
                        'Popular Recipes',
                        style: Style.heading,
                      )
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FutureBuilder<QuerySnapshot<Recipe>>(
                      future:
                          context.read<ProfileCubit>().popularRecipes(user.id),
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        return data != null && data.docs.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (QueryDocumentSnapshot<Recipe> x
                                      in data.docs)
                                    RecipeCard(recipe: x.data())
                                ],
                              )
                            : const Text(
                                'You currently don\'t have any recipe.');
                      },
                    ),
                  ),
                ],
              ),
            ),
            _Button(
              text: 'Favorite Recipes',
              color: Colors.red[400]!,
              icon: FontAwesomeIcons.solidHeart,
              func: () => context.read<HomeCubit>().setTab(Tabs.favorite),
            ),
            _Button(
              text: 'Public Recipes',
              color: Colors.blue[400]!,
              icon: FontAwesomeIcons.userGroup,
              func: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RecipeListPage(title: 'Public Recipes'))),
            ),
            _Button(
              text: 'Private Recipes',
              color: Colors.green[400]!,
              icon: FontAwesomeIcons.userLock,
              func: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RecipeListPage(title: 'Private Recipes'))),
            ),
            _Button(
              text: 'Claim Rewards',
              color: Colors.orange[400]!,
              icon: FontAwesomeIcons.gifts,
              func: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Claim Rewards',
                                    style: Style.welcome,
                                  ),
                                  Wrap(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.coins,
                                        color: Colors.yellow[800],
                                      ),
                                      Pad.w12,
                                      Text(
                                        userDetails.points.toString(),
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              backgroundColor: ThemeColors.white,
                              foregroundColor: ThemeColors.primaryLight,
                              elevation: 0,
                            ),
                            body: ListView.builder(
                              itemCount: 100,
                              itemBuilder: (context, index) => Row(
                                children: [
                                  for (int i = 0; i < 2; ++i)
                                    Expanded(
                                        child: GestureDetector(
                                            onTap: () async {
                                              final bool? confirm =
                                                  await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text('Warning'),
                                                  content: Text(
                                                      'Do you really want to claim this?'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, false),
                                                        child: Text('No')),
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, true),
                                                        child: Text('Yes'))
                                                  ],
                                                ),
                                              );
                                              if (confirm == null) {
                                                return;
                                              }
                                              if (confirm) {
                                                if (userDetails.points < 100) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                            title:
                                                                Text('Error!'),
                                                            content: Text(
                                                                'You don\'t have enough points to claim.')),
                                                  );
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                            title: Text(
                                                                'Success!'),
                                                            content: Text(
                                                                'You have claimed the voucher.')),
                                                  );
                                                }
                                              }
                                            },
                                            child: Card(
                                                child: Container(
                                                    padding: Pad.pa12,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7lro1atlyYBgJ-azEDjIfk4uPXLz1YHZDog&usqp=CAU'))),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                            color: ThemeColors
                                                                .white,
                                                            child: Text(
                                                                '\$100 voucher in Welcome'))
                                                      ],
                                                    ))))),
                                ],
                              ),
                            ),
                          ))),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static Page<void> page() => MaterialPage<void>(child: ProfilePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: ProfileView(),
    );
  }
}

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
