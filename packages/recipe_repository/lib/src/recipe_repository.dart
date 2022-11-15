import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_repository/recipe_repository.dart';

class RecipeRepository {
  RecipeRepository() {}

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createRecipe(Recipe recipe) async {
    // store to firebase
    firestore
        .collection('recipes')
        .doc(recipe.id)
        .withConverter(
          fromFirestore: Recipe.fromFirestore,
          toFirestore: (Recipe recipe, _) => recipe.toFirestore(),
        )
        .set(recipe)
        .then((value) => print('DocumentSnapshot added with ID: ${recipe.id}'),
            onError: (e) => print("Error creating document $e"));
  }

  Future<void> deleteRecipe(String id) async {
    final ref = firestore.collection('recipes').doc(id);
    ref.collection('histories').get().then(
      (value) {
        for (DocumentSnapshot ds in value.docs) {
          ds.reference.delete();
        }
      },
      onError: (e) => print("Error updating document $e"),
    );

    ref.delete().then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error deleting document $e"),
        );
  }

  Future<void> updateRecipe(String id, Recipe recipe) async {
    final ref = firestore.collection('recipes').doc(id);

    ref.update(recipe.toFirestore()).then(
        (value) => print("Recipe updated, now update the timestamp"),
        onError: (e) => print("Error updating document $e"));

    ref.update({'timestamp': FieldValue.serverTimestamp()}).then(
        (value) => print("timestamp updated!"),
        onError: (e) => print("Error updating document $e"));

    ref
        .collection('histories')
        .add(recipe.toFirestore())
        .then((value) => print('history added'));
  }

  Future<QuerySnapshot<Recipe>> getRecipe(
    Object field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
  }) async {
    final ref = firestore.collection('recipes').withConverter(
          fromFirestore: Recipe.fromFirestore,
          toFirestore: (Recipe recipe, _) => recipe.toFirestore(),
        );
    return ref
        .where(
          field,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThan: isLessThan,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThan: isGreaterThan,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          whereNotIn: whereNotIn,
        )
        .get();
  }

  void addToFavorite(User user, Recipe recipe) {
    final ref = firestore.collection('users').doc(user.id);
    ref.update({
      "favorites": FieldValue.arrayUnion([recipe.id]),
    });
  }

  void removeFromFavorite(User user, Recipe recipe) {
    final ref = firestore.collection('users').doc(user.id);
    ref.update({
      "favorites": FieldValue.arrayRemove([recipe.id]),
    });
  }
}
