import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authenticationRepository.currentUser,
                  authenticationRepository.currentUserDetails)
              : const AppState.unauthenticated(),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(
          AppUserChanged(user, _authenticationRepository.currentUserDetails)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;
  RecipeRepository recipeRepo = RecipeRepository();

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    emit(
      event.user.isNotEmpty
          ? AppState.authenticated(event.user, event.userDetails)
          : const AppState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  void addToFavorite(User user, Recipe recipe) {
    recipeRepo.addToFavorite(user, recipe);
    final x = [...state.userDetails.favorites];
    x.add(recipe.id);
    emit(state.copyWith(x));
  }

  void removeFromFavorite(User user, Recipe recipe) {
    recipeRepo.removeFromFavorite(user, recipe);
    final x = [...state.userDetails.favorites];
    x.remove(recipe.id);
    emit(state.copyWith(x));
  }

  void updateUserDetails(UserDetails userDetails) {
    emit(state.updteWith(userDetails));
  }
}
