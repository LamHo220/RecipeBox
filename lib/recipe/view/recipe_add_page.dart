import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: ThemeColors.text,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: Pad.plr16,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Basic info',
                style: Style.heading,
              ),
              Pad.h4,
              _NameInput(),
              Pad.h12,
              _DescriptionInput(),
              Pad.h12,
              _CalInput(),
              Pad.h12,
              _GramInput(),
              Pad.h12,
              _TimeInput(),
              Text(
                'Ingredients',
                style: Style.heading,
              ),
              Pad.h4,
              _IngredientInput(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () =>
                          context.read<RecipeCubit>().addIngredient(),
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: ThemeColors.gray,
                      )),
                ],
              ),
              Text(
                'Steps',
                style: Style.heading,
              ),
              Pad.h4,
              _StepInput(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () => context.read<RecipeCubit>().addSteps(),
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: ThemeColors.gray,
                      )),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
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
          decoration: InputDecoration(
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
        builder: (context, state) => ListView.separated(
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
            ));
  }
}

class _IngredientInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
        buildWhen: (previous, current) =>
            previous.ingredients != current.ingredients,
        builder: (context, state) => ListView.separated(
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
            ));
  }
}

class _CalInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
      buildWhen: (previous, current) => previous.cal != current.cal,
      builder: (context, state) {
        return TextFormField(
          key: const Key('cal_input_textField'),
          keyboardType: TextInputType.number,
          onChanged: (value) => context
              .read<RecipeCubit>()
              .calChanged(value == '' ? 0 : double.tryParse(value)),
          decoration: InputDecoration(
              labelText: 'calories',
              errorText: state.cal == 0 ? 'required' : null,
              alignLabelWithHint: true,
              suffixText: 'cals'),
        );
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
        return TextFormField(
          key: const Key('gram_input_textField'),
          keyboardType: TextInputType.number,
          onChanged: (value) => context
              .read<RecipeCubit>()
              .gramChanged(value.isEmpty ? 0 : double.tryParse(value)),
          decoration: InputDecoration(
              errorText: state.gram == 0 ? 'required' : null,
              labelText: 'gram',
              alignLabelWithHint: true,
              suffixText: 'gram'),
        );
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

    void s() {
      showModal(
          context: context,
          builder: (_) => BlocProvider.value(
              value: context.read<RecipeCubit>(),
              child: Dialog(
                  child: Container(
                padding: Pad.ptb24,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  NumberPicker(
                    value: hour!,
                    minValue: 0,
                    maxValue: 23,
                    onChanged: (value) => updateHour(value),
                  ),
                  Text('hour', style: Style.label),
                  NumberPicker(
                    value: minute!,
                    minValue: 0,
                    maxValue: 59,
                    onChanged: (value) => updateMinute(value),
                  ),
                  Text('minutes', style: Style.label),
                ]),
              ))));
    }

    return Row(
      children: [
        const Text(
          'Time of cooking: ',
          style: Style.search,
        ),
        NumberPicker(
          value: hour!,
          minValue: 0,
          maxValue: 23,
          infiniteLoop: true,
          onChanged: (value) => updateHour(value),
          itemWidth: 50,
          itemCount: 3,
          itemHeight: 30,
        ),
        const Text(
          'hr',
          style: Style.search,
        ),
        NumberPicker(
          value: minute!,
          minValue: 0,
          maxValue: 59,
          infiniteLoop: true,
          itemWidth: 50,
          itemCount: 3,
          itemHeight: 30,
          onChanged: (value) => updateMinute(value),
        ),
        const Text(
          'min',
          style: Style.search,
        ),
      ],
    );
  }
}
