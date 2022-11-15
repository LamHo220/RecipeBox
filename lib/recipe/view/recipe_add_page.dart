import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:recipe_box/app/app.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';
import 'package:recipe_box/recipe/cubit/recipe_cubit.dart';

class RecipeAddView extends StatelessWidget {
  const RecipeAddView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc value) => value.state.user);
    final userDetails =
        context.select((AppBloc value) => value.state.userDetails);

    final recipe = context.select((RecipeCubit value) => value.state);

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Add Recipe'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: ThemeColors.text,
        ),
        body: SafeArea(
          bottom: true,
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                alignment: Alignment.bottomLeft,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        // TODO: iamge picker
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
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              Text(
                                user.username ?? user.email ?? '',
                                style: Style.cardTitle,
                              ),
                              Pad.w4,
                              Text(
                                'lv${userDetails.level}',
                                style:
                                    Style.cardSubTitle.copyWith(fontSize: 12),
                              )
                            ],
                          ),
                          Text(
                            "${userDetails.publicRecipes.length} recipes shared",
                            style: Style.cardSubTitle,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.only(start: 12, end: 12),
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
                              Expanded(child: _NameInput()),
                              Pad.w8,
                              Expanded(
                                flex: 2,
                                child: Row(children: [
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
                                      Text('0')
                                    ],
                                  ),
                                  Pad.w8,
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: const [
                                      Icon(
                                        FontAwesomeIcons.codeFork,
                                        color: ThemeColors.gray,
                                        size: 16,
                                      ),
                                      Text('0')
                                    ],
                                  )
                                ]),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    // TODO
                                    _CalInput(),
                                    Text(
                                      'cal',
                                      style: Style.label.copyWith(fontSize: 12),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    _GramInput(),
                                    Text(
                                      'gram',
                                      style: Style.label.copyWith(fontSize: 12),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '0',
                                      style: Style.highlightText,
                                    ),
                                    Text(
                                      'rating',
                                      style: Style.label.copyWith(fontSize: 12),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    _TimeInput(),
                                    Text(
                                      'is needed',
                                      style: Style.label.copyWith(fontSize: 12),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      recipe.steps.length.toString(),
                                      style: Style.highlightText,
                                    ),
                                    Text(
                                      'steps',
                                      style: Style.label.copyWith(fontSize: 12),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Pad.h12,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              const Text(
                                'Ingredients',
                                style: Style.heading,
                              ),
                              Text('${recipe.ingredients.length} items',
                                  style: Style.label
                                      .copyWith(color: ThemeColors.inactive))
                            ],
                          ),
                          Pad.h24,
                          _IngredientInput(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    context.read<RecipeCubit>().addIngredient();
                                  },
                                  icon: Icon(Icons.add_circle_outline_outlined))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              const Text(
                                'Steps',
                                style: Style.heading,
                              ),
                              Text('${recipe.ingredients.length} steps',
                                  style: Style.label
                                      .copyWith(color: ThemeColors.inactive))
                            ],
                          ),
                          Pad.h24,
                          _StepInput(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    context.read<RecipeCubit>().addSteps();
                                  },
                                  icon: Icon(Icons.add_circle_outline_outlined))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              const Text(
                                'Notes from you',
                                style: Style.heading,
                              ),
                            ],
                          ),
                          _NoteInput(),
                          Pad.h24,
                          Row(
                            children: [
                              Text(
                                'Is Public?',
                                style: Style.heading,
                              ),
                              _SetIsPublic()
                            ],
                          ),
                          Pad.h24,
                          ElevatedButton(
                            onPressed: () =>
                                context.read<RecipeCubit>().submit(user),
                            child: Text('Post'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeColors.primaryLight),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}

class RecipeAddPage extends StatelessWidget {
  RecipeAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecipeCubit(),
      child: RecipeAddView(),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextFormField(
          key: const Key('name_input_textField'),
          keyboardType: TextInputType.text,
          onChanged: (value) => context.read<RecipeCubit>().nameChanged(value),
          style: Style.heading,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            border: UnderlineInputBorder(),
            labelText: 'name*',
            errorText: state.name.invalid ? 'required' : null,
          ),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return TextFormField(
          key: const Key('description_input_textField'),
          minLines: 2,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          onChanged: (value) =>
              context.read<RecipeCubit>().descriptionChanged(value),
          decoration: const InputDecoration(
            labelText: 'description',
            alignLabelWithHint: true,
            // errorText: state.description.invalid ? 'required' : null,
          ),
        );
      },
    );
  }
}

class _StepInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
        buildWhen: (previous, current) =>
            previous.steps.length != current.steps.length,
        builder: (context, state) => state.steps.isNotEmpty
            ? ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: state.steps.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                  color: ThemeColors.white,
                ),
                key: Key('steps'),
                itemBuilder: (context, index) => TextField(
                  controller: state.steps[index],
                  // onChanged: (value) =>
                  //     context.read<RecipeCubit>().stepChanged(index, value),
                  decoration: InputDecoration(
                      labelText: 'step ${(index + 1)}*',
                      errorText:
                          state.steps[index].text.isEmpty ? 'required' : null,
                      suffixIcon: IconButton(
                          onPressed: () =>
                              context.read<RecipeCubit>().deleteStep(index),
                          icon: Icon(Icons.close))),
                ),
              )
            : Container());
  }
}

class _IngredientInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
        buildWhen: (previous, current) =>
            previous.ingredients != current.ingredients,
        builder: (context, state) => state.ingredients.isNotEmpty
            ? ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: state.ingredients.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                  color: ThemeColors.white,
                ),
                key: Key('ingredients'),
                itemBuilder: (context, index) => Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: state.ingredients[index]['item'],

                        // onChanged: (value) =>
                        //     context.read<RecipeCubit>().stepChanged(index, value),
                        decoration: InputDecoration(
                          labelText: 'item ${(index + 1)}*',
                          helperText: 'required',
                          errorText:
                              state.ingredients[index]['item']!.text.isEmpty
                                  ? 'required'
                                  : null,
                        ),
                      ),
                    ),
                    Pad.w4,
                    Expanded(
                        child: TextField(
                      controller: state.ingredients[index]['value'],
                      // onChanged: (value) =>
                      //     context.read<RecipeCubit>().stepChanged(index, value),
                      decoration: InputDecoration(
                          labelText: 'serving size ${(index + 1)}*',
                          helperText: 'required',
                          errorText:
                              state.ingredients[index]['value']!.text.isEmpty
                                  ? 'required'
                                  : null,
                          suffixIcon: IconButton(
                              onPressed: () => context
                                  .read<RecipeCubit>()
                                  .deleteIngredient(index),
                              icon: Icon(Icons.close))),
                    ))
                  ],
                ),
              )
            : Container());
  }
}

class _CalInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
      buildWhen: (previous, current) => previous.cal != current.cal,
      builder: (context, state) {
        return NumberPicker(
            minValue: 0,
            itemCount: 1,
            itemWidth: 48 * state.cal.toString().length.toDouble() / 3,
            selectedTextStyle: Style.highlightText,
            step: 50,
            textStyle: Style.label,
            itemHeight: 35,
            maxValue: 100000,
            value: state.cal,
            onChanged: (value) =>
                context.read<RecipeCubit>().calChanged(value));
      },
    );
  }
}

class _GramInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
      buildWhen: (previous, current) => previous.gram != current.gram,
      builder: (context, state) {
        return NumberPicker(
            minValue: 0,
            itemCount: 1,
            itemWidth: 48 * state.cal.toString().length.toDouble() / 3,
            selectedTextStyle: Style.highlightText,
            step: 50,
            textStyle: Style.label,
            itemHeight: 35,
            maxValue: 100000,
            value: state.gram,
            onChanged: (value) =>
                context.read<RecipeCubit>().gramChanged(value));
        // TextFormField(
        //   key: const Key('gram_input_textField'),
        //   keyboardType: TextInputType.number,
        //   onChanged: (value) => context.read<RecipeCubit>().gramChanged(value),
        //   decoration: InputDecoration(
        //       errorText: state.gram == 0 ? 'required' : null,
        //       labelText: 'gram',
        //       alignLabelWithHint: true,
        //       suffixText: 'gram'),
        // );
      },
    );
  }
}

class _TimeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = context.select((RecipeCubit value) => value.state.time)['hr'];

    final minute =
        context.select((RecipeCubit value) => value.state.time)['min'];

    void updateHour(int value) {
      context.read<RecipeCubit>().setHour(value);
    }

    void updateMinute(int value) {
      context.read<RecipeCubit>().setMinute(value);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        NumberPicker(
          value: hour!,
          minValue: 0,
          itemCount: 1,
          itemWidth: 48 * hour.toString().length.toDouble() / 3,
          selectedTextStyle: Style.highlightText,
          step: 1,
          textStyle: Style.label,
          itemHeight: 35,
          maxValue: 23,
          onChanged: (value) => updateHour(value),
        ),
        const Text(
          ' hr',
          style: Style.search,
        ),
        NumberPicker(
          value: minute!,
          minValue: 0,
          itemCount: 1,
          itemWidth: 48 * minute.toString().length.toDouble() / 3,
          selectedTextStyle: Style.highlightText,
          step: 1,
          textStyle: Style.label,
          itemHeight: 35,
          maxValue: 59,
          onChanged: (value) => updateMinute(value),
        ),
        const Text(
          ' min',
          style: Style.search,
        ),
      ],
    );
  }
}

class _NoteInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
      buildWhen: (previous, current) => previous.note != current.note,
      builder: (context, state) {
        return TextFormField(
          key: const Key('note_input_textField'),
          minLines: 1,
          maxLines: 100,
          keyboardType: TextInputType.text,
          onChanged: (value) => context.read<RecipeCubit>().noteChanged(value),
          style: Style.heading,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            border: UnderlineInputBorder(),
            labelText: 'note*',
            // errorText: state.note ? 'required' : null,
          ),
        );
      },
    );
  }
}

class _SetIsPublic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
        buildWhen: (previous, current) => previous.isPublic != current.isPublic,
        builder: (context, state) {
          return Switch(
              value: state.isPublic,
              activeColor: ThemeColors.primaryLight,
              onChanged: (val) =>
                  context.read<RecipeCubit>().changeIsPublic(val));
        });
  }
}
