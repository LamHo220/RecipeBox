import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit() : super(RecipeState());

  void titleChanged(String value) {
    final title = StringInput.dirty(value: value);
    emit(
      state.copyWith(
        title: title,
      ),
    );
  }
}
