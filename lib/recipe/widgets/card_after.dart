import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/recipe/widgets/recipe_steps.dart';
import 'package:recipe_repository/recipe_repository.dart';

class After extends StatelessWidget {
  const After({Key? key, required this.recipe, required this.closedContainer})
      : super(key: key);

  final Recipe recipe;
  final Function closedContainer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => closedContainer(),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: ThemeColors.white,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Column(children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              Image.network('https://picsum.photos/1024').image,
                          fit: BoxFit.cover)),
                  child: Container(
                    color: ThemeColors.halfGray,
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 8, bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          color: ThemeColors.white,
                        ),
                        Pad.w8,
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          direction: Axis.vertical,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Username',
                                  style: Style.cardTitle,
                                ),
                                Pad.w4,
                                Text(
                                  'lv. 11',
                                  style:
                                      Style.cardSubTitle.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                            const Text(
                              '999 recipe shared',
                              style: Style.cardSubTitle,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  color: ThemeColors.white,
                  height: MediaQuery.of(context).size.height * 0.7,
                  padding: EdgeInsetsDirectional.only(start: 12, end: 12),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: Pad.pa12,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.ideographic,
                                children: [
                                  Text(
                                    recipe.name,
                                    style: Style.heading,
                                  ),
                                  Pad.w8,
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.red[600],
                                        size: 16,
                                      ),
                                      Text(recipe.bookmarked.toString())
                                    ],
                                  ),
                                  Pad.w8,
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.codeFork,
                                        color: ThemeColors.gray,
                                        size: 16,
                                      ),
                                      Text(recipe.forked.toString())
                                    ],
                                  )
                                ],
                              ),
                              Pad.h8,
                              Container(
                                padding: Pad.pa12,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(12),
                                    border: Border.all(
                                      color: ThemeColors.inactive,
                                    )),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          recipe.cal.toString(),
                                          style: Style.highlightText,
                                        ),
                                        const Text(
                                          'cal',
                                          style: Style.label,
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          recipe.forked.toString(),
                                          style: Style.highlightText,
                                        ),
                                        const Text(
                                          'saved',
                                          style: Style.label,
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        // TODO rating
                                        Text(
                                          'rating',
                                          style: Style.highlightText,
                                        ),
                                        const Text(
                                          'rating',
                                          style: Style.label,
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          ' ${recipe.time['hours'] != '0' ? ('${recipe.time['hours']!}hr') : ''} ${recipe.time['minutes'] != '0' ? ('${recipe.time['minutes']!}mins') : ''}',
                                          style: Style.highlightText,
                                        ),
                                        const Text(
                                          'time needed',
                                          style: Style.label,
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          recipe.steps.length.toString(),
                                          style: Style.highlightText,
                                        ),
                                        const Text(
                                          'steps',
                                          style: Style.label,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Pad.h12,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.ideographic,
                                children: [
                                  const Text(
                                    'Ingredients',
                                    style: Style.heading,
                                  ),
                                  Text('6 items',
                                      style: Style.label.copyWith(
                                          color: ThemeColors.inactive))
                                ],
                              ),
                              Pad.h24,
                              for (Map<String, dynamic> i in recipe.ingredients)
                                Container(
                                  padding:
                                      EdgeInsetsDirectional.only(bottom: 24),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.ideographic,
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        color: ThemeColors.inactive,
                                      ),
                                      Pad.w8,
                                      Expanded(
                                        child: Text(i['name']!,
                                            style: Style.label),
                                      ),
                                      Text(
                                        i['value']!,
                                        style: Style.label.copyWith(
                                          color: ThemeColors.gray,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              Container(
                color: ThemeColors.white,
                width: double.infinity,
                padding: Pad.pa12,
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () => {},
                        child: Container(
                          padding: Pad.pa12,
                          decoration: BoxDecoration(
                              color: ThemeColors.card,
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(FontAwesomeIcons.heart),
                        )),
                    Pad.w8,
                    GestureDetector(
                        onTap: () => {},
                        child: Container(
                          padding: Pad.pa12,
                          decoration: BoxDecoration(
                              color: ThemeColors.card,
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(FontAwesomeIcons.codeFork),
                        )),
                    Pad.w8,
                    GestureDetector(
                        onTap: () => {},
                        child: Container(
                          padding: Pad.pa12,
                          decoration: BoxDecoration(
                              color: ThemeColors.card,
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(FontAwesomeIcons.commentDots),
                        )),
                    Pad.w8,
                    Expanded(
                        child: OpenContainer(closedBuilder: (context, open) {
                      return ElevatedButton(
                          style: _viewStepsStyle(),
                          onPressed: () => open(),
                          child: Container(
                            padding: EdgeInsetsDirectional.all(14),
                            child: Text('View Steps'),
                          ));
                    }, openBuilder: (context, close) {
                      return Steps(
                          name: recipe.name,
                          steps: recipe.steps,
                          closedContainer: closedContainer);
                    }))
                  ],
                ),
              )
            ],
          )),
    );
  }
}

ButtonStyle _viewStepsStyle() {
  return ButtonStyle(shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
    (Set<MaterialState> states) {
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    },
  ), elevation: MaterialStateProperty.resolveWith<double?>(
    (Set<MaterialState> states) {
      return 0;
    },
  ), backgroundColor: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      return ThemeColors.primaryLight;
    },
  ));
}
