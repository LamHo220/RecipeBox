import 'package:animations/animations.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/home/cubit/home_cubit.dart';
import 'package:recipe_box/home/home.dart';
import 'package:recipe_box/recipe/bloc/recipe_bloc.dart';
import 'package:recipe_box/recipe/view/recipe_detail_page.dart';
import 'package:recipe_repository/recipe_repository.dart';

class RecipeItem extends StatelessWidget {
  RecipeItem({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RecipeBloc(),
        child: FutureBuilder<Uint8List?>(
          future: context.read<HomeCubit>().getImage(recipe.imgPath),
          builder: (context, snapshot) {
            final decoratedImage = DecorationImage(
                image: snapshot.data == null
                    ? Image.asset('assets/logo.png').image
                    : MemoryImage(snapshot.data!),
                fit: BoxFit.cover);
            return OpenContainer(
                transitionDuration: const Duration(milliseconds: 500),
                transitionType: ContainerTransitionType.fadeThrough,
                closedElevation: 0,
                closedBuilder: (context, openContainer) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColors.white,
                          foregroundColor: ThemeColors.card,
                          padding: EdgeInsets.all(16)),
                      onPressed: () => openContainer(),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Avatar(),
                                Pad.w4,
                                FutureBuilder<QuerySnapshot<UserDetails>>(
                                  future: context
                                      .read<HomeCubit>()
                                      .getUserDetails(recipe.user),
                                  builder: (context, snapshot) => Text(
                                      snapshot.data != null &&
                                              snapshot.data!.docs.isNotEmpty
                                          ? snapshot.data!.docs.first
                                              .data()
                                              .username
                                          : recipe.user,
                                      style: Style.search.copyWith(
                                          fontWeight: FontWeight.w400)),
                                ),
                              ],
                            ),
                            Pad.h12,
                            Text(
                              recipe.name,
                              style: Style.label,
                            ),
                            Pad.h12,
                            Text(
                              recipe.description,
                              maxLines: 5,
                              style: Style.search
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                            Pad.h12,
                            Row(
                              children: [
                                Icon(Icons.favorite, color: Colors.red[400]),
                                Pad.w4,
                                Text(
                                  recipe.bookmarked.toString(),
                                  style: Style.search,
                                ),
                                Pad.w8,
                                Icon(FontAwesomeIcons.codeFork,
                                    color: ThemeColors.gray, size: 20),
                                Pad.w4,
                                Text(
                                  recipe.forked.toString(),
                                  style: Style.search,
                                ),
                                Pad.w8,
                                Icon(
                                  Icons.comment,
                                  color: Colors.blue[400],
                                ),
                                Pad.w4,
                                FutureBuilder<
                                        QuerySnapshot<Map<String, dynamic>>>(
                                    future: context
                                        .read<HomeCubit>()
                                        .getRateByRecipe(recipe),
                                    builder: (context, snapshot) {
                                      if (snapshot.data == null ||
                                          snapshot.data!.docs.isEmpty) {
                                        return Text(
                                          '0',
                                          style: Style.search,
                                        );
                                      }
                                      final ratings = snapshot.data!.docs
                                          .map((e) => e['rating']);
                                      final s = ratings.reduce(
                                          (value, element) => value + element);
                                      return Text(
                                        '${(s / ratings.length).toStringAsFixed(1)}',
                                        style: Style.search,
                                      );
                                    }),
                              ],
                            )
                          ]),
                    ),
                openBuilder: (context, closeContainer) =>
                    FutureBuilder<QuerySnapshot<UserDetails>>(
                        future: context
                            .read<HomeCubit>()
                            .getUserDetails(recipe.user),
                        builder: (context, snapshot) {
                          return
                              // if (snapshot.data == null) {
                              //   return Container();
                              // }
                              // return
                              RecipeDetails(
                            recipe: recipe,
                            closedContainer: closeContainer,
                            decoratedImage: decoratedImage,
                          );
                        }));
          },
        ));
  }
}
