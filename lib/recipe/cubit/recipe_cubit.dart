import 'package:authentication_repository/authentication_repository.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:recipe_box/explore/view/explore_page.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit()
      : super(RecipeState(steps: [], ingredients: [], categories: []));

  RecipeRepository recipeRepo = RecipeRepository();

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

  void calChanged(int value) {
    emit(state.copyWith(cal: value));
  }

  void gramChanged(int value) {
    emit(state.copyWith(gram: value));
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
        'name': TextEditingController(),
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

  void submit(User user) {
    recipeRepo.createRecipe(Recipe(
        name: state.name.value,
        description: state.description.value,
        bookmarked: 0,
        cal: state.cal,
        gram: state.gram,
        forked: 0,
        ingredients: state.ingredients
            .map((e) => {
                  'name': e['name']!.text as dynamic,
                  'value': e['value']!.text as dynamic,
                })
            .toList(),
        isPublic: state.isPublic,
        note: state.note,
        steps: state.steps.map((e) => e.text).toList(),
        categories: state.categories.map((e) => e.name).toList(),
        timestamp: Timestamp.now(),
        user: user.id,
        time: state.time));
  }

  void noteChanged(String value) {
    emit(state.copyWith(note: value));
  }

  void changeIsPublic(bool val) {
    emit(state.copyWith(isPublic: val));
  }

  void removeCategory(int i) {
    final categories = [...state.categories];
    categories.removeAt(i);
    emit(state.copyWith(categories: categories));
  }

  void onCategoriesChange(S2MultiSelected<Object?> value) {
    emit(state.copyWith(categories: value.value.cast()));
  }

  void deleteRecipe(Recipe recipe){
    recipeRepo.deleteRecipe(recipe.id);
  }
}
