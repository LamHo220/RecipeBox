import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit() : super(RecipeInitial());
}
