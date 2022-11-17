part of 'recipe_cubit.dart';

class RecipeState extends Equatable {
  RecipeState({
    required this.id,
    this.name = const StringInput.pure(),
    this.description = const StringInput.pure(),
    this.cal = 0,
    this.gram = 0,
    this.time = const {'hr': 0, 'min': 0},
    this.isPublic = false,
    this.note = '',
    this.original = null,
    this.flag = false,
    required this.steps,
    required this.ingredients,
    required this.categories,
  });

  StringInput name;

  StringInput description;

  String id;
  int cal;
  int gram;
  Map<String, int> time;
  bool isPublic;
  String note;

  List<Categories> categories;

  List<TextEditingController> steps;

  List<Map<String, TextEditingController>> ingredients;

  String? original;

  bool flag;

  @override
  List<Object> get props => [
        id,
        name,
        description,
        cal,
        gram,
        time,
        categories,
        steps,
        ingredients,
        isPublic,
        note,
        flag
      ];

  RecipeState copyWith(
      {StringInput? name,
      StringInput? description,
      List<TextEditingController>? steps,
      List<Map<String, TextEditingController>>? ingredients,
      int? cal,
      int? gram,
      Map<String, int>? time,
      List<Categories>? categories,
      String? note,
      bool? isPublic,
      XFile? imageFile,
      bool? flag}) {
    return RecipeState(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      cal: cal ?? this.cal,
      gram: gram ?? this.gram,
      time: time ?? this.time,
      steps: steps ?? this.steps,
      ingredients: ingredients ?? this.ingredients,
      categories: categories ?? this.categories,
      note: note ?? this.note,
      isPublic: isPublic ?? this.isPublic,
      flag: flag ?? this.flag
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
