import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/controllers/state_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RecipeCard extends StatelessWidget {
  RecipeCard({Key? key}) : super(key: key);

  final Map<String, String> _details = {
    'cal': '234',
    'gram': '456',
    'rating': '4.7/5',
    'mins': '30',
    'steps': '5',
  };

  final List<Map<String, String>> _ingredients = [
    {'img': '', 'name': 'egg', 'detail': '3pc'},
    {'img': '', 'name': 'egg', 'detail': '3pc'},
    {'img': '', 'name': 'egg', 'detail': '3pc'},
    {'img': '', 'name': 'egg', 'detail': '3pc'},
    {'img': '', 'name': 'egg', 'detail': '3pc'},
    {'img': '', 'name': 'egg', 'detail': '3pc'},
  ];

  final stateController = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        transitionType: ContainerTransitionType.fadeThrough,
        closedElevation: 0,
        closedBuilder: (context, openContainer) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                stateController.setNav(true);
                openContainer();
              },
              child: Container(
                height: MediaQuery.of(context).size.width * 0.35,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            Image.network('https://picsum.photos/1024').image,
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
                                children: const [
                                  Text(
                                    'Food',
                                    style: Style.cardTitle,
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.access_time,
                                    color: ThemeColors.white,
                                    size: 16,
                                  ),
                                  Text(
                                    ' 30 mins',
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
        },
        openBuilder: (context, closedContainer) {
          return WillPopScope(
              child: Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      stateController.setNav(false);
                      closedContainer();
                    },
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
                                    image: Image.network(
                                            'https://picsum.photos/1024')
                                        .image,
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
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    direction: Axis.vertical,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            'Username',
                                            style: Style.cardTitle,
                                          ),
                                          Pad.w4,
                                          Text(
                                            'lv. 11',
                                            style: Style.cardSubTitle
                                                .copyWith(fontSize: 12),
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
                          SingleChildScrollView(
                            child: Container(
                              color: ThemeColors.white,
                              padding: EdgeInsetsDirectional.only(
                                  start: 12, end: 12),
                              child: Column(
                                children: [
                                  Container(
                                    padding: Pad.pa12,
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline:
                                              TextBaseline.ideographic,
                                          children: [
                                            Text(
                                              'Food',
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
                                                Text('1k')
                                              ],
                                            ),
                                            Pad.w8,
                                            Wrap(
                                              alignment: WrapAlignment.center,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.codeFork,
                                                  color: ThemeColors.gray,
                                                  size: 16,
                                                ),
                                                Text('1k')
                                              ],
                                            )
                                          ],
                                        ),
                                        Pad.h8,
                                        Container(
                                          padding: Pad.pa12,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadiusDirectional
                                                      .circular(12),
                                              border: Border.all(
                                                color: ThemeColors.inactive,
                                              )),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              for (MapEntry e
                                                  in _details.entries)
                                                Column(
                                                  children: [
                                                    Text(
                                                      e.value,
                                                      style:
                                                          Style.highlightText,
                                                    ),
                                                    Text(
                                                      e.key,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline:
                                              TextBaseline.ideographic,
                                          children: [
                                            Text(
                                              'Ingredients',
                                              style: Style.heading,
                                            ),
                                            Text('6 items',
                                                style: Style.label.copyWith(
                                                    color:
                                                        ThemeColors.inactive))
                                          ],
                                        ),
                                        Pad.h24,
                                        for (Map<String, String> i
                                            in _ingredients)
                                          Container(
                                            padding: EdgeInsetsDirectional.only(
                                                bottom: 24),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.baseline,
                                              textBaseline:
                                                  TextBaseline.ideographic,
                                              children: [
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  color: ThemeColors.inactive,
                                                ),
                                                Pad.w8,
                                                Expanded(
                                                  child: Text('Egg',
                                                      style: Style.label),
                                                ),
                                                Text(
                                                  '3pc',
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
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: const Icon(FontAwesomeIcons.heart),
                                  )),
                              Pad.w8,
                              GestureDetector(
                                  onTap: () => {},
                                  child: Container(
                                    padding: Pad.pa12,
                                    decoration: BoxDecoration(
                                        color: ThemeColors.card,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child:
                                        const Icon(FontAwesomeIcons.codeFork),
                                  )),
                              Pad.w8,
                              GestureDetector(
                                  onTap: () => {},
                                  child: Container(
                                    padding: Pad.pa12,
                                    decoration: BoxDecoration(
                                        color: ThemeColors.card,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: const Icon(
                                        FontAwesomeIcons.commentDots),
                                  )),
                              Pad.w8,
                              Expanded(
                                  child: ElevatedButton(
                                      style: _viewStepsStyle(),
                                      onPressed: () => {},
                                      child: Container(
                                        padding: EdgeInsetsDirectional.all(14),
                                        child: Text('View Steps'),
                                      )))
                            ],
                          ),
                        )
                      ],
                    )),
              ),
              onWillPop: () async {
                stateController.setNav(false);

                return true;
              });
        });
  }

  ButtonStyle _viewStepsStyle() {
    return ButtonStyle(
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
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
}
