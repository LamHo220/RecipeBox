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

  Future<QuerySnapshot<Recipe>> userFavorite(UserDetails userDetails) async {
    List<String>? favorites = userDetails.favorites;
    print(favorites);
    if (favorites.isEmpty) {
      return recipeRepo.getRecipe('id', isEqualTo: '');
    }
    return recipeRepo.getRecipe('id', whereIn: favorites);
  }

  Future<QuerySnapshot<Recipe>> userRecipes(User user) async {
    return recipeRepo.getRecipe('user', isEqualTo: user.id);
  }

  Future<QuerySnapshot<Recipe>> popularRecipes() async {
    return recipeRepo.getRecipe('user', isNotEqualTo: '');
  }

  Future<QuerySnapshot<Recipe>> getRecipes(String category) async {
    return recipeRepo
        .getRecipe('categories', arrayContains: category)
        .then((value) {
      value.docs.removeWhere((e) => !e.data().isPublic);
      return value;
    });
  }
}
