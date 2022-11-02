import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/explore/cubit/explore_cubit.dart';

class ExploreView extends StatelessWidget {
  ExploreView({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: Pad.pa24,
          child: Text(
            'Explore',
            style: Style.welcome,
          ),
        ),
        Container(
          padding: Pad.plr24,
          child: CupertinoSearchTextField(
              controller: _searchController,
              padding: Pad.pa12,
              borderRadius: BorderRadius.circular(16),
              placeholder: 'Search by recipes',
              style: Style.search,
              backgroundColor: ThemeColors.card,
              prefixInsets: const EdgeInsetsDirectional.fromSTEB(18, 4, 0, 4)),
        ),
        Container(
          padding: Pad.pa24,
          child: Text(
            'Discover',
            style: Style.heading,
          ),
        ),
        Container(
          padding: Pad.pa24,
          child: Text(
            'Categories',
            style: Style.heading,
          ),
        )
      ],
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});
  static Page<void> page() => MaterialPage<void>(child: ExplorePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExploreCubit(),
      child: ExploreView(),
    );
  }
}
