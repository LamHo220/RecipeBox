import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:recipe_api/recipe_api.dart';
import 'package:uuid/uuid.dart';

@immutable
@JsonSerializable()
class Recipe extends Equatable {
  Recipe({
    String? id = null,
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
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  String id;

  final String name;

  final String description;

  final int bookmarked;

  final int cal;

  final int gram;

  final int forked;

  final List<Map<String, String>> ingredients;

  final bool isPublic;

  final String note;

  final List<String> steps;

  final List<String> categories;

  final Timestamp timestamp;

  Recipe copyWith({
    String? id,
    String? name,
    String? description,
    int? bookmarked,
    int? cal,
    int? gram,
    int? forked,
    List<Map<String, String>>? ingredients,
    bool? isPublic,
    String? note,
    List<String>? steps,
    List<String>? categories,
    Timestamp? timestamp,
  }) {
    return Recipe(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        bookmarked: bookmarked ?? this.bookmarked,
        cal: cal ?? this.cal,
        gram: gram ?? this.gram,
        forked: forked ?? this.forked,
        ingredients: ingredients ?? this.ingredients,
        isPublic: isPublic ?? this.isPublic,
        note: note ?? this.note,
        steps: steps ?? this.steps,
        categories: categories ?? this.categories,
        timestamp: timestamp ?? this.timestamp);
  }

  static Recipe fromJson(JsonMap json) => Recipe(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      bookmarked: json['bookmarked'] as int,
      cal: json['cal'] as int,
      gram: json['gram'] as int,
      forked: json['forked'] as int,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
      isPublic: json['isPublic'] as bool,
      note: json['note'] as String,
      steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      timestamp: json['timestamp'] as Timestamp);

  JsonMap toJson() => {
        "id": id,
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
        "timestamp": this.timestamp
      };

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
        timestamp
      ];
}
