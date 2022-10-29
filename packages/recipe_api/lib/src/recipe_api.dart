import 'package:recipe_api/recipe_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractRecipeApi {
  const AbstractRecipeApi();

  // Stream<List<Recipe>> getRecipe();

  Future<void> createRecipe(Recipe recipe);
  Future<void> deleteRecipe(String id);
  Future<void> updateRecipe(String id, Recipe recipe);
}

class RecipeNotFoundException implements Exception {}

class RecipeApi extends AbstractRecipeApi {
  RecipeApi() {}
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // {
  // required SharedPreferences plugin,
  // }
  // :
  // _plugin = plugin {
  // _init();
  // }
  // final SharedPreferences _plugin;
  // final _recipeStreamController =
  //     BehaviorSubject<List<Recipe>>.seeded(const []);

  // @visibleForTesting
  // static const kRecipeCollectionKey = '__recipe_collection_key__';

  // String? _getValue(String key) => _plugin.getString(key);
  // Future<void> _setValue(String key, String value) =>
  // _plugin.setString(key, value);

  // void _init() {
  // final recipeJson = _getValue(kRecipeCollectionKey);
  // if (recipeJson != null) {
  //   final recipe = List<Map<dynamic, dynamic>>.from(
  //     json.decode(recipeJson) as List,
  //   )
  //       .map((jsonMap) => Recipe.fromJson(Map<String, dynamic>.from(jsonMap)))
  //       .toList();
  //   _recipeStreamController.add(recipe);
  // } else {
  //   _recipeStreamController.add(const []);
  // }
  // }

  // @override
  // Stream<List<Recipe>> getRecipe() =>
  //     _recipeStreamController.asBroadcastStream();

  @override
  Future<void> createRecipe(Recipe recipe) async {
    // store to firebase
    firestore.collection('recipes').doc(recipe.id).set(recipe.toJson()).then(
        (value) => print('DocumentSnapshot added with ID: ${recipe.id}'),
        onError: (e) => print("Error creating document $e"));
  }

  @override
  Future<void> deleteRecipe(String id) async {}

  @override
  Future<void> updateRecipe(String id, Recipe recipe) async {
    final ref = firestore.collection('recipes').doc(id);
    ref.update(recipe.toJson()).then(
        (value) => print("Recipe updated, now update the timestamp"),
        onError: (e) => print("Error updating document $e"));
    ref.update({'timestamp': FieldValue.serverTimestamp()}).then(
        (value) => print("timestamp updated!"),
        onError: (e) => print("Error updating document $e"));
    ref
        .collection('histories')
        .add(recipe.toJson())
        .then((value) => print('history added'));
  }
}
