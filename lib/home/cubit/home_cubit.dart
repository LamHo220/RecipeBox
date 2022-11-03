import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());
  RecipeRepository repo = RecipeRepository();

  void setTab(Tabs tab) => emit(HomeState(tab: tab));
  void setShow(bool flag) => emit(HomeState(isShow: flag));

  Future<QuerySnapshot<Recipe>> test() async {
    return repo.getRecipe('user', isNotEqualTo: '');
  }

  Future<QuerySnapshot<Recipe>> userFavorite() async {
    // Step 1: get user favorite list

    // Step 2: get the recipes

    // Step 3: get the user info of the recipe

    // return the recipes
    return repo.getRecipe('user', isNotEqualTo: '');
  }

  Future<QuerySnapshot<Recipe>> userRecipes() async {
    // Step 1: get user created list

    // Step 2: get the recipes

    // return the recipes
    return repo.getRecipe('user', isNotEqualTo: '');
  }

  Future<QuerySnapshot<Recipe>> popularRecipes() async {
    // Step 1: get the popular recipes

    // Step 2: get the user info of the recipe

    // return the recipes
    return repo.getRecipe('user', isNotEqualTo: '');
  }
}
