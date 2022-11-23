import 'dart:io';
import 'dart:math';

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

enum RAction { Fork, Add, Modify }

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc({this.recipe})
      : super(RecipeState(
            id: recipe != null ? recipe.id : '',
            name: StringInput.dirty(value: recipe != null ? recipe.name : ''),
            description: StringInput.dirty(
                value: recipe != null ? recipe.description : ''),
            note: recipe != null ? recipe.note : '',
            original: recipe?.original,
            // file: recipe != null ? XFile(recipe.imgPath) : null,
            cal: recipe != null ? recipe.cal : 0,
            gram: recipe != null ? recipe.gram : 0,
            time: recipe != null
                ? recipe.time.map((key, value) => MapEntry(key, value as int))
                : {'hr': 0, 'min': 0},
            isPublic: recipe != null ? recipe.isPublic : true,
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
            imgPath: recipe != null ? recipe.imgPath : "",
            categories: recipe != null
                ? recipe.categories.map((e) => _getCategory(e)).toList()
                : [])) {
    on<PickingImage>((_pickingImage));
    on<UnPickingImage>((_unpickingImage));
    on<CroppingImage>((_croppingImage));
  }

  final Recipe? recipe;
  RecipeRepository recipeRepo = RecipeRepository();

  Future<void> _pickingImage(
      PickingImage event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(file: event.file));
  }

  Future<void> _unpickingImage(
      UnPickingImage event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(file: null));
  }

  Future<void> _croppingImage(
      CroppingImage event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(file: XFile(event.file.path)));
  }

  Future<void> _unCroppingImage(
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
    if (action == RAction.Fork) {
      // recipeRepo.addImage(state.file, recipe!.id);
      print(123);
      recipeRepo.updateRecipe(recipe!.id,
          recipe!.copyWith(recipe!.id, forked: recipe!.forked + 1), false);
    }
    if (action == RAction.Modify) {
      // recipeRepo.addImage(state.file, recipe!.id);
      recipeRepo.updateRecipe(
          recipe!.id,
          recipe!.copyWith(
            recipe!.id,
            name: state.name.value,
            // imgPath:
            //     "gs://recipe-sum.appspot.com/${recipe!.id}.${state.file!.name.split('.').last}",
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

    if (action == RAction.Fork || action == RAction.Add) {
      Recipe _recipe = Recipe(
          imgPath: 'gs://recipe-sum.appspot.com/R.png',
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
          time: state.time);
      if (state.file != null) {
        recipeRepo.createRecipe(_recipe.copyWith(
          _recipe.id,
          imgPath:
              "gs://recipe-sum.appspot.com/${_recipe.id}.${state.file!.name.split('.').last}",
        ));
        // recipeRepo.addImage(state.file, _recipe.id);
      } else {
        recipeRepo.createRecipe(_recipe);
      }
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

  Future<Uint8List?> getImage(String file) async {
    final number = Random(3330).nextInt(10) + 1;
    return (await NetworkAssetBundle(Uri.parse(
                'https://foodish-api.herokuapp.com/images/dessert/dessert${number}.jpg'))
            .load(
                'https://foodish-api.herokuapp.com/images/dessert/dessert${number}.jpg'))
        .buffer
        .asUint8List();
    // Limited exceed, I use fixed image instead;
    // return recipeRepo.getImage(file);
  }
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
