import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formz/formz.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_box/explore/view/explore_page.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

enum RAction { fork, add, modify }

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc({this.recipe})
      : super(RecipeState(
            id: recipe != null ? recipe.id : '',
            name: StringInput.dirty(value: recipe != null ? recipe.name : ''),
            description: StringInput.dirty(
                value: recipe != null ? recipe.description : ''),
            note: recipe != null ? recipe.note : '',
            original: recipe?.original,
            cal: recipe != null ? recipe.cal : 0,
            gram: recipe != null ? recipe.gram : 0,
            time: recipe != null
                ? recipe.time.map((key, value) => MapEntry(key, value as int))
                : {'hr': 0, 'min': 0},
            isPublic: true,
            steps: recipe != null
                ? recipe.steps
                    .map((e) => TextEditingController(text: e))
                    .toList()
                : [],
            ingredients: recipe != null
                ? recipe.ingredients
                    .map((e) => {
                          'name': TextEditingController(text: e['name']),
                          'value': TextEditingController(text: e['value'])
                        })
                    .toList()
                : [],
            file: recipe != null
                ? XFile(recipe.imgPath)
                : XFile('assets/camera.png'),
            categories: recipe != null
                ? recipe.categories.map((e) => _getCategory(e)).toList()
                : [])) {
    on<PickingImage>((event, emit) => (_pickingImage));
    on<UnPickingImage>((event, emit) => (_unpickingImage));
    on<CroppingImage>((event, emit) => (_croppingImage));
  }

  final Recipe? recipe;
  RecipeRepository recipeRepo = RecipeRepository();

  Future _pickingImage(PickingImage event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(file: event.file));
  }

  Future _unpickingImage(
      UnPickingImage event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(file: null));
  }

  Future _croppingImage(CroppingImage event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(file: XFile(event.file.path)));
  }

  Future _unCroppingImage(
      UnCroppingImage event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(file: null));
  }

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

  void calChanged(int value) => emit(state.copyWith(cal: value));

  void gramChanged(int value) => emit(state.copyWith(gram: value));

  void setHour(int value) =>
      emit(state.copyWith(time: {'hr': value, 'min': state.time['min'] ?? 0}));

  void setMinute(int value) =>
      emit(state.copyWith(time: {'min': value, 'hr': state.time['hr'] ?? 0}));

  void addSteps() =>
      emit(state.copyWith(steps: [...state.steps, TextEditingController()]));

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

  void submit(User user, RAction action) {
    if (action == RAction.fork) {
      recipeRepo.updateRecipe(recipe!.id,
          recipe!.copyWith(recipe!.id, forked: recipe!.forked + 1), false);
    }
    if (action == RAction.modify) {
      recipeRepo.updateRecipe(
          recipe!.id,
          recipe!.copyWith(
            recipe!.id,
            name: state.name.value,
//  imgPath:state.imgPath,
            description: state.description.value,
            cal: state.cal,
            gram: state.gram,
            ingredients: state.ingredients
                .map((e) => e.map((key, value) => MapEntry(key, value.text)))
                .toList(),
            isPublic: state.isPublic,
            note: state.note,
            steps: state.steps.map((e) => e.text).toList(),
            categories: state.categories.map((e) => e.name).toList(),
            user: user.id,
            time: state.time,
          ),
          true);
    }

    if (action == RAction.fork || action == RAction.add) {
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
          original: recipe?.id,
          time: state.time));
    }
  }

  void noteChanged(String value) => emit(state.copyWith(note: value));

  void changeIsPublic(bool val) => emit(state.copyWith(isPublic: val));

  void removeCategory(int i) {
    final categories = [...state.categories];
    categories.removeAt(i);
    emit(state.copyWith(categories: categories));
  }

  void onCategoriesChange(S2MultiSelected<Object?> value) =>
      emit(state.copyWith(categories: value.value.cast()));

  void deleteRecipe(Recipe recipe) => recipeRepo.deleteRecipe(recipe.id);
}

Categories _getCategory(String e) {
  if (e == Categories.Breakfast.name) {
    return Categories.Breakfast;
  } else if (e == Categories.Dessert.name) {
    return Categories.Dessert;
  } else if (e == Categories.Dinner.name) {
    return Categories.Dinner;
  } else if (e == Categories.Lunch.name) {
    return Categories.Lunch;
  }
  return Categories.Vegetable;
}
