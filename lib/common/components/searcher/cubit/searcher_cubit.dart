import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'searcher_state.dart';

class SearcherCubit extends Cubit<SearcherState> {
  SearcherCubit() : super(SearcherState());

  void controllerChanged(String x) {
    print(x);
  }
}
