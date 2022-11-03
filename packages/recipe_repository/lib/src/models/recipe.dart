import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Recipe extends Equatable {
  Recipe({
    String? id = null,
    String? original = null,
    String? imgPath = null,
    required this.name,
    required this.description,
    required this.bookmarked,
    required this.cal,
    required this.gram,
    required this.forked,
    required this.ingredients,
    required this.isPublic,
    required this.note,
    required this.steps,
    required this.categories,
    required this.timestamp,
    required this.user,
    required this.time,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4(),
        original = original ?? '',
        imgPath = imgPath ?? '';

  String id;

  String? original;

  final String name;

  final String imgPath;

  final String description;

  final int bookmarked;

  final int cal;

  final int gram;

  final int forked;

  final List<Map<String, dynamic>> ingredients;

  final bool isPublic;

  final String note;

  final List<String> steps;

  final List<String> categories;

  final Timestamp timestamp;

  final String user;

  final Map<String, dynamic> time;

  // TODO: rating and comments

  factory Recipe.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Recipe(
        id: data?['id'] as String?,
        imgPath: data?['imgPath'] as String,
        name: data?['name'] as String,
        description: data?['description'] as String,
        bookmarked: data?['bookmarked'],
        cal: data?['cal'],
        gram: data?['gram'],
        forked: data?['forked'],
        ingredients: data?['ingredients'] is Iterable
            ? List<Map<String, dynamic>>.from(data?['ingredients'])
            : [],
        isPublic: data?['isPublic'] as bool,
        note: data?['note'] as String,
        steps:
            data?['steps'] is Iterable ? List<String>.from(data?['steps']) : [],
        categories: data?['categories'] is Iterable
            ? List<String>.from(data?['categories'])
            : [],
        timestamp: data?['timestamp'] as Timestamp,
        user: data?['user'] as String,
        original: data?['original'] as String?,
        time: Map<String, dynamic>.from(data?['time']));
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "imgPath": this.imgPath,
      "name": this.name,
      "description": this.description,
      "bookmarked": this.bookmarked,
      "cal": this.cal,
      "gram": this.gram,
      "forked": this.forked,
      "ingredients": this.ingredients,
      "isPublic": this.isPublic,
      "note": this.note,
      "steps": this.steps,
      "categories": this.categories,
      "timestamp": this.timestamp,
      "user": this.user,
      "original": original,
      "time": this.time,
    };
  }

  @override
  List<Object> get props => [
        id,
        name,
        description,
        bookmarked,
        cal,
        gram,
        forked,
        ingredients,
        isPublic,
        note,
        steps,
        categories,
        timestamp,
        original ?? '',
        time,
      ];
}
