import 'dart:io';
import 'dart:typed_data';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_repository/recipe_repository.dart';

class RecipeRepository {
  RecipeRepository() {}

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();

  // Firebase storage limit exceed, I disabled the functions on it.

  // Future<void> updateImage(XFile? file, String id) async {
  //   if (file == null) {
  //     return;
  //   }
  //   final imageRef = storageRef.child("${id}.jpg");
  //   try {
  //     await imageRef.putFile(File(file.path));
  //   } on FirebaseException catch (e) {}
  // }

  // Future<void> addImage(XFile? file, String id) async {
  //   if (file == null) {
  //     return;
  //   }
  //   final imageRef = storageRef.child("${id}.jpg");
  //   try {
  //     await imageRef.putFile(File(file.path));
  //   } on FirebaseException catch (e) {}
  // }

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

  Future<void> updateRecipe(String id, Recipe recipe, bool history) async {
    final ref = firestore.collection('recipes').doc(id);

    ref.update(recipe.toFirestore()).then(
        (value) => print("Recipe updated, now update the timestamp"),
        onError: (e) => print("Error updating document $e"));

    ref.update({'timestamp': FieldValue.serverTimestamp()}).then(
        (value) => print("timestamp updated!"),
        onError: (e) => print("Error updating document $e"));

    if (history) {
      ref
          .collection('histories')
          .add(recipe.toFirestore())
          .then((value) => print('history added'));
    }
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
        .limit(20)
        .get();
  }

  CollectionReference<Recipe> getRecipeRef() {
    return firestore.collection('recipes').withConverter(
          fromFirestore: Recipe.fromFirestore,
          toFirestore: (Recipe recipe, _) => recipe.toFirestore(),
        );
  }

  // Limit Exceeded in firestore, here I use fixed image instead for demonstration;
  // Future<Uint8List?> getImage(String imgPath) async {
  //   return Image;
  //   try {
  //     return FirebaseStorage.instance.refFromURL(imgPath).getData();
  //   } catch (e) {
  //     return FirebaseStorage.instance
  //         .refFromURL('gs://recipe-sum.appspot.com/logo.png')
  //         .getData();
  //   }
  // }

  void addToFavorite(UserDetails userDetails, Recipe recipe) {
    final ref = firestore.collection('users').doc(userDetails.id);
    ref.update({
      "favorites": FieldValue.arrayUnion([recipe.id]),
    });
    final ref2 = firestore.collection('recipes').doc(recipe.id);
    ref2.update({'bookmarked': FieldValue.increment(1)});
  }

  void removeFromFavorite(
      UserDetails userDetails, Recipe recipe, bool isDelete) {
    final ref = firestore.collection('users').doc(userDetails.id);
    ref.update({
      "favorites": FieldValue.arrayRemove([recipe.id]),
    });
    if (!isDelete) {
      final ref2 = firestore.collection('recipes').doc(recipe.id);
      ref2.update({'bookmarked': FieldValue.increment(-1)});
    }
  }

  void rate(Recipe recipe, double rating, String comment, User user) {
    final ref = firestore.collection('rating');
    ref.add({
      'user_id': user.id,
      'recipe_id': recipe.id,
      'rating': rating,
      'comment': comment
    });
  }

  Future<void> updateRate(
      Recipe recipe, double rating, String comment, User user) async {
    final ref = firestore.collection('rating');
    final res = await ref
        .where('user_id', isEqualTo: user.id)
        .where('recipe_id', isEqualTo: recipe.id)
        .get();
    res.docs.forEach((element) {
      print(element.id);
      ref.doc(element.id).update({'rating': rating, 'comment': comment});
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getRate(
      Recipe recipe, User user) {
    return firestore
        .collection('rating')
        .where('user_id', isEqualTo: user.id)
        .where('recipe_id', isEqualTo: recipe.id)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getRateByRecipe(Recipe recipe) {
    return firestore
        .collection('rating')
        .where('recipe_id', isEqualTo: recipe.id)
        .get();
  }
}
