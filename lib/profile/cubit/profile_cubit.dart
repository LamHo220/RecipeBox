import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  RecipeRepository repo = RecipeRepository();

  Future<QuerySnapshot<Recipe>> popularRecipes(String id) async {
    return repo.getRecipe('user', isEqualTo: id);
  }
}
