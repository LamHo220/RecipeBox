import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setTab(Tabs tab) => emit(HomeState(tab: tab));
  void setShow(bool flag) => emit(HomeState(isShow: flag));

  Future<QuerySnapshot<Recipe>> test() async {
    RecipeRepository repo = RecipeRepository();
    return repo.getRecipe('user', isNotEqualTo: '');
  }
}
