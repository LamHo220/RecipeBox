import 'package:recipe_api/recipe_api.dart';

abstract class RecipeApi {
  const RecipeApi();

  Stream<List<Recipe>> getRecipe();

  Future<void> saveRecipe(Recipe recipe);
  Future<void> deleteRecipe(String id);
}

class TodoNotFoundException implements Exception {}
