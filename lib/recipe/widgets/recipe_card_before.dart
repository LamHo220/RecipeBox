import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/recipe/bloc/recipe_bloc.dart';
import 'package:recipe_repository/recipe_repository.dart';

class Before extends StatelessWidget {
  const Before({Key? key, required this.recipe, required this.openContainer})
      : super(key: key);
  final Recipe recipe;
  final Function openContainer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc(recipe: null),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => openContainer(),
          child: BlocBuilder<RecipeBloc, RecipeState>(
            builder: (context, state) => FutureBuilder<Uint8List?>(
              future: context.read<RecipeBloc>().getImage(recipe.imgPath),
              builder: (context, snapshot) => Container(
                height: MediaQuery.of(context).size.width * 0.35,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: snapshot.data == null
                            ? Image.asset('assets/camera.png').image
                            : MemoryImage(snapshot.data!),
                        fit: BoxFit.cover)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: Pad.pa8,
                        width: double.infinity,
                        color: ThemeColors.halfGray,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    recipe.name,
                                    style: Style.cardTitle,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: ThemeColors.white,
                                    size: 16,
                                  ),
                                  Text(
                                    ' ${recipe.time['hr'] != '0' ? ('${recipe.time['hr']!}hr') : ''} ${recipe.time['min'] != '0' ? ('${recipe.time['min']!}mins') : ''}',
                                    style: Style.cardSubTitle,
                                  )
                                ],
                              ),
                            ]),
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
