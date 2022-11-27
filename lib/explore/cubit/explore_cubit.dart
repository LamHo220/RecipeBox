import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit() : super(ExploreInitial());
  RecipeRepository repo = RecipeRepository();

  Future<QuerySnapshot<Recipe>> getRecipeByCategory(String category) {
    return repo.getRecipe('category', arrayContainsAny: [category]);
  }
}
