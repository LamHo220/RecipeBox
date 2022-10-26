import 'package:recipe_api/recipe_api.dart';

class RecipeRepository {
  const RecipeRepository({
    required RecipeApi RecipeApi,
  }) : _RecipeApi = RecipeApi;

  final RecipeApi _RecipeApi;

  Stream<List<Recipe>> getRecipe() => _RecipeApi.getRecipe();

  Future<void> saveRecipe(Recipe recipe) => _RecipeApi.saveRecipe(recipe);

  Future<void> deleteRecipe(String id) => _RecipeApi.deleteRecipe(id);
}
