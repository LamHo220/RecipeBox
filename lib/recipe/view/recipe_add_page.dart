import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              _TitleInput(),
              Pad.h12,
              _DescriptionInput(),
              Text(
                'Ingredients',
                style: Style.heading,
              ),
              Pad.h4,

              // TODO: button to add ingredients
              // TODO: show the list of ingredients
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () => {},
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
              // TODO: button to add steps
              // TODO: show the list of steps
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

class _TitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return TextFormField(
          key: const Key('title_input_textField'),
          keyboardType: TextInputType.text,
          onChanged: (value) => context.read<RecipeCubit>().titleChanged(value),
          decoration: InputDecoration(
            labelText: 'title*',
            errorText: state.title.invalid ? 'required' : null,
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
          decoration: InputDecoration(
            labelText: 'description',
            alignLabelWithHint: true,
            errorText: state.description.invalid ? 'required' : null,
          ),
        );
      },
    );
  }
}
