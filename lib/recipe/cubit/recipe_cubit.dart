import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit()
      : super(RecipeState(steps: [], ingredients: [], categories: []));

  void nameChanged(String value) {
    final name = StringInput.dirty(value: value);
    emit(
      state.copyWith(
        name: name,
      ),
    );
  }

  void descriptionChanged(String value) {
    final description = StringInput.dirty(value: value);
    emit(
      state.copyWith(
        description: description,
      ),
    );
  }

  void calChanged(double? value) {
    emit(
      state.copyWith(
        cal: value,
      ),
    );
  }

  void gramChanged(double? value) {
    emit(
      state.copyWith(
        gram: value,
      ),
    );
  }

  void setHour(int value) {
    emit(state.copyWith(time: {'hr': value, 'min': state.time['min'] ?? 0}));
  }

  void setMinute(int value) {
    emit(state.copyWith(time: {'min': value, 'hr': state.time['hr'] ?? 0}));
  }

  void addSteps() {
    emit(state.copyWith(steps: [...state.steps, TextEditingController()]));
  }

  void addIngredient() {
    emit(state.copyWith(ingredients: [
      ...state.ingredients,
      {
        'item': TextEditingController(),
        'value': TextEditingController(),
      }
    ]));
  }

  void deleteStep(int i) {
    List<TextEditingController> x = [...state.steps];
    try {
      x.removeAt(i);
    } catch (_) {}
    emit(state.copyWith(steps: x));
  }

  void deleteIngredient(int i) {
    List<Map<String, TextEditingController>> x = [...state.ingredients];
    try {
      x.removeAt(i);
    } catch (_) {}
    emit(state.copyWith(ingredients: x));
  }
}
