import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_repository/recipe_repository.dart';

class Before extends StatelessWidget {
  const Before({Key? key, required this.recipe, required this.openContainer})
      : super(key: key);
  final Recipe recipe;
  final Function openContainer;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openContainer(),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.35,
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: Image.network('https://picsum.photos/1024').image,
                  fit: BoxFit.cover)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    margin: Pad.pa8,
                    padding: Pad.pa4,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: ThemeColors.halfGray,
                    ),
                    child: GestureDetector(
                      onTap: () => print(123),
                      child: Icon(
                        Icons.favorite_border,
                        color: ThemeColors.white,
                      ),
                    ),
                  ),
                ]),
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
                              ' ${recipe.time['hours'] != '0' ? ('${recipe.time['hours']!}hr') : ''} ${recipe.time['minutes'] != '0' ? ('${recipe.time['minutes']!}mins') : ''}',
                              style: Style.cardSubTitle,
                            )
                          ],
                        ),
                      ]),
                )
              ]),
        ),
      ),
    );
  }
}
