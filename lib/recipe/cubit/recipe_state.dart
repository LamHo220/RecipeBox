part of 'recipe_cubit.dart';

class RecipeState extends Equatable {
  RecipeState({
    this.title = const StringInput.pure(),
    this.description = const StringInput.pure(),
    this.step = const StringInput.pure(),
    this.ingredient = const StringInput.pure(),
    this.steps = const [],
    this.ingredients = const [],
    this.errorMessage,
  });

  StringInput title;

  StringInput description;

  StringInput step;

  StringInput ingredient;

  List<StringInput> steps;
  List<StringInput> ingredients;

  final String? errorMessage;

  @override
  List<Object> get props => [title];

  RecipeState copyWith({
    StringInput? title,
    StringInput? description,
    List<StringInput>? steps,
    List<StringInput>? ingredients,
    String? errorMessage,
  }) {
    return RecipeState(
      title: title ?? this.title,
      description: description ?? this.description,
      errorMessage: errorMessage ?? this.errorMessage,
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
