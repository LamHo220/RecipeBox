import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:recipe_api/recipe_api.dart';
import 'package:uuid/uuid.dart';

part 'recipe.g.dart';

@immutable
@JsonSerializable()
class Recipe extends Equatable {
  Recipe({
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  final String id;

  final String title;

  final String description;

  final bool isCompleted;

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  static Recipe fromJson(JsonMap json) => _$RecipeFromJson(json);

  JsonMap toJson() => _$RecipeToJson(this);

  @override
  List<Object> get props => [id, title, description, isCompleted];
}
