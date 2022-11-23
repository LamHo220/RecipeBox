import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());
  RecipeRepository recipeRepo = RecipeRepository();
  AuthenticationRepository _repo = AuthenticationRepository();

  void setTab(Tabs tab) => emit(state.copyWith(tab: tab));
  void setFlag(bool flag) => emit(state.copyWith(flag: flag));

  Future<QuerySnapshot<Recipe>> userFavorite(UserDetails userDetails) async {
    List<String>? favorites = userDetails.favorites;
    if (favorites.isEmpty) {
      return recipeRepo.getRecipe('id', isEqualTo: '');
    }
    return recipeRepo.getRecipe('id', whereIn: favorites);
  }

  Future<QuerySnapshot<Recipe>> userRecipes(User user) async {
    return recipeRepo.getRecipe('user', isEqualTo: user.id);
  }

  Future<QuerySnapshot<Recipe>> popularRecipes() async {
    return recipeRepo.getRecipe('isPublic', isEqualTo: true);
  }

  Future<QuerySnapshot<Recipe>> getRecipesByCategory(String category) async {
    return recipeRepo
        .getRecipe('categories', arrayContains: category)
        .then((value) {
      value.docs.removeWhere((e) => !e.data().isPublic);
      return value;
    });
  }

  Future<QuerySnapshot<Recipe>> getUser(String id) async {
    return recipeRepo.getRecipe('user', isEqualTo: id);
  }

  void addToFavorite(Recipe recipe) {
    recipeRepo.addToFavorite(state.userDetails, recipe);
    final x = [...state.userDetails.favorites];
    x.add(recipe.id);
    emit(state.copyWith(
        userDetails: UserDetails(
            username: state.userDetails.username,
            id: state.userDetails.id,
            description: state.userDetails.description,
            level: state.userDetails.level,
            points: state.userDetails.points,
            exp: state.userDetails.exp,
            follows: state.userDetails.follows,
            favorites: x)));
  }

  void removeFromFavorite(Recipe recipe, bool isDelete) {
    recipeRepo.removeFromFavorite(state.userDetails, recipe, isDelete);
    final x = [...state.userDetails.favorites];
    x.remove(recipe.id);
    emit(state.copyWith(
        userDetails: UserDetails(
            id: state.userDetails.id,
            username: state.userDetails.username,
            description: state.userDetails.description,
            level: state.userDetails.level,
            points: state.userDetails.points,
            exp: state.userDetails.exp,
            follows: state.userDetails.follows,
            favorites: x)));
  }

  void updateUserDetails(UserDetails userDetails) {
    emit(state.copyWith(userDetails: userDetails));
  }

  Future<QuerySnapshot<UserDetails>> getUserDetails(String id) {
    return _repo.getUserDetails(id);
  }

  void rate(Recipe recipe, double rating, String comment, User user) {
    recipeRepo.rate(recipe, rating, comment, user);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getRate(
      Recipe recipe, User user) {
    return recipeRepo.getRate(recipe, user);
  }

  Future<void> updateRate(
      Recipe recipe, double rating, String comment, User user) async {
    await recipeRepo.updateRate(recipe, rating, comment, user);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getRateByRecipe(Recipe recipe) {
    return recipeRepo.getRateByRecipe(recipe);
  }

  Future<QuerySnapshot<Recipe>> gerRecipeById(String? id) {
    return recipeRepo.getRecipe('id', isEqualTo: id);
  }

  void addExp(User user, int exp) {
    _repo.addExp(user, exp);
  }
}
