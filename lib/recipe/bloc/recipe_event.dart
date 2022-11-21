part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class PickingImage extends RecipeEvent {
  final XFile file;
  PickingImage(this.file);
}

class UnPickingImage extends RecipeEvent {}

class CroppingImage extends RecipeEvent {
  final CroppedFile file;
  CroppingImage(this.file);
}

class UnCroppingImage extends RecipeEvent {}