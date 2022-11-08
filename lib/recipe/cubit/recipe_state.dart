part of 'recipe_cubit.dart';

class RecipeState extends Equatable {
  RecipeState({
    this.name = const StringInput.pure(),
    this.description = const StringInput.pure(),
    this.cal = 0,
    this.gram = 0,
    this.time = const {'hr': 0, 'min': 0},
    required this.steps,
    required this.ingredients,
    required this.categories,
    // this.errorMessage,
  });

  StringInput name;

  StringInput description;

  double cal;
  double gram;
  Map<String, int> time;

  List<String> categories;

  List<TextEditingController> steps;

  List<Map<String, TextEditingController>> ingredients;

  // final String? errorMessage;

  @override
  List<Object> get props =>
      [name, description, cal, gram, time, categories, steps, ingredients];

  RecipeState copyWith({
    StringInput? name,
    StringInput? description,
    List<TextEditingController>? steps,
    List<Map<String, TextEditingController>>? ingredients,
    double? cal,
    double? gram,
    Map<String, int>? time,
    List<String>? categories,
  }) {
    return RecipeState(
      name: name ?? this.name,
      description: description ?? this.description,
      cal: cal ?? this.cal,
      gram: gram ?? this.gram,
      time: time ?? this.time,
      steps: steps ?? this.steps,
      ingredients: ingredients ?? this.ingredients,
      categories: categories ?? this.categories,
      // errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

enum InputError { empty }

class StringInput extends FormzInput<String, InputError> {
  const StringInput.pure() : super.pure('');

  const StringInput.dirty({String value = ''}) : super.dirty(value);

  @override
  InputError? validator(String value) {
    return value.isNotEmpty == true ? null : InputError.empty;
  }
}
