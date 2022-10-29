import 'package:recipe_api/recipe_api.dart';

class RecipeRepository {
  const RecipeRepository({
    required RecipeApi RecipeApi,
  }) : _RecipeApi = RecipeApi;

  final RecipeApi _RecipeApi;

  // Stream<List<Recipe>> getRecipe() => _RecipeApi.getRecipe();

  Future<void> createRecipe(Recipe recipe) => _RecipeApi.createRecipe(recipe);

  Future<void> deleteRecipe(String id) => _RecipeApi.deleteRecipe(id);

  Future<void> updateRecipe(String id, Recipe recipe) =>
      _RecipeApi.updateRecipe(id, recipe);
}
