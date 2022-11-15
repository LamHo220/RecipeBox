import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());
  RecipeRepository recipeRepo = RecipeRepository();

  void setTab(Tabs tab) => emit(HomeState(tab: tab));
  void setShow(bool flag) => emit(HomeState(isShow: flag));

  Future<QuerySnapshot<Recipe>> test() async {
    return recipeRepo.getRecipe('user', isNotEqualTo: '');
  }

  // Future<QuerySnapshot<Recipe>> userFavorite(User user) async {
  // Step 1: get user favorite list
  // List<String>? favorites = user.favorites;
  // if (favorites ==null ){
  //   return recipeRepo.getRecipe('user', isEqualTo: '');
  // }
  // Step 2: get the recipes
  // Step 3: get the user info of the recipe
  // Future<QuerySnapshot<Recipe>> recipes = recipeRepo.getRecipe('user', isEqualTo: user.id);
  // Future<QuerySnapshot<User>> users =
  // return the recipes
  // return recipes;
  // return;
  // }

  Future<QuerySnapshot<Recipe>> userRecipes(user) async {
    // Step 1: get user created list

    // Step 2: get the recipes

    // return the recipes
    print(user.id.toString());
    return recipeRepo.getRecipe('user', isEqualTo: user.id.toString());
  }

  Future<QuerySnapshot<Recipe>> popularRecipes() async {
    // Step 1: get the popular recipes

    // Step 2: get the user info of the recipe

    // return the recipes
    return recipeRepo.getRecipe('user', isNotEqualTo: '');
  }
}
